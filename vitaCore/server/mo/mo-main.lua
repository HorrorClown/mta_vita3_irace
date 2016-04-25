--[[
Project: vitaCore
File: mo-main.lua
Author(s):	Sebihunter
]]--


gGamemodeMO = 6
gElementMO = createElement("elementMO")

local arena = createObject(8838,2226.7998000,-3400.3994000,-58.3000000,0.0000000,0.0000000,0.0000000) --object(vgehshade01_lvs) (1)
setElementDimension(arena, gGamemodeMO)
setObjectScale(arena, 12)

monopolyTables = {}
monopolyTables[1] = {tX = 598.79999, tY = -83.1, tZ = 975.20001, tRot = 356}
monopolyTables[2] = {tX = 595.09998, tY = -82.9, tZ = 975.20001, tRot = 40}
monopolyTables[3] = {tX = 594.90002, tY = -79.1, tZ = 975.20001, tRot = 336}
monopolyTables[4] = {tX = 598.90002, tY = -79.6, tZ = 975.20001, tRot = 42}
monopolyTables[5] = {tX = 597, tY = -76.3, tZ = 975.20001, tRot = 325.995}
monopolyTables[6] = {tX = 599.20001, tY = -71.8, tZ = 975, tRot = 31.995}
monopolyTables[7] = {tX = 595.20001, tY = -72.4, tZ = 975, tRot = 347.992}
monopolyTables[8] = {tX = 597.90002, tY = -68.4, tZ = 975, tRot = 49.992}
monopolyTables[9] = {tX = 594.09961, tY = -66.70019, tZ = 975, tRot = 5.988}
monopolyTables[10] = {tX = 593.5, tY = -69.8, tZ = 975, tRot = 5.988}

for _, value in ipairs(monopolyTables) do
	local theTable = createObject(2112, value.tX, value.tY, value.tZ, 0, 0, value.tRot)
	if theTable then
		setElementInterior(theTable, 11)
		setElementDimension(theTable, gGamemodeMO)
		local elem = createElement("monopolyTable")
		setElementData(elem, "obj", theTable)
		setElementData(elem, "state", "open")
		setElementData(elem, "password", false)
		setElementData(elem, "players", {})
		local object = createObject(5422, value.tX, value.tY, value.tZ+0.43, 0, 270, value.tRot)
		setElementCollisionsEnabled ( object, false )
		setElementInterior(object, 11)
		setElementDimension(object, gGamemodeMO)
		setObjectScale(object, 0.1)
	end
end	

function joinMO(player)
	--DISABLING MODE
	if player then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This gamemode is deactivated.") return false end
	
	if getPlayerGameMode(player) == gGamemodeMO then return false end
	if #getGamemodePlayers(gGamemodeMO) >= gRaceModes[gGamemodeMO].maxplayers then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This gamemode is currently full.") return false end
	
	setElementData(player, "gameMode", gGamemodeMO)
	setElementAlpha(player, 255)
	setElementData(player, "AFK", false)
	setPlayerNametagShowing ( player, true )
	toggleControl ( player, "enter_exit", true )
	
	spawnPlayer(player, 590.6,-63.8,975.6,180, getElementData(player, "Skin"), 11, gGamemodeMO)
	setCameraTarget(player, player)
	
	setElementData(player, "mapname", false)
	triggerClientEvent ( player, "addNotification", getRootElement(), 2, 15,150,190, "You joined 'Monopoly'." )
	triggerClientEvent ( player, "hideSelection", getRootElement() )
	outputChatBoxToGamemode ( "#CCFF66:JOIN: #FFFFFF"..getPlayerName(player).."#FFFFFF has joined the gamemode.", gGamemodeMO, 255, 255, 255, true )
	callClientFunction ( player, "toggleClientLobbyMO",  true)	
	callClientFunction ( player, "replaceModelsMO")	
	
	setElementData(player, "state", "alive")
end
addEvent("joinMO", true)
addEventHandler("joinMO", getRootElement(), joinMO)

function moReceiveServerChat(text)
	if isElement(source) and text then
		local mTable = getElementData(source, "mTable")
		if mTable then
			if #getElementData(mTable, "players") ~= 0 then
				for i,v in ipairs(getElementData(mTable, "players")) do
					callClientFunction(v, "receiveMonopolyLobbyChat", source, text)
				end
			end
		end
	end
end
addEvent("moReceiveServerChat", true)
addEventHandler("moReceiveServerChat", getRootElement(), moReceiveServerChat)

function forceListRefresh()
	if isElement(source) then
		local mTable = getElementData(source, "mTable")
		if mTable then
			if #getElementData(mTable, "players") ~= 0 then
				for i,v in ipairs(getElementData(mTable, "players")) do
					callClientFunction(v, "forceListRefresh", source)
				end
			end
		end
	end
