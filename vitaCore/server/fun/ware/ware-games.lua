--[[
Project: Vita Ware
File: game-server.lua
Author(s):	Sebihunter
]]--

myWareGames = false
function startNewWareGame()

	local numbWareGames = 17

	if myWareGames == false then
		myWareGames = {}
		for i = 1, numbWareGames do
			myWareGames[#myWareGames+1] = i
		end
	end
	
	
	local newgame = math.random(1,#myWareGames)
	if not myWareGames[newgame] then
		myWareGames = false
		startNewWareGame()
		return
	else
		wareRunningGame = myWareGames[newgame]
		if #myWareGames <= 1 then
			myWareGames = false
		else
			table.remove(myWareGames, newgame)
		end
	end
	wareGameCount = wareGameCount +1
	
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		callClientFunction(player, "playSound", "./files/audio/ware/game_new_two.mp3" )
		setElementData(player, "wareWon", false)
	end

	if wareMaxGames == wareGameCount then
		wareRunningGame = math.random(1,1)
		
		if wareRunningGame == 1 then
			outputDebugString("WARE: Started Boss")
			startLastAliveBossGame()
		end
		return
	end
	
	local timelimit = 1337
	if wareRunningGame == 1 then --Checkpoint
		startCheckpointGame()
		timelimit = 5000
	end
	
	if wareRunningGame == 2 then --Maths
		startMathsGame()
		timelimit = 7000
	end

	if wareRunningGame == 3 then --Carbreak
		startCarbreakGame()
		timelimit = 5000
	end
	
	if wareRunningGame == 4 then --Do not move
		startNoMoveGame()
		timelimit = 3000
	end
	
	if wareRunningGame == 5 then --Jump down the dam
		startDamJumpGame()
		timelimit = 7500
	end

	if wareRunningGame == 6 then -- Grenade stay alive
		startGrenadeStayAliveGame()
		timelimit = 15000
	end
	
	if wareRunningGame == 7 then --Move
		startMoveGame()
		timelimit = 3000
	end	
	
	if wareRunningGame == 8 then --Crouch
		startCrouchGame()
		timelimit = 3000
	end	
	
	if wareRunningGame == 9 then --Kill
		startKillGame()
		timelimit = 11000
	end		

	if wareRunningGame == 10 then --Money
		startMoneyGame()
		timelimit = 8000
	end		
	if wareRunningGame == 11 then --Punch
		startPunchGame()
		timelimit = 10000
	end
	if wareRunningGame == 12 then --Bike
		startBikeGame()
		timelimit = 8000
	end	
	if wareRunningGame == 13 then --Land
		startLandGame()
		timelimit = 8000
	end		
	if wareRunningGame == 14 then --Click
		startButtonGame()
		timelimit = 2000
	end
	if wareRunningGame == 15 then --Equipt
		startDildoGame()
		timelimit = 2000
	end		
	if wareRunningGame == 16 then --Get off the plattform
		startGetOffGame()
		timelimit = 5000
	end	
	if wareRunningGame == 17 then --Evade bomb
		startBombGame()
		timelimit = 5000
	end		
	--[[
	Game Ideen:
		Einer ist Bombe und muss andere explodieren lassen, die anderen überleben
		Sprint and loose weight
		Drive into the checkpoint	
		Punch 'CERTAIN PLAYER'
		Bomb Mr Whoopee
		
		Boss Ideen:
		DD
		Wasser steigt und man muss überleben
	]]--                                                    
	
	local count = math.floor(timelimit / 7)
	
	wareTimers[#wareTimers+1] = setTimer(playWareTimeSound, math.floor(count * 2), 1, 5)
	wareTimers[#wareTimers+1] = setTimer(playWareTimeSound, math.floor(count * 3), 1, 4)
	wareTimers[#wareTimers+1] = setTimer(playWareTimeSound, math.floor(count * 4), 1, 3)
	wareTimers[#wareTimers+1] = setTimer(playWareTimeSound, math.floor(count * 5), 1, 2)
	wareTimers[#wareTimers+1] = setTimer(playWareTimeSound, math.floor(count * 6), 1, 1)	
	wareTimers[#wareTimers+1] = setTimer(endWareGame, timelimit, 1)	
end

function endWareGame()
	
	if wareRunningGame == 1 then --Checkpoint
		endCheckpointGame()
	end
	if wareRunningGame == 2 then --Maths
		endMathsGame()
	end	
	if wareRunningGame == 3 then --Carbreak
		endCarbreakGame()
	end		
	if wareRunningGame == 4 then --Do not move
		endNoMoveGame()
	end		
	if wareRunningGame == 5 then --Jump down the dam
		endDamJumpGame()
	end		
	if wareRunningGame == 6 then -- Grenade stay alive
		endGrenadeStayAliveGame()
	end	
	if wareRunningGame == 7 then -- Move
		endMoveGame()
	end		
	if wareRunningGame == 8 then -- Crouch
		endCrouchGame()
	end	
	if wareRunningGame == 9 then -- Kill
		endKillGame()
	end	
	if wareRunningGame == 10 then -- Money
		endMoneyGame()
	end	
	if wareRunningGame == 11 then -- Punch
		endPunchGame()
	end	
	if wareRunningGame == 12 then -- Bike
		endBikeGame()
	end	
	if wareRunningGame == 13 then -- Land
		endLandGame()
	end	
	if wareRunningGame == 14 then -- Land
		endButtonGame()
	end
	if wareRunningGame == 15 then -- Equipt
		endDildoGame()
	end		
	if wareRunningGame == 17 then -- Evade bomb
		endBombGame()
	end		
	if wareRunningGame == 16 then -- Get off the plattform
		endGetOffGame()
	end		
	--[[if wareGameCount == wareMaxGames then -- Maximum games have been played, end ware
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			setElementData(player, "wareText", false)
			setElementData(player, "wareGameCount", wareGameCount)
		end
		endWare()
		return
	end	]]--
	
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			setElementData(player, "wareText", "> Macrogames left: "..tostring(wareMaxGames-wareGameCount).." <")
			setElementData(player, "wareGameCount", wareGameCount)
			local x,y,z = getElementPosition(player)
		if getElementData(player, "wareWon") == true then
			callClientFunction(player, "playSound", "./files/audio/ware/game_win_two.mp3" )
			callClientFunction(getRootElement(), "fxAddDebris",x, y, z, 0, 255, 0, 255, 0.1, 5 )
		else
			callClientFunction(player, "playSound", "./files/audio/ware/game_lose_two.mp3" )
			callClientFunction(getRootElement(), "fxAddDebris",x, y, z, 255, 2, 0, 255, 0.1, 5 )
		end
	end
	
	wareTimers[#wareTimers+1] = setTimer(startNewWareGame, 3000, 1)
end

function playWareTimeSound(t)
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if t == 5 then
			callClientFunction(player, "playSound", "./files/audio/ware/countdown_ann_sec5.mp3")
		elseif t == 4 then
			callClientFunction(player, "playSound", "./files/audio/ware/countdown_ann_sec4.mp3")
		elseif t == 3 then
			callClientFunction(player, "playSound", "./files/audio/ware/countdown_ann_sec3.mp3")
		elseif t == 2 then
			callClientFunction(player, "playSound", "./files/audio/ware/countdown_ann_sec2.mp3")
		elseif t == 1 then
			callClientFunction(player, "playSound", "./files/audio/ware/countdown_ann_sec1.mp3")
		end
	end	
end
