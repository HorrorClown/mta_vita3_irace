--[[
Project: Vita Ware
File: game-grenadestayalive-server.lua
Author(s):	Sebihunter
]]--

function startGrenadeStayAliveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Stay alive!")
		setElementData(player, "wareWon", true)
		giveWeapon ( player, 16, 10, true )
	end
	addEventHandler( "onPlayerWasted", getRootElement(), onGrenadeStayAliveGameWasted )
end

function endGrenadeStayAliveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		takeAllWeapons ( player )
		setElementHealth(player, 100)
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	removeEventHandler( "onPlayerWasted", getRootElement(), onGrenadeStayAliveGameWasted )
end

function onGrenadeStayAliveGameWasted ()
	if getPlayerGameMode(source) ~= 4 then return end
	if getElementData(source, "wareWon") == true then
		local randomNumber = math.random(1,3)
		setElementData(source, "wareWon", false)
		callClientFunction(source, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
	end
end