end
addEvent("forceListRefresh", true)
addEventHandler("forceListRefresh", getRootElement(), forceListRefresh)

function removePlayerMO(tbl, player, kicked)
	if isElement(tbl) and isElement(player) then
		local players = getElementData(tbl, "players")
		for i,v in ipairs(players) do
			if v == player then table.remove(players, i) end
		end
		triggerEvent("moReceiveServerChat", player, ">> left")
		if getElementData(player, "mHost") and #players ~= 0 then
			setElementData(players[1], "mHost", true)
			triggerEvent("moReceiveServerChat", players[1], ">> is the new host")
		end
		if #players == 0 then
			setElementData(tbl, "password", false)
			setElementData(tbl, "state", "open")
		end
		if kicked then
			callClientFunction ( player, "toggleClientTableMO",  false)	
			callClientFunction ( player, "toggleClientLobbyMO",  true)	
			triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "You got kicked from the table.")
		end		
		setElementData(tbl, "players", players)
		setElementData(player, "mTable", false)
	end
end
addEvent("removePlayerMO", true)
addEventHandler("removePlayerMO", getRootElement(), removePlayerMO)

function quitMO(player)
	if getPlayerGameMode(player) ~= gGamemodeMO then return false end
		
	
	setElementData(player, "gameMode", 0)
	setElementData( player, "ghostmod", false )
	setPlayerNametagShowing ( player, false )
	spawnPlayer(player, 0,0,0)
	setElementDimension(player, 0)
	setElementInterior(player, 0)
	setElementFrozen(player, true)
	outputChatBoxToGamemode ( "#FF6666:QUIT: #FFFFFF"..getPlayerName(player).."#FFFFFF has left the gamemode.", gGamemodeMO, 255, 255, 255, true )
	callClientFunction ( player, "toggleClientLobbyMO", false)	
	callClientFunction ( player, "toggleClientTableMO",  false)	
	callClientFunction ( player, "engineRestoreModel", 5442)
	callClientFunction ( player, "engineRestoreModel", 8838)	
	callClientFunction ( player, "engineRestoreCOL", 8838)

	if #getGamemodePlayers(gGamemodeMO) == 1 then
		for i,v in ipairs(getGamemodePlayers(gGamemodeMO)) do
			triggerClientEvent(v, "foreveraloneClient",getRootElement())
			addPlayerArchivement(v, 64)
		end
	end
	
end
addEvent("quitMO", true)
addEventHandler("quitMO", getRootElement(), quitMO)


function killMOPlayer(player, noSpectate, killer, weapon)
	if isInGamemode(player, gGamemodeMO) == false then return end
	spawnPlayer(player, 590.6,-63.8,975.6,180, getElementData(player, "Skin"), 11,gGamemodeMO)
	setCameraTarget(player, player)
end

function onPlayerWastedMO(ammo, killer, killerWeapon, bodypart, stealth)
	if isInGamemode(source, gGamemodeMO) then
		killMOPlayer(source, false, killer, killerWeapon)
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerWastedMO )

