--[[
Project: vitaCore
File: spec-client.lua
Author(s):	Sebihunter
]]--

local currentlySpectating = 0
local isSpectating = false
local playerTable = {}
local lastKey = "right"

function spectateStart()
	playerTable = {}
	currentlySpectating = 0
	isSpectating = true
	for i,v in pairs(getAliveGamemodePlayers(getPlayerGameMode(getLocalPlayer()))) do
		playerTable[i] = v
	end
	spectateNextPlayer("right", "down")
	addEventHandler("onClientRender", getRootElement(), renderSpectate)
end

function freezeCamera()
	local x,y,z,tx,ty,tz, roll, fov = getCameraMatrix()
	setTimer(function()
		setCameraMatrix(x,y,z,tx,ty,tz)
	end, 50, 1)	
end

function spectateEnd(nocamera)
	if isSpectating == true and (not nocamera) then
		local x,y,z,tx,ty,tz, roll, fov = getCameraMatrix()
		setTimer(function()
			setCameraMatrix(x,y,z,tx,ty,tz)
		end, 50, 1)
	end
	isSpectating = false
	setElementData(getLocalPlayer(), "spectatesPlayer", false)
	playerTable = {}
	currentlySpectating = 0
	removeEventHandler("onClientRender", getRootElement(), renderSpectate)                            
end

function renderSpectate()
	if isSpectating == false then return false end
	if getPlayerGameMode(getLocalPlayer()) == 0 then
		playerTable = {}
		isSpectating = false
		currentlySpectating = 0
		setElementData(getLocalPlayer(), "spectatesPlayer", false)
		removeEventHandler("onClientRender", getRootElement(), renderSpectate)
	end
	if isElement(playerTable[currentlySpectating]) then
		if isPlayerAlive(playerTable[currentlySpectating]) and getPlayerGameMode(playerTable[currentlySpectating]) == getPlayerGameMode(getLocalPlayer()) then
			if showUserGui == false then
				dxDrawText("Currently Spectating:\n"..getPlayerName(playerTable[currentlySpectating]), 1, screenHeight-99, screenWidth, screenHeight, tocolor(0,0,0,100), 1 , "default-bold", "center",  "top", false, false, false)
				dxDrawText("Currently Spectating:\n".._getPlayerName(playerTable[currentlySpectating]), 0, screenHeight-100, screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "center", "top", false, false, false, true)
			end
		else
			spectateNextPlayer(lastKey, "down")
			dxDrawText("Currently Spectating:\n nobody available to spectate", 1, screenHeight-99, screenWidth, screenHeight, tocolor(0,0,0,100), 1 , "default-bold", "center",  "top", false, false, false)
			dxDrawText("Currently Spectating:\n nobody available to spectate", 0, screenHeight-100, screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "center", "top", false, false, false, true)			
		end
	else
		spectateNextPlayer(lastKey, "down")
		dxDrawText("Currently Spectating:\n nobody available to spectate", 1, screenHeight-99, screenWidth, screenHeight, tocolor(0,0,0,100), 1 , "default-bold", "center",  "top", false, false, false)
		dxDrawText("Currently Spectating:\n-+ nobody available to spectate", 0, screenHeight-100, screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "center", "top", false, false, false, true)			
	end
end

function spectateNextPlayer(key, keyState)
	if isSpectating == false then return end
	if keyState ~= "down" then return end
	lastKey = key
	refreshSpecPlayers()
	
	if key == "right" then
		currentlySpectating = currentlySpectating + 1
		if isElement(playerTable[currentlySpectating]) then
			if isPlayerAlive(playerTable[currentlySpectating]) and getPlayerGameMode(playerTable[currentlySpectating]) == getPlayerGameMode(getLocalPlayer())  then
				setCameraTarget ( playerTable[currentlySpectating] )
				setElementData(getLocalPlayer(), "spectatesPlayer", playerTable[currentlySpectating])
			end
		end
	elseif key == "left" then
		currentlySpectating = currentlySpectating - 1
		if isElement(playerTable[currentlySpectating]) then
			if isPlayerAlive(playerTable[currentlySpectating]) and getPlayerGameMode(playerTable[currentlySpectating]) == getPlayerGameMode(getLocalPlayer())  then
				setCameraTarget ( playerTable[currentlySpectating] )
				setElementData(getLocalPlayer(), "spectatesPlayer", playerTable[currentlySpectating])
			end
		end	
	end
	
	local isSomebodyStillAlive = false
	for i,v in ipairs(playerTable) do
		if isElement(v) then
			if getElementType(v) == "player" then
				if isPlayerAlive(v) then
					isSomebodyStillAlive = true
				end
			end
		end
	end
	
	if isSomebodyStillAlive == false then
		if getElementData(getLocalPlayer(), "gameMode") ~= 3 then
			spectateEnd()
			return false
		end
	end
	
	if currentlySpectating <= 0 then
		currentlySpectating = #playerTable+1
		spectateNextPlayer("left", "down")
	elseif currentlySpectating > #playerTable then
		currentlySpectating = 0
		spectateNextPlayer("right", "down")
	end
end

function refreshSpecPlayers()
	for i,v in pairs(getAliveGamemodePlayers(getPlayerGameMode(getLocalPlayer()))) do
		local isAdded = false
		for i2,v2 in ipairs(playerTable) do
			if v2 == v then isAdded = true end
		end
		
		if isAdded == false then
			playerTable[#playerTable+1] = v
		end
	end
end

bindKey ( "left", "down", spectateNextPlayer ) 
bindKey ( "right", "down", spectateNextPlayer )