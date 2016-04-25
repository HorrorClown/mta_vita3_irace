--[[
Project: vitaCore
File: mo-client.lua
Author(s):	Sebihunter
]]--


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABLES--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

gIsLobbyShownMO = false

local mPlayerList = 0

local tabledx = {}
local tablegui = {}
tabledx["back"] = dxCreateButton(screenWidth/2 + 710/2-115,screenHeight/2 + 394/2-40,100,24,"leave table",false)

tablegui["password"] = guiCreateEdit (  screenWidth/2 - 710/2+100, screenHeight/2 - 394/2+150, 150, 20, "", false )
tablegui["pw_check"] = guiCreateCheckBox (  screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+190, 20,17, "passworded?", false, false )
tabledx["create_table"] = dxCreateButton(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+225,200,24,"create table",false)

tabledx["playerlist"] = dxCreateGridList(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+60,130,200)
tabledx["chatlist"] = dxCreateGridList(screenWidth/2 - 710/2+150, screenHeight/2 - 394/2+60,510,160)
tablegui["chatbox"] = guiCreateEdit (  screenWidth/2 - 710/2+150, screenHeight/2 - 394/2+225, 400,33, "", false )
tabledx["chatsend"] = dxCreateButton(screenWidth/2 - 710/2+560, screenHeight/2 - 394/2+225,100,33,"send",false)

tabledx["ready"] = dxCreateButton(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+265,80,33,"ready",false)
tabledx["kick"] = dxCreateButton(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+303,100,33,"kick player",false)
tabledx["start"] = dxCreateButton(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+341,100,33,"start game",false)

tablegui["password_2"] = guiCreateEdit (  screenWidth/2 - 710/2+100, screenHeight/2 - 394/2+150, 150, 20, "", false )
tabledx["join_pw"] = dxCreateButton(screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+190,200,24,"join table",false)

for i,v in pairs(tabledx) do
	dxSetVisible(v, false)
end
for i,v in pairs(tablegui) do
	guiSetVisible(v, false)
end


local forceRefresh = false
function forceListRefresh()
	forceRefresh = true
end

