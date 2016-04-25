--[[
Project: vitaCore
File: gg-core.lua
Author(s):	Sebihunter
]]--

local funGGTimers = {}
local funGGObjects = {}
local ggTextTimer = {}

local ggArena = {}
local ggSpawns = {}

local ggHasWinner = false
local ggMapname = "None"

local weaponLevels = {
 [1] = 22, -- Pistol
 [2] = 24, -- Desert Eagle
 [3] = 25, -- Shotgun
 [4] = 26, -- Sawn-Off Shotgun
 [5] = 27, -- Combat Shotgun
 [6] = 28, -- UZI
 [7] = 29, -- MP5
 [8] = 32, -- Tec9
 [9] = 30, -- AK-47
 [10] = 31, -- M4
 [11] = 34, -- Sniper
 [12] = 16, -- Grenades
 [13] = 38 -- Minigun 
}

local mapsGG = {
 [1] = { name = "[GG] Smallville", arena = ggArenaSmallville, spawns = ggSpawnsSmallville},
 [2] = { name = "[GG] Arena One", arena = ggArenaArena1, spawns = ggSpawnsArena1},
 [3] = { name = "[GG] Canals", arena = ggArenaCanals, spawns = ggSpawnsCanals}
}

function showGGText(player, text)
	if ggTextTimer[player] and isTimer(ggTextTimer[player]) then killTimer(ggTextTimer[player]) end
	setElementData(player, "ggText", text)
	ggTextTimer[player] = setTimer(function(player)
		setElementData(player, "ggText", false)
	end, 5000, 1, player)
end

function updateGGWeapon(player)
	takeAllWeapons ( player )
	giveWeapon (player, weaponLevels[getElementData(player,"ggLevel")] , 1337, true )
	giveWeapon(player, 4 )
end

function spawnFunctGG ( passedPlayer )
    if isElement(passedPlayer) == false or getElementData(passedPlayer, "gameMode") ~= gGamemodeFUN then return end
	local randNumber = math.random(1,#ggSpawns)
	spawnPlayer(passedPlayer, ggSpawns[randNumber].posX, ggSpawns[randNumber].posY, ggSpawns[randNumber].posZ,ggSpawns[randNumber].rotZ,getElementData(passedPlayer, "Skin"))
	setElementDimension(passedPlayer, gGamemodeFUN)
	setCameraTarget(passedPlayer, passedPlayer)
	setElementData(passedPlayer, "state", "alive")	
	updateGGWeapon(passedPlayer)
end


function playerJoinGG ( player )
	fadeCamera ( player, true )
	setElementData(player, "ggLevel", 1)
	setElementData(player, "ggText", false)
	setPlayerNametagShowing ( player, true )
	showGGText(player, "Welcome to "..ggMapname..":\nKill a player to advance to the next level.")
	setElementData(player, "mapname", "GunGame - "..ggMapname)
	callClientFunction(player, "showGUIComponents", "mapdisplay", "money")
	callClientFunction(player, "GGClient", true)
	spawnFunctGG ( player )	
end

function quitFunGG(player)
	callClientFunction(player, "GGClient", false)
	setElementData(player, "mapname", false)
	callClientFunction(player, "hideGUIComponents", "mapdisplay", "money")
	setPlayerNametagShowing ( player, false )
end

function playerWastedGG (  player, killer, weapon )
	funGGTimers[#funGGTimers+1] = setTimer ( spawnFunctGG, 5000, 1, player )
	setElementData(player, "state", "dead")
	if isElement(killer) and getElementType ( killer ) == "player" and killer ~= player then
		if getElementData(killer, "ggLevel")+1 > #weaponLevels and ggHasWinner == false then
			ggHasWinner = true
			setElementData(killer, "Points", getElementData(killer, "Points") + 50*#getGamemodePlayers(gGamemodeFUN))	
			if getElementData(killer, "isDonator") == true then 
				setElementData(killer, "Money", getElementData(killer, "Money") + 400*#getGamemodePlayers(gGamemodeFUN))	
				outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(400*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", killer, 255, 255, 255, true)
			else
				setElementData(killer, "Money", getElementData(killer, "Money") + 200*#getGamemodePlayers(gGamemodeFUN))	
				outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(200*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", killer, 255, 255, 255, true)			
			end
			addPlayerArchivement(killer, 67)
			
			if getElementData(killer, "isDonator") == true then
				if getElementData(killer, "useWinsound") ~= 0 then
					local players = getGamemodePlayers(gGamemodeFUN)
					for theKey,thePlayer in ipairs(players) do
						if getElementData(thePlayer, "toggleWinsounds") == 1 then
							triggerClientEvent(thePlayer, "playWinsound", getRootElement(), "files/winsounds/"..tostring(getElementData(killer, "useWinsound"))..".mp3")
						end
					end
				end
			end
			
			if getElementData(killer, "customWintext") ~= "none" and getElementData(killer, "isDonator") == true then
				showWinMessage(gGamemodeFUN, "#FFFFFF"..tostring(getElementData(killer, "customWintext")), "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			else
				showWinMessage(gGamemodeFUN, "#FFFFFF".._getPlayerName(killer) .. '#FFFFFF has won GunGame!', "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			end
			funGGTimers[#funGGTimers+1] = setTimer(function()
				unloadModeFUN()
				startVoteFUN()
			end, 15000, 1)		
		else
			if getElementData(killer, "ggLevel")+1 <= #weaponLevels then
				showGGText(killer, "You've killed "..getPlayerName(player).." and gained a level.")
				setElementData(killer, "ggLevel", getElementData(killer, "ggLevel")+1)
				updateGGWeapon(killer)
			else
				showGGText(killer, "You've killed "..getPlayerName(player)..".")
			end
		end
		if getElementData(player, "ggLevel") > 1 and weapon == 4 then
			showGGText(player, "You've been knifed by "..getPlayerName(killer).." and lost a level.")
			setElementData(player, "ggLevel", getElementData(player, "ggLevel")-1)
		else
			showGGText(player, "You've been killed by "..getPlayerName(killer)..".")
		end
		for i,v in ipairs(getGamemodePlayers(getPlayerGameMode(player))) do
			if weapon then
				triggerClientEvent ( v, "addKillmessage", v, player, killer, getWeaponNameFromID(weapon))
			else
				triggerClientEvent ( v, "addKillmessage", v, player, killer)
			end
		end		
		return
	end
	showGGText(player, "You've died.")
end

function endFunGG()
	for i, element in ipairs(ggArena) do
		setElementDimension(element, gGamemodeFUN+100)
	end
	for i,v in ipairs(funGGObjects) do
		if isElement(v) then destroyElement(v) end
	end
	for i,v in ipairs(funGGTimers) do
		if isTimer(v) then killTimer(v) end
	end	
	for i,v in ipairs(ggTextTimer) do
		if isTimer(v) then killTimer(v) end
	end		
end

function startFunGG ( )
	local randNumber = math.random(1,#mapsGG)
	ggArena = mapsGG[randNumber].arena
	ggSpawns = mapsGG[randNumber].spawns
	ggMapname =  mapsGG[randNumber].name
	setElementData(gElementFUN , "mapname", "GunGame - "..ggMapname)
	ggHasWinner = false
	
	for i, element in ipairs(ggArena) do
		setElementDimension(element, gGamemodeFUN)
	end
end


