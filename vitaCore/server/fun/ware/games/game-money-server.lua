--[[
Project: Vita Ware
File: game-money-server.lua
Author(s):	Sebihunter
]]--


local moneyPickups = {}

function startMoneyGame()
	moneyPickups = {}
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Collect 1000$")
		setPlayerMoney_(player, 0)
		for variable = 0, 10 do
			local x = math.random(-25,25)
			local y = math.random(-25,25)
			local pickup = createPickup ( 259.3999023438+x,359.1000976563+y,54, 3, 1212, 5000, 100)
			setElementDimension(pickup,4)
			setElementData(pickup, "isWare", true)
			moneyPickups[#moneyPickups+1] = pickup
		end
	end
	addEventHandler ( "onPickupHit",getRootElement(), moneyPickupFunc)
end

function moneyPickupFunc(player)
	if getElementData(source, "isWare") == true then
		givePlayerMoney_(player, 100)
	end
end

function endMoneyGame()
	for i, pickup in ipairs(moneyPickups) do
		destroyElement(moneyPickups[i])
	end
	removeEventHandler ( "onPickupHit",getRootElement(), moneyPickupFunc)
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getPlayerMoney_(player) >= 1000 then setElementData(player, "wareWon", true) end
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		setPlayerMoney_(player, 0)
	end
end
