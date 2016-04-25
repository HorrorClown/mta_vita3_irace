--[[
Project: vitaCore
File: hay-core.lua
Author(s):	Sebihunter
			Aeron
]]--

local thePickup
local hasBeenWon = false
local funHayTimers = {}
local funHayObjects = {}
local hayRankingboard = {}

function spawnFunctHay ( passedPlayer )
	if isElement(passedPlayer) == false or getElementData(passedPlayer, "gameMode") ~= gGamemodeFUN then return end
    r = 20
	angle = math.random(133, 308) --random angle between 0 and 359.99
	centerX = -12
	centerY = -10
	spawnX = r*math.cos(angle) + centerX --circle trig math
	spawnY = r*math.sin(angle) + centerY --circle trig math
	spawnAngle = 360 - math.deg( math.atan2 ( (centerX - spawnX), (centerY - spawnY) ) )
	spawnPlayer ( passedPlayer, spawnX, spawnY, 3.3, spawnAngle, getElementData(passedPlayer, "Skin") )	
	setElementDimension(passedPlayer, gGamemodeFUN)
	setCameraTarget ( passedPlayer )
	setElementData(passedPlayer, "state", "alive")
end


function playerJoinHay ( player )
	fadeCamera ( player, true )
	spawnFunctHay ( player )
	toggleControl ( player, "fire", false )
	callClientFunction(player, "hayClient", true)
	setElementData(player, "mapname", "Haystack")
	callClientFunction(player, "showGUIComponents", "mapdisplay", "money")
	setPlayerNametagShowing ( player, true )
end

function quitFunHay(player)
	callClientFunction(player, "hayClient", false)
	toggleControl ( player, "fire", true )
	setElementData(player, "mapname", false)
	callClientFunction(player, "hideGUIComponents", "mapdisplay", "money")
	setPlayerNametagShowing ( player, false )
end

