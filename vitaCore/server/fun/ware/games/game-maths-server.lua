--[[
Project: Vita Ware
File: game-maths-server.lua
Author(s):	Sebihunter
]]--

local maths_1 = math.random(-20,20)
local maths_2 = math.random(-20, 20)

function startMathsGame()
	maths_1 = math.random(-20,20)
	maths_2 = math.random(-20, 20)	
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareMaths", true)
		if maths_2 < 0 then
			setElementData(player, "wareText", "write the answer\n "..tostring(maths_1).." - "..string.sub(tostring(maths_2), 2).." = ???")
		else
			setElementData(player, "wareText", "write the answer\n "..tostring(maths_1).." + "..tostring(maths_2).." = ???")
		end
	end
	addEventHandler( "onPlayerChat", getRootElement(), onChatMathsGame )
end

function onChatMathsGame(message, messageType)
	if getPlayerGameMode(source) ~= 4 then return end
	local randomNumber = math.random(1,3)
	if getElementData(source, "wareMaths") and math.ceil(message) ~= false then
		if tostring(message) == tostring(maths_1+maths_2) then
			setElementData(source, "wareText", "correct answer!")
			setElementData(source, "wareWon", true)
			callClientFunction(source, "playSound", "./files/audio/ware/local_exo_won"..tostring(randomNumber)..".wav" )
			cancelEvent()
		else
			setElementData(source, "wareText", "wrong answer!")
			callClientFunction(source, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
		end
		setElementData(source, "wareMaths", false)
	end
end

function endMathsGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	removeEventHandler( "onPlayerChat", getRootElement(), onChatMathsGame )
end