function toggleClientTableMO(toggle, keep)
	if toggle == true then
		if not isEventHandlerAdded( "onClientRender", getRootElement(), renderTableMO ) then
			addEventHandler("onClientRender", getRootElement(), renderTableMO )
			addEventHandler("onClientKey", getRootElement(), pressTableMO)
			showChat(false)
			showCursor ( true )
			gIsLobbyShownMO = true
		end
	else
		if isEventHandlerAdded( "onClientRender", getRootElement(), renderTableMO  ) then
			removeEventHandler("onClientRender", getRootElement(), renderTableMO )
			removeEventHandler("onClientKey", getRootElement(), pressTableMO)
			showChat(true)
			for i,v in pairs(tabledx) do
				dxSetVisible(v, false)
			end
			for i,v in pairs(tablegui) do
				guiSetVisible(v, false)
			end			
			showCursor (false)
			gIsLobbyShownMO = false
			if keep == true then return false end
			if getElementData(getLocalPlayer(), "mTable") then
				triggerServerEvent ( "removePlayerMO", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"), getLocalPlayer() )
			end
		end
	end
end

addEventHandler ( "onClientDXClick", tabledx["kick"] , function(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( tabledx["playerlist"] )
		if row ~= false and dxGridListGetItemData (tabledx["playerlist"], row ) then
			sendMonopolyLobbyChat(getLocalPlayer(), ">> kicked "..getPlayerName(dxGridListGetItemData (tabledx["playerlist"], row )))
			triggerServerEvent ( "removePlayerMO", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"), dxGridListGetItemData (tabledx["playerlist"], row ), true )
		end
	end
end, false)

addEventHandler ( "onClientDXClick", tabledx["start"] , function(button)
	if button == "left" then
		local mTable = getElementData(getLocalPlayer(), "mTable")
		local players = getElementData(mTable, "players")
		local notReady = false
		--if #players < 2 then addNotification(1, 200, 50, 50, "You need to be at least 2 players.") return end
		for i,v in ipairs(players) do
			if not getElementData(v, "mReady") then
				addNotification(1, 200, 50, 50, "Not every player is ready.")
				return
			end
		end
		triggerServerEvent ( "startMonopolyGame", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"))
	end
end, false)

addEventHandler ( "onClientDXClick", tabledx["ready"] , function(button)
	if button == "left" then
		if getElementData(getLocalPlayer(), "mReady") then
			sendMonopolyLobbyChat(getLocalPlayer(), ">> is no longer ready")
			setElementData(getLocalPlayer(), "mReady", false)
			triggerServerEvent ( "forceListRefresh", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"))
		else
			sendMonopolyLobbyChat(getLocalPlayer(), ">> is ready")
			setElementData(getLocalPlayer(), "mReady", true)
			triggerServerEvent ( "forceListRefresh", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"))
		end
	end
end, false)

addEventHandler ( "onClientDXClick", tabledx["join_pw"] , function(button)
	if button == "left" then
		local text = guiGetText(tablegui["password_2"])
		if text == getElementData(moPasswordedTemp, "password") then
			joinRunningLobby(moPasswordedTemp)
		else
			addNotification(1, 200, 50, 50, "Wrong password.")
		end
	end
end, false)

addEventHandler ( "onClientDXClick", tabledx["chatsend"] , function(button)
	if button == "left" then
		local text = guiGetText(tablegui["chatbox"])
		sendMonopolyLobbyChat(getLocalPlayer(), text)
	end
end, false)

function pressTableMO(button, press)
	if button == "enter" and press then
		if dxGetVisible(tabledx["chatsend"]) then
			local text = guiGetText(tablegui["chatbox"])
			sendMonopolyLobbyChat(getLocalPlayer(), text)	
		end
	end
end

function sendMonopolyLobbyChat(player, text)
	if isElement(player) and 0 < string.len(text) and string.len(text) < 60 then
		triggerServerEvent ( "moReceiveServerChat", getLocalPlayer(), text)
		guiSetText(tablegui["chatbox"], "")
	else
		dxGridListAddRowAndBottom ( tabledx["chatlist"], "Error: Chat message is too long to be sent.", v)
		playSound("files/monopoly/chat.mp3")
	end
end

function receiveMonopolyLobbyChat(player, text)
	dxGridListAddRowAndBottom ( tabledx["chatlist"], getPlayerName(player)..": "..text, player)
	playSound("files/monopoly/chat.mp3")
end

addEventHandler ( "onClientDXClick", tabledx["create_table"] , function(button)
	if button == "left" then
		if not isElement(getElementData(getLocalPlayer(), "mTable")) then return end
		setElementData(getLocalPlayer(), "mTabState", 1)
		local pw = false
		if guiCheckBoxGetSelected ( tablegui["pw_check"] ) and guiGetText(tablegui["password"]) ~= "" then
			setElementData(getElementData(getLocalPlayer(), "mTable"), "password", guiGetText(tablegui["password"]))
			addNotification(2, 50, 200, 50, "You created a private table (PW: "..guiGetText(tablegui["password"])..").")
			dxGridListAddRowAndBottom ( tabledx["chatlist"], "You created a private table (PW: "..guiGetText(tablegui["password"])..").", false)
			playSound("files/monopoly/chat.mp3")
		else
			addNotification(2, 50, 200, 50, "You created a public table.")
			dxGridListAddRowAndBottom ( tabledx["chatlist"], "You created a public table.", false)
			playSound("files/monopoly/chat.mp3")
		end
		setElementData(getElementData(getLocalPlayer(), "mTable"), "state", "open")
	end
end, false ) 

addEventHandler ( "onClientDXClick", tabledx["back"] , function(button)
	if button == "left" then
		setElementData(getLocalPlayer(), "mTabState", false)
		toggleClientTableMO(false)
		toggleClientLobbyMO(true)
		addNotification(2, 50, 200, 50, "You left the table.")
	end
end, false ) 

function renderTableMO()
	if getElementData(getLocalPlayer(), "mTabState") == false then toggleClientTableMO(false) end
	local mTable = getElementData(getLocalPlayer(), "mTable")
	for i,v in pairs(tabledx) do
		dxSetVisible(v, false)
	end
	for i,v in pairs(tablegui) do
		guiSetVisible(v, false)
	end	
	dxSetVisible(tabledx["back"], true)

	if mTable and isElement(mTable) then
		if mPlayerList ~= #getElementData(mTable, "players") or forceRefresh then
			forceRefresh = false
			mPlayerList = #getElementData(mTable, "players")
			dxGridListClear(tabledx["playerlist"])
			for i,v in ipairs(getElementData(mTable, "players")) do
				if getElementData(v, "mReady") then
					if getElementData(v, "mHost") then
						dxGridListAddRow ( tabledx["playerlist"], "H/R: "..getPlayerName(v), v)
					else
						dxGridListAddRow ( tabledx["playerlist"], "R: "..getPlayerName(v), v)
					end
				else
					if getElementData(v, "mHost") then
						dxGridListAddRow ( tabledx["playerlist"], "H: "..getPlayerName(v), v)
					else
						dxGridListAddRow ( tabledx["playerlist"], getPlayerName(v), v)
					end
				end
			end
		end
	end
	
	dxDrawImageSection ( 0, 0, screenWidth, screenWidth, 960-screenWidth/2, 0, screenWidth, screenWidth, "files/monopoly/monopolybackground.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)	
	dxDrawImage(screenWidth/2 - 710/2, screenHeight/2 - 394/2, 710, 394,	"files/monopoly/monopolywindow.png", 0,0,0, tocolor(255,255,255,255), false)	
	
	
	if getElementData(getLocalPlayer(), "mTabState") == 0 then -- open a new table
		guiSetVisible(tablegui["password"], true)
		guiSetVisible(tablegui["pw_check"], true)
		dxSetVisible(tabledx["create_table"], true)
		
		dxDrawText ( "creating a table", 0, screenHeight/2 - 394/2 + 8, screenWidth, screenHeight, tocolor(255,255,255), 1, "default-bold", "center","top")
		dxDrawText ( "You are currently creating a new table joinable for other players!\nPlease choose wether your game is public or private (via password).\nPrivate games can only be joined by invited people having a correct password.", screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+40, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
		dxDrawText ( "password:", screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+150, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
		dxDrawText ( "private table?", screenWidth/2 - 710/2+35, screenHeight/2 - 394/2+191, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
	elseif getElementData(getLocalPlayer(), "mTabState") == 1 then
		local pw = getElementData(mTable, "password")
		if pw then
			dxDrawText ( "private table", 0, screenHeight/2 - 394/2 + 8, screenWidth, screenHeight, tocolor(255,255,255), 1, "default-bold", "center","top")
		else
			dxDrawText ( "public table", 0, screenHeight/2 - 394/2 + 8, screenWidth, screenHeight, tocolor(255,255,255), 1, "default-bold", "center","top")
		end
		
		dxSetVisible(tabledx["playerlist"], true)
		dxSetVisible(tabledx["chatlist"], true)
		guiSetVisible(tablegui["chatbox"], true)
		dxSetVisible(tabledx["chatsend"], true)
		dxSetVisible(tabledx["ready"], true)
		
		if getElementData(getLocalPlayer(), "mHost") then
			dxSetVisible(tabledx["kick"], true)
			dxSetVisible(tabledx["start"], true)
		end
		dxDrawText ( "Players:", screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+40, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
		dxDrawText ( "Chat:", screenWidth/2 - 710/2+150, screenHeight/2 - 394/2+40, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
	elseif getElementData(getLocalPlayer(), "mTabState") == 2 then
		guiSetVisible(tablegui["password_2"], true)
		dxSetVisible(tabledx["join_pw"], true)
	
		dxDrawText ( "private table", 0, screenHeight/2 - 394/2 + 8, screenWidth, screenHeight, tocolor(255,255,255), 1, "default-bold", "center","top")
		dxDrawText ( "This is a private protected table.\nIn order to join it you need to enter the correct password.", screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+40, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
		dxDrawText ( "password:", screenWidth/2 - 710/2+15, screenHeight/2 - 394/2+150, screenWidth, screenHeight, tocolor(0,0,0,255), 1.2, "default-bold", "left","top")
	end
end


function joinRunningLobby(lobby)
	if #getElementData(lobby, "players") == 4 then
		addNotification(1, 200, 50, 50, "This table is already full.")
	elseif getElementData(lobby, "state") ~= "open" then
		addNotification(1, 200, 50, 50, "This game has already started.")
	else
		setElementData(getLocalPlayer(), "mTable", lobby)
		setElementData(getLocalPlayer(), "mHost", false)
		setElementData(getLocalPlayer(), "mTabState", 1)
		setElementData(getLocalPlayer(), "mReady", false)
		toggleClientLobbyMO(false)
		toggleClientTableMO(true)			
		local players = getElementData(lobby, "players")
		players[#players+1] = getLocalPlayer()
		setElementData(lobby, "players", players)
		forceListRefresh()
		sendMonopolyLobbyChat(getLocalPlayer(), ">> joined")
		addNotification(2, 50, 200, 50, "You joined a table.")
	end
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--LOBBY--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local bartender = createPed(199, 586.076,-73.404930114746,975.62756347656)
setElementInterior(bartender, 11)
setElementDimension(bartender, 6)
setElementFrozen(bartender, true)

local music = playSound3D("http://onair-ha1.krone.at/kronehit-vollgas.mp3.m3u", 587.43609619141,-73.404930114746,975.62756347656, true)
setSoundMaxDistance ( music, 80 )
setElementInterior(music, 11)
setElementDimension(music, 6)

function replaceModelsMO()
	local txd = engineLoadTXD('files/monopoly/laespraydoor1-5422.txd',true)
    engineImportTXD(txd, 5422)

	local txd = engineLoadTXD('files/monopoly/a.txd',true)
    engineImportTXD(txd, 8838)

	local dff = engineLoadDFF('files/monopoly/a.dff', 0) 
	engineReplaceModel(dff, 8838)

	local col = engineLoadCOL('files/monopoly/a.col') 
	engineReplaceCOL(col, 8838)

	engineSetModelLODDistance(8838, 500)
end

function checkInvinciblePed()
	cancelEvent()
end
addEventHandler("onClientPedDamage",bartender,checkInvinciblePed)

function toggleClientLobbyMO(toggle)
	if toggle == true then
		if not isEventHandlerAdded( "onClientRender", getRootElement(), renderLobbyMO ) then
			addEventHandler("onClientRender", getRootElement(), renderLobbyMO, true, "low+1")
			addEventHandler("onClientKey", getRootElement(), pressLobbyMO)
		end
	else
		if isEventHandlerAdded( "onClientRender", getRootElement(), renderLobbyMO  ) then
			removeEventHandler("onClientRender", getRootElement(), renderLobbyMO )
			removeEventHandler("onClientKey", getRootElement(), pressLobbyMO)
		end
	end
end

function pressLobbyMO(button, press)
	if button == "e" and press then
		local mX, mY, mZ = getElementPosition(getLocalPlayer())
		
		if getDistanceBetweenPoints3D ( mX, mY, mZ, 586.076,-73.404930114746,975.62756347656 ) < 3 then
			local dX, dY = getScreenFromWorldPosition (  586.076,-73.404930114746,976.62756347656, 0, false )
			if dX then
				addNotification(1, 200, 50, 50, "Cannot change music.\nYou need to be a donator.")
				return
			end
		end		
		
		for i,v in ipairs(getElementsByType("monopolyTable")) do
			local obj = getElementData(v, "obj")
			local sX, sY, sZ = getElementPosition(obj)
			if getDistanceBetweenPoints3D ( mX, mY, mZ, sX, sY, sZ ) < 3 then
				local dX, dY = getScreenFromWorldPosition ( sX, sY, sZ+0.5, 0, false )
				if dX then
					dxGridListClear(tabledx["chatlist"])
					if  getElementData(v, "state") == "open" and #getElementData(v, "players") ~= 0 then
						if getElementData(v, "password") then
							moPasswordedTemp = v
							setElementData(getLocalPlayer(), "mTabState", 2)		
							toggleClientLobbyMO(false)
							toggleClientTableMO(true)
						else
							joinRunningLobby(v)
						end
					elseif getElementData(v, "state") == "open" then		
						setElementData(getLocalPlayer(), "mTabState", 0)
						setElementData(v, "players", {getLocalPlayer()})
						setElementData(v, "state", "setup")
						setElementData(getLocalPlayer(), "mTable", v)
						setElementData(getLocalPlayer(), "mHost", true)
						setElementData(getLocalPlayer(), "mReady", false)
						toggleClientLobbyMO(false)
						toggleClientTableMO(true)
						addNotification(2, 50, 200, 50, "You created a new table.")
					end
					return
				end
			end	
		end		
	end
end
--23
--124
--147
function renderLobbyMO ()
	local mX, mY, mZ = getElementPosition(getLocalPlayer())
	if getDistanceBetweenPoints3D ( mX, mY, mZ, 586.076,-73.404930114746,975.62756347656 ) < 3 then
		local dX, dY = getScreenFromWorldPosition (  586.076,-73.404930114746,976.62756347656, 0, false )
		if dX then	
			dxDrawImage(dX-31, dY-31,62,62,"files/monopoly/monopolyE.png", 0,0,0, tocolor(255,255,255,255), false)
			--dxDrawShadowedText ( "Bartender Berta\npress 'E' to interact", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
			return
		end
	end
	for i,v in ipairs(getElementsByType("monopolyTable")) do
		local obj = getElementData(v, "obj")
		local sX, sY, sZ = getElementPosition(obj)
		if getDistanceBetweenPoints3D ( mX, mY, mZ, sX, sY, sZ ) < 3 then
			local dX, dY = getScreenFromWorldPosition ( sX, sY, sZ+0.5, 0, false )
			if dX then
				if getElementData(v, "state") == "running" then
					dxDrawImage(dX-15.5, dY-15.5,73.5,73.5,"files/monopoly/monopolyRunningE.png", 0,0,0, tocolor(255,255,255,255), false)
					--dxDrawShadowedText ( "game in progress", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
				elseif getElementData(v, "state") == "setup" then
					dxDrawImage(dX-15.5, dY-15.5,73.5,73.5,"files/monopoly/monopolySettingsE.png", 0,0,0, tocolor(255,255,255,255), false)
					--dxDrawShadowedText ( "changing settings", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
				elseif  getElementData(v, "state") == "open" and #getElementData(v, "players") ~= 0 then
					if getElementData(v, "password") then
						dxDrawImage(dX-15.5, dY-15.5,73.5,73.5,"files/monopoly/monopolyPrivateE.png", 0,0,0, tocolor(255,255,255,255), false)
						--dxDrawShadowedText ( "passworded table\npress 'E' to join game", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
					else
						dxDrawImage(dX-15.5, dY-15.5,73.5,73.5,"files/monopoly/monopolyPublicE.png", 0,0,0, tocolor(255,255,255,255), false)
						--dxDrawShadowedText ( "public table\npress 'E' to join game", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
					end
				else
					dxDrawImage(dX-15.5, dY-15.5,73.5,73.5,"files/monopoly/monopolyEmptyE.png", 0,0,0, tocolor(255,255,255,255), false)
					--dxDrawShadowedText ( "empty table\npress 'E' to host game", dX-1, dY-1, dX+1, dY+1, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )	
				end
				return
			end
		end	
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--GAME--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function replaceModelMO(object, id)
	local texture = dxCreateTexture("files/monopoly/tex"..id..".png","dxt1")
	local shader = dxCreateShader("files/shader/texreplace.fx")
	dxSetShaderValue(shader,"gTexture",texture)
	engineApplyShaderToWorldTexture(shader,"CJ_CARDBOARD", object)
end

function clientStartMO()
	showInfoMO("New game", "is starting")
	setWeather ( 0 )
	setTime ( 12,00 )
	setMinuteDuration ( 3600000 )
	local mTable = getElementData(getLocalPlayer(), "mTable")
	local players = getElementData(mTable, "players")
	if not isEventHandlerAdded( "onClientRender", getRootElement(), renderGameMO ) then
		addEventHandler("onClientRender", getRootElement(), renderGameMO )
		showChat(false)
		showCursor ( true )
	end	
end


--TODO clientEndMO
local renderPosMO ={{10,10}, {screenWidth-10-143, 10}, {10, screenHeight-10-203}, {screenWidth-10-143, screenHeight-10-203} }

function renderGameMO()
	local mTable = getElementData(getLocalPlayer(), "mTable")
	local players = getElementData(mTable, "players")
	for i,v in ipairs(players) do
		dxDrawImage(renderPosMO[i][1],renderPosMO[i][2], 143, 203, "files/monopoly/"..i..".png", 0,0,0, tocolor(255,255,255,255), false)	
		
		if fileExists("files/wave/skins/"..getElementData(v, "Skin")..".png") then
			dxDrawImage(renderPosMO[i][1]+26,renderPosMO[i][2]+29, 85, 78,"files/wave/skins/"..getElementData(v, "Skin")..".png",0,0,0, tocolor(255,255,255,255), false)
		else
			dxDrawImage(renderPosMO[i][1]+26,renderPosMO[i][2]+29, 85, 78,"files/wave/skins/0.png",0,0,0, tocolor(255,255,255,255), false)
		end
		dxDrawShadowedText ( getPlayerName(v), renderPosMO[i][1]+15, renderPosMO[i][2]+150, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "left", "top", false, false, true )
		dxDrawShadowedText ( getElementData(v, "mMoney").."$", renderPosMO[i][1]+15, renderPosMO[i][2]+170, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "left", "top", false, false, true )
	end
	
	if getElementData(mTable, "moves") then
		dxDrawBackgroundedText ( tostring(getElementData(mTable, "moves")).."\nmoves left", 0,0, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), tocolor ( 0, 0, 0, 255 ), 3, "default-bold", "center", "center", false, false, true )
	end
end

function startTurnMO(player)
	showInfoMO("Turn "..getElementData(player, "mTurn"), getPlayerName(player))
end

local currentDice1MO = 1
local currentDice2MO = 1
local rollingDice1MO = false
local rollingDice2MO = false
local diceRollerMO = false
function toggleDiceMO(toggle,player)
	if toggle == true then
		if not isEventHandlerAdded( "onClientRender", getRootElement(), renderDiceMO ) then
			currentDice1MO = 1
			currentDice2MO = 2
			rollingDice1MO = true
			rollingDice2MO = true
			isPressedDiceMO = false
			diceRollerMO = player		
			addEventHandler("onClientRender", getRootElement(), renderDiceMO )
			addEventHandler("onClientKey", getRootElement(), pressDiceMO)		
		end
	else
		if isEventHandlerAdded( "onClientRender", getRootElement(), renderDiceMO ) then
			removeEventHandler("onClientRender", getRootElement(), renderDiceMO )
			removeEventHandler("onClientKey", getRootElement(), pressDiceMO)	
		end
	end
end

local isPressedDiceMO = false
function pressDiceMO(button, press)
	if getLocalPlayer() ~= diceRollerMO then return false end
	if button == "e" and press then
		isPressedDiceMO = 1
		if rollingDice1MO == true then
			setDiceToNumber(1, currentDice1MO)
			triggerServerEvent ( "syncDiceMO", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"), getLocalPlayer(), 1, currentDice1MO )
		elseif rollingDice2MO == true then
			setDiceToNumber(2, currentDice2MO)
			triggerServerEvent ( "syncDiceMO", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"), getLocalPlayer(), 2, currentDice2MO )
			setTimer(function()
				triggerServerEvent ( "startMoveMO", getLocalPlayer(), getElementData(getLocalPlayer(), "mTable"), getLocalPlayer(),  currentDice1MO+currentDice2MO)
			end, 1000,1)
		end
	end
end

function setDiceToNumber(dice, number)
	if dice == 1 then
		rollingDice1MO = false
		currentDice1MO = number
	else
		rollingDice2MO = false
		currentDice2MO = number
	end
	playSound("files/audio/ware/other_exo_won1.wav")
end

function renderDiceMO()
	if rollingDice1MO == true then
		currentDice1MO = currentDice1MO +1
		if currentDice1MO > 6 then currentDice1MO = 1 end
	end
	
	if rollingDice2MO == true then
		currentDice2MO = currentDice2MO +1
		if currentDice2MO > 6 then currentDice2MO = 1 end	
		numberRandomMO = true
	end
	
	dxDrawRectangle ( screenWidth/2-45, screenHeight/2-20, 40, 40, tocolor(0,0,0,255) )
	dxDrawRectangle ( screenWidth/2-43, screenHeight/2-18, 36, 36, tocolor(255,255,255,255) )
	dxDrawText ( tostring(currentDice1MO),  screenWidth/2-45, screenHeight/2-20,  screenWidth/2-5, screenHeight/2+20, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center", "center", false, false, true )

	dxDrawRectangle ( screenWidth/2+5, screenHeight/2-20, 40, 40, tocolor(0,0,0,255) )
	dxDrawRectangle ( screenWidth/2+7, screenHeight/2-18, 36, 36, tocolor(255,255,255,255) )	
	dxDrawText ( tostring(currentDice2MO),  screenWidth/2+5, screenHeight/2-20,  screenWidth/2+45, screenHeight/2+20, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center", "center", false, false, true )
	
	if getLocalPlayer() ~= diceRollerMO then return false end
	if rollingDice1MO == true or rollingDice2MO == true then
		if isPressedDiceMO then
			isPressedDiceMO = isPressedDiceMO +1
			dxDrawImage(screenWidth/2-20, screenHeight/2+30, 40, 40,"files/monopoly/monopolyEpressed.png",0,0,0, tocolor(255,255,255,255), false)
			if isPressedDiceMO > 5 then isPressedDiceMO = false end
		else
			dxDrawImage(screenWidth/2-20, screenHeight/2+30, 40, 40,"files/monopoly/monopolyE.png",0,0,0, tocolor(255,255,255,255), false)
		end
	end
end

local moneySoundMO = false
local moneyChangesMO = {}
function moneyChangeMO(player, dif)
	local odif = 0
	for i,v in ipairs(moneyChangesMO) do
		if v.p == player then
			v.m = odif
			table.remove (moneyChangesMO, i)
		end
	end
	moneyChangesMO[#moneyChangesMO+1] = {}
	moneyChangesMO[#moneyChangesMO].p = player
	moneyChangesMO[#moneyChangesMO].m = dif+odif
	moneyChangesMO[#moneyChangesMO].a = 0
	moneyChangesMO[#moneyChangesMO].tick = getTickCount()
	if isEventHandlerAdded( "onClientRender", getRootElement(), rendermoneyChangesMO ) == false then
		addEventHandler("onClientRender", getRootElement(), rendermoneyChangesMO, true)
	end		
	if not isElement(moneySoundMO) then
		moneySoundMO = playSound("files/monopoly/kaching.mp3")
	end
end

function rendermoneyChangesMO()
	local mTable = getElementData(getLocalPlayer(), "mTable")
	local players = getElementData(mTable, "players")
	if #moneyChangesMO == 0 then removeEventHandler("onClientRender", getRootElement(), rendermoneyChangesMO) return end
	for i,v in ipairs(moneyChangesMO) do
		local playerID = false
		for i1, v1 in ipairs(players) do
			if v1 == v.p then playerID = i1 end
		end
		if not playerID then return end
	
		local drawX = renderPosMO[playerID][1]+153
		local drawX2 = screenWidth
		local align = "left"
		if v.p == players[2] or players[4] then
			drawX = 0
			drawX2 = renderPosMO[playerID][1]-10
			align = "right"
		end
		
		if (getTickCount() - v.tick) <= 3000 then
			if v.a < 255 then
				v.a = v.a+25.5
			end
			if v.m < 0 then
				dxDrawShadowedText ( v.m.."$", drawX, renderPosMO[playerID][2]+170, drawX2, screenHeight, tocolor ( 255, 0, 0, v.a ),  tocolor ( 0, 0, 0, v.a ), 2, "default-bold", align, "top", false, false, true )	
			else
				dxDrawShadowedText ( "+"..v.m.."$", drawX, renderPosMO[playerID][2]+170, drawX2, screenHeight, tocolor ( 0, 255, 0, v.a ),  tocolor ( 0, 0, 0, v.a ), 2, "default-bold",  align, "top", false, false, true )	
			end
		else
			if v.a - 25.5 > 0 then
				v.a = v.a-25.5
				if v.m < 0 then
					dxDrawShadowedText ( v.m.."$", drawX, renderPosMO[playerID][2]+170, drawX2, screenHeight, tocolor ( 255, 0, 0, v.a ),  tocolor ( 0, 0, 0, v.a), 2, "default-bold",  align, "top", false, false, true )	
				else
					dxDrawShadowedText ( "+"..v.m.."$", drawX, renderPosMO[playerID][2]+170, drawX2, screenHeight, tocolor ( 0, 255, 0, v.a ),  tocolor ( 0, 0, 0,v.a ), 2, "default-bold",  align, "top", false, false, true )	
				end				
			else
				table.remove (moneyChangesMO, i)
			end
		end
	end
end

local text1InfoMO
local text2InfoMO
local infoProgressMO
local partInfoMO
local alphaProgressMO
local soundPlayedMO
function showInfoMO(text1, text2)
	if not isEventHandlerAdded( "onClientRender", getRootElement(), renderInfoMO ) then
		text1InfoMO = text1
		text2InfoMO = text2
		infoProgressMO = 0
		alphaProgressMO = 0
		soundPlayedMO = false
		playSound("files/monopoly/swosh_in.mp3")
		addEventHandler("onClientRender", getRootElement(), renderInfoMO, false, "low+1")
	end
end

function renderInfoMO()
	if 0.35 < infoProgressMO and infoProgressMO < 0.65 then 
		infoProgressMO = infoProgressMO + 0.005
		if infoProgressMO < 0.5 then
			alphaProgressMO = alphaProgressMO + 0.05
		elseif infoProgressMO > 0.6 and soundPlayedMO == false then
			playSound("files/monopoly/swosh_out.mp3")
			soundPlayedMO = true
		else
			alphaProgressMO = alphaProgressMO - 0.05
		end
	else
		infoProgressMO = infoProgressMO + 0.025
	end
	
	if alphaProgressMO > 1 then alphaProgressMO = 1 elseif alphaProgressMO < 0 then alphaProgressMO = 0 end
	
	if infoProgressMO > 1 then removeEventHandler("onClientRender", getRootElement(), renderInfoMO) end
	
	local x, _, _ = interpolateBetween ( 0, 0, 0, screenWidth, 0, 0, infoProgressMO, "OutInQuad")
	local x2, _, _ = interpolateBetween ( screenWidth, 0, 0, 0, 0, 0, infoProgressMO, "OutInQuad")
	
	dxDrawLine ( screenWidth/2-200, screenHeight/2-16, screenWidth/2+200,screenHeight/2-16, tocolor(0,0,0,alphaProgressMO*255), 1 )
	dxDrawLine ( screenWidth/2-200, screenHeight/2-15, screenWidth/2+200,screenHeight/2-15, tocolor(255,255,255,alphaProgressMO*255), 2 )
	dxDrawLine ( screenWidth/2-200, screenHeight/2-13, screenWidth/2+200,screenHeight/2-13, tocolor(0,0,0,alphaProgressMO*255), 1 )
	dxDrawBackgroundedText ( text1InfoMO, x, screenHeight/2-10, x, screenHeight, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center", "top", false, false, true )
	dxDrawBackgroundedText ( text2InfoMO, x2, screenHeight/2+15, x2, screenHeight, tocolor ( 255, 255, 255, 255 ),  tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center", "top", false, false, true )	
	dxDrawLine ( screenWidth/2-200, screenHeight/2+49, screenWidth/2+200,screenHeight/2+49, tocolor(0,0,0,alphaProgressMO*255), 1 )
	dxDrawLine ( screenWidth/2-200, screenHeight/2+50, screenWidth/2+200,screenHeight/2+50, tocolor(255,255,255,alphaProgressMO*255), 2 )
	dxDrawLine ( screenWidth/2-200, screenHeight/2+52, screenWidth/2+200,screenHeight/2+52, tocolor(0,0,0,alphaProgressMO*255), 1 )
end