function playerWastedHay (  player )
	funHayTimers[#funHayTimers+1] = setTimer ( spawnFunctHay, 3000, 1, player )
	setElementData(player, "state", "dead")
end

-- To do:
-- * Dynamic circle spawn
-- Options:
local options = {
	x = 4,
	y = 4,
	--z = 49, -- +1
	z = 20 - 1, -- +1
	b = 100,
	r = 4
}
-- Don't touch below!
local matrix = {}
local objects = {}
local moving = {}
local xy_speed
local z_speed
local barrier_x
local barrier_y
local barrier_r

function move ()

	local tempRankings = {}
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		tempRankings[#tempRankings+1] = {}
		tempRankings[#tempRankings].playername = _getPlayerName(v)
		tempRankings[#tempRankings].player = v
		if getElementData(v, "hayLevel") then
			tempRankings[#tempRankings].level = getElementData(v, "hayLevel")
		else
			tempRankings[#tempRankings].level = 0
		end
	end
	table.sort(tempRankings, 
		function(a, b)
			return a.level > b.level
		end
	)	
	
	hayRankingboard = {}
	for i,v in ipairs(tempRankings) do
		hayRankingboard[#hayRankingboard+1] = {}
		hayRankingboard[#hayRankingboard].text = v.playername.."#FFFFFF: "..v.level
		hayRankingboard[#hayRankingboard].player = v.player
	end
	setElementData(gElementFUN, "rankingboard", hayRankingboard)
	--outputDebugString("move entered")
	local rand
	repeat
		rand = math.random ( 1, options.b )
	until (moving[rand] ~= 1)
	local object = objects[ rand ]
	local move = math.random ( 0, 5 )
	--outputDebugString("move: " .. move)
	local x,y,z
	local x2,y2,z2 = getElementPosition ( object )
	local free = {}
	copyTable(matrix,free)
	getFree(free)
	x = x2 / -4
	y = y2 / -4
	z = z2 / 3
	if (move == 0)  and (x ~= 1) and (free[x-1] and free[x-1][y] and free[x-1][y][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		x = x - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2 + 4, y2, z2, 0, 0, 0 )
	elseif (move == 1) and (x ~= options.x) and (free[x+1] and free[x+1][y] and free[x+1][y][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		x = x + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2 - 4, y2, z2, 0, 0, 0 )
	elseif (move == 2) and (y ~= 1) and (free[x] and free[x][y-1] and free[x][y-1][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		y = y - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2 + 4, z2, 0, 0, 0 )
	elseif (move == 3) and (y ~= options.y) and (free[x] and free[x][y+1] and free[x][y+1][z] == 0) then
		moving[rand] = 1
		local s = 4000 - xy_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		y = y + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2 - 4, z2, 0, 0, 0 )
	elseif (move == 4) and (z ~= 1) and (free[x] and free[x][y] and free[x][y][z-1] == 0) then
		moving[rand] = 1
		local s = 3000 - z_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		z = z - 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2, z2 - 3, 0, 0, 0 )
	elseif (move == 5) and (z ~= options.z) and (free[x] and free[x][y] and free[x][y][z+1] == 0) then
		moving[rand] = 1
		local s = 3000 - z_speed * z
		funHayTimers[#funHayTimers+1] = setTimer (done, s, 1, rand, x, y, z)
		z = z + 1
		matrix[x][y][z] = 1
		--outputDebugString("moving obj")
		moveObject ( object, s, x2, y2, z2 + 3, 0, 0, 0 )
	end
	--	setTimer ("move", 100 )
end

function endFunHay()
	for i,v in pairs(funHayObjects) do
		if isElement(v) then destroyElement(v) end
	end
	for i,v in pairs(funHayTimers) do
		if isTimer(v) then killTimer(v) end
	end	
	destroyElement( thePickup )
	if isElement(datBarrier) then destroyElement(datBarrier) end
	setElementData(gElementFUN, "rankingboard", false)
end

function startFunHay ( )
	funHayTimers = {}
	funHayObjects = {}	
	matrix = {}
	objects = {}
	moving = {}
	hayRankingboard = {}
	setElementData(gElementFUN, "rankingboard", hayRankingboard)
	setElementData(gElementFUN , "mapname", "Haystack")
	hasBeenWon = false
	
	--outputChatBox("* Haystack-em-up v1.43 by Aeron", getRootElement(), 255, 100, 100)  --PFF meta is good enough :P
	--Calculate speed velocity
	xy_speed = 2000 / (options.z + 1)
	z_speed = 1500 / (options.z + 1)

	--Clean matrix
	for x = 1,options.x do
		matrix[x] = {}
		for y = 1,options.y do
			matrix[x][y] = {}
			for z = 1,options.z do
				matrix[x][y][z] = 0
			end
		end
	end

    --Place number of haybails in matrix
	local x,y,z
	for count = 1,options.b do
		repeat
			x = math.random ( 1, options.x )
			y = math.random ( 1, options.y )
			z = math.random ( 1, options.z )
		until (matrix[x][y][z] == 0)
		matrix[x][y][z] = 1
		objects[count] = createObject ( 3374, x * -4, y * -4, z * 3 ) --, math.random ( 0, 3 ) * 90, math.random ( 0, 1 ) * 180 , math.random ( 0, 1 ) * 180 )
		setElementDimension(objects[count], gGamemodeFUN)
	end
	funHayObjects = objects
	

	--Place number of rocks in matrix
	for count = 1,options.r do
		repeat
			x = math.random ( 1, options.x )
			y = math.random ( 1, options.y )
			z = math.random ( 1, options.z )
		until (matrix[x][y][z] == 0)
		matrix[x][y][z] = 1
		funHayObjects[#funHayObjects+1] = createObject ( 1305, x * -4, y * -4, z * 3, math.random ( 0, 359 ), math.random ( 0, 359 ), math.random ( 0, 359 ) )
		setElementDimension(funHayObjects[#funHayObjects], gGamemodeFUN)
	end
	
	--Calculate tower center and barrier radius
	barrier_x = (options.x + 1) * -2
	barrier_y = (options.y + 1) * -2	
	if (options.x > options.y) then 
		barrier_r = options.x / 2 + 20 
	else
		barrier_r = options.y / 2 + 20 
	end
	
	--Place top-haybail + 
	funHayObjects[#funHayObjects+1] = createObject ( 3374, barrier_x, barrier_y, options.z * 3 + 3 )
	setElementDimension(funHayObjects[#funHayObjects], gGamemodeFUN)
	thePickup = createPickup ( barrier_x, barrier_y, options.z * 3 + 6, 3, 1277, 1 )
	setElementDimension(thePickup, gGamemodeFUN)
	funHayTimers[#funHayTimers+1] = setTimer ( move, 100, 0 )
	funHayTimers[#funHayTimers+1] = setTimer ( barrier, 1000, 1)
	
	
end

function barrier ()
	datBarrier = createColCircle ( barrier_x, barrier_y, barrier_r+50 )
	setElementDimension(datBarrier, gGamemodeFUN)
	addEventHandler ( "onColShapeLeave", datBarrier, function ( p )
		if ( getElementType ( p ) == "player" ) and getPlayerGameMode(p) == gGamemodeFUN then 
			killPed ( p )
			triggerClientEvent ( p, "addNotification", getRootElement(), 1, 255, 100, 100, "You have been killed.\nDon't walk away from the tower!")
			end
		end )
end

function onPickupHit ( p )
	if source == thePickup then
		if getPlayerGameMode(p) ~= gGamemodeFUN then return end
	--	destroyElement( thePickup )
		setElementFrozen(p, true)
		addPlayerArchivement(p, 68)
		if hasBeenWon == true then
			setElementData(p, "Points", getElementData(p, "Points") + 20)
			if getElementData(p, "isDonator") == true then 
				setElementData(p, "Money", getElementData(p, "Money") + 200)		
				outputChatBox("#996633:Points: #ffffff You received 20 points and 200 Vero for reaching the top.", p, 255, 255, 255, true)		
			else
				setElementData(p, "Money", getElementData(p, "Money") + 400)		
				outputChatBox("#996633:Points: #ffffff You received 20 points and 400 Vero for reaching the top.", p, 255, 255, 255, true)					
			end
			return
		end
		hasBeenWon = true
		setElementData(p, "Points", getElementData(p, "Points") + 60)
		if getElementData(p, "isDonator") == true then 
			setElementData(p, "Money", getElementData(p, "Money") + 500)		
			outputChatBox("#996633:Points: #ffffff You received 60 points and 500 Vero for reaching the top as first.", p, 255, 255, 255, true)
		else
			setElementData(p, "Money", getElementData(p, "Money") + 1000)		
			outputChatBox("#996633:Points: #ffffff You received 60 points and 1000 Vero for reaching the top as first.", p, 255, 255, 255, true)		
		end

		if getElementData(p, "isDonator") == true then
			if getElementData(p, "useWinsound") ~= 0 then
				local players = getGamemodePlayers(gGamemodeFUN)
				for theKey,thePlayer in ipairs(players) do
					if getElementData(thePlayer, "toggleWinsounds") == 1 then
						triggerClientEvent(thePlayer, "playWinsound", getRootElement(), "files/winsounds/"..tostring(getElementData(p, "useWinsound"))..".mp3")
					end
				end
			end
		end
		
		if getElementData(p, "customWintext") ~= "none" and getElementData(p, "isDonator") == true then
			showWinMessage(gGamemodeFUN, "#FFFFFF"..tostring(getElementData(p, "customWintext")), "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
		else
			showWinMessage(gGamemodeFUN, "#FFFFFF".._getPlayerName(p) .. '#FFFFFF has reached the top!', "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
		end
		funHayTimers[#funHayTimers+1] = setTimer(function()
			unloadModeFUN()
			startVoteFUN()
		end, 15000, 1)
	end
end

function done ( id, x, y, z )
	moving[id] = 0
	matrix[x][y][z] = 0
end

function getFree ( src )
	local x,y,z
	for k,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		x,y,z = getElementPosition( v )
		x = math.floor(x / -4 + 0.5)
		y = math.floor(y / -4 + 0.5)
		z = math.floor(z / 3 + 0.5)
		if (x >= 1) and (x <= options.x) and (y >= 1) and (y <= options.y) and (z >= 1) and (z <= options.z) then
			src[x][y][z] = 2
		end
	end
end

function copyTable ( src, des )
	for k,v in ipairs(src) do
		if (type(v) == "table") then
			des[k] = {}
			copyTable(src[k],des[k])
		else
			des[k] = v
		end
	end
end
addEventHandler( "onPickupHit", getRootElement(), onPickupHit)


