--[[
Project: Vita Ware
File: boss-game-lastalive-server.lua
Author(s):	Sebihunter
]]--

function startLastAliveBossGame()
	--local weapon = math.random(16,38)
	local playersInBoss = 0
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "~BOSS GAME~\nKill the others: Be the last player alive!")
		setElementData(player, "wareWon", true)
		giveWeapon ( player, 22, 1337, true )
		playersInBoss = playersInBoss +1
	end
	wareBossRunning = true 
	
	if playersInBoss == 1 then
		endLastAliveBossGame()
	end
	addEventHandler( "onPlayerWasted", getRootElement(), onLastAliveBossGameWasted )
end

function endLastAliveBossGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		takeAllWeapons ( player )
		setElementHealth(player, 100)
		setElementData(player, "wareText", false)
		setElementData(player, "wareGameCount", gameCounter)		
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	wareBossRunning = false
	endFunWareInternal()	
	removeEventHandler( "onPlayerWasted", getRootElement(), onLastAliveBossGameWasted )
end

function onLastAliveBossGameWasted()
	if getElementData(source, "gameMode") ~= 4 then return end
	if getElementData(source, "wareWon") == true then
		local randomNumber = math.random(1,3)
		setElementData(source, "wareWon", false)
		callClientFunction(source, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
		setCameraMatrix ( source, 259.3999023438,359.1000976563,150 ,259.3999023438,359.1000976563,54 )
	end
	
	local playersAlive = 0
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			playersAlive = playersAlive+1
		end
	end	
	
	if playersAlive == 1 then
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			if getElementData(player, "wareWon") == true then
				endLastAliveBossGame()
				break
			end
		end		
	end
end