function startMonopolyGame(mTable)
	setElementData(mTable, "state", "running")
	local players = getElementData(mTable, "players")
	local objects = {}
	for i,v in ipairs(players) do
	
		local object = createObject(2485, gMonopolyField[1].pos[1]+(i-1)*gMonopolyField[1].xPos, gMonopolyField[1].pos[2]+(i-1)*gMonopolyField[1].yPos, gMonopolyField[1].pos[3]+5, 0,0,gMonopolyField[1].rot, true)
		setObjectScale(object, 3)
		setElementDimension(object, gGamemodeMO)
		setElementData(v, "mObject", object)
		setElementData(v, "mField", 1)
		setElementData(v, "mTurn",0)
		setElementData(v, "mTabState",3)
		setElementData(v, "mMoney", 30000)
		setElementInterior(v, 0)
		setElementPosition(v,2226.7998000,-3400.3994000,150)
		setCameraMatrix(v, 2226.7998000,-3400.3994000,100, 2226.7998000,-3400.3994000,0)
		setElementFrozen(v, true)
		callClientFunction ( v, "toggleClientTableMO",  false, true)	
		callClientFunction ( v, "clientStartMO",  true)	
		objects[#objects+1] = object
		
		for i2, v2 in ipairs(players) do
			callClientFunction(v2, "replaceModelMO", object, i)
		end
	end
	
	setElementData(mTable, "objects", objects)
	setTimer( startTurnMO, 3000, 1, mTable, players[1])
end
addEvent("startMonopolyGame", true)
addEventHandler("startMonopolyGame", getRootElement(), startMonopolyGame)

function setMonopolyMoney(mTable, player, money)
	local omoney = getElementData(player, "mMoney")
	local dif = money-omoney
	setElementData(player, "mMoney", money)
	if dif ~= 0 then
		local players = getElementData(mTable, "players")
		for i,v in ipairs(players) do
			callClientFunction(v, "moneyChangeMO", player, dif)
		end	
	end
end
addEvent("setMonopolyMoney", true)
addEventHandler("startMoveMO", getRootElement(),setMonopolyMoney)

function startMoveMO(mTable, player, fields)
	local players = getElementData(mTable, "players")
	for i,v in ipairs(players) do
		callClientFunction(v, "toggleDiceMO", false, false)
		callClientFunction(v, "playSound", "files/audio/ware/local_exo_won2.wav")
	end
	 movePlayerMO(mTable, player, fields)
end
addEvent("startMoveMO", true)
addEventHandler("startMoveMO", getRootElement(), startMoveMO)

function movePlayerMO(mTable, player, fields)
	--TODO MOVE SOUND
	setElementData(mTable, "moves", fields)
	local field = getElementData(player, "mField")
	local object = getElementData(player, "mObject")
	for i = 1, fields do
		field = field+1
		if not gMonopolyField[field] then
			field = 1
		end
		if i == 1 then
			--TODO ROTATION ANIMATION
			setElementRotation(object, 0, 0, gMonopolyField[field].rot)
			moveObject ( object, 1000, gMonopolyField[field].pos[1]+(getElementData(mTable, "turnPlayerID")-1)*gMonopolyField[field].xPos, gMonopolyField[field].pos[2]+(getElementData(mTable, "turnPlayerID")-1)*gMonopolyField[field].yPos, gMonopolyField[field].pos[3]+5, 0,0,0, "InOutQuad" )
			if fields == 1 then
				setTimer(function(object, mTable, player,field)
					setElementData(mTable, "moves", getElementData(mTable, "moves")-1)
					if isElement(object) then
						moveFinishedMO(mTable,player,field)
						setElementData(mTable, "moves", false)
					end
				end, 1000,1,object, mTable, player, field)
			end
		else
			setTimer(function(object, mTable, player,field, i)
				if isElement(object) then	
					--TODO ROTATION ANIMATION
					setElementData(mTable, "moves", getElementData(mTable, "moves")-1)
					setElementRotation(object, 0, 0, gMonopolyField[field].rot)
					moveObject ( object, 1000, gMonopolyField[field].pos[1]+(getElementData(mTable, "turnPlayerID")-1)*gMonopolyField[field].xPos, gMonopolyField[field].pos[2]+(getElementData(mTable, "turnPlayerID")-1)*gMonopolyField[field].yPos, gMonopolyField[field].pos[3]+5, 0,0,0, "InOutQuad" )
					if i == fields then
						setTimer(function(object, mTable, player,newfield)
							setElementData(mTable, "moves", getElementData(mTable, "moves")-1)
							if isElement(object) then
								moveFinishedMO(mTable,player,newfield)
								setElementData(mTable, "moves", false)
							end
						end,1000,1,object,mTable,player, field)
					end	
				end
			end, 1000*(i-1),1,object, mTable, player, field,i)
		end
	end
end
addEvent("movePlayerMO", true)
addEventHandler("movePlayerMO", getRootElement(), movePlayerMO)

function moveFinishedMO(mTable,player,field)
	setElementData(player, "mField", field)
	
	local players = getElementData(mTable, "players")
	if players[getElementData(mTable, "turnPlayerID")+1] then
		startTurnMO(mTable, players[getElementData(mTable, "turnPlayerID")+1])
	else
		startTurnMO(mTable, players[1])
	end
end

function startTurnMO(mTable, player)
	if not isElement(mTable) or not isElement(player) then return end
	setElementData(player, "mTurn", getElementData(player, "mTurn")+1)
	
	local players = getElementData(mTable, "players")
	for i,v in ipairs(players) do
		if v == player then
			setElementData(mTable, "turnPlayerID", i)
		end
		callClientFunction ( v, "startTurnMO",  player)	
	end
	setTimer(startDiceMO, 3000, 1, mTable, player)
end

function startDiceMO(mTable, player)
	if not isElement(mTable) or not isElement(player) then return end
	local players = getElementData(mTable, "players")
	for i,v in ipairs(players) do
		callClientFunction ( v, "toggleDiceMO",  true, player)	
	end
end

function syncDiceMO(mTable, player, dice, number)
	if not isElement(mTable) or not isElement(player) then return end
	local players = getElementData(mTable, "players")
	for i,v in ipairs(players) do
		if v ~= player then
			callClientFunction ( v, "setDiceToNumber",  dice, number)	
		end
	end	
end
addEvent("syncDiceMO", true)
addEventHandler("syncDiceMO", getRootElement(), syncDiceMO)