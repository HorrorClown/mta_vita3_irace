--[[
Project: Vita3
File: ware-client.lua
Author(s):	Sebihunter
]]--

g_hasWareEnded = false
local endingScoreAlpha = 0.0
local playerWinTable = {}

local root = getRootElement ()
function wareRender ()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then return end
	if g_hasWareEnded == true then
		dxDrawRectangle(screenWidth/2-400/2, screenHeight/2-480/2, 400, 480, tocolor(0,0,0,150*endingScoreAlpha))
		dxDrawText ( "Vita Ware - Ending Scoreboard",screenWidth/2-400/2, screenHeight/2-480/2, screenWidth/2+400/2, screenHeight/2+480/2, tocolor ( 255, 255, 255, 255*endingScoreAlpha ), 2, "default-bold", "center" )	
		dxDrawLine(screenWidth/2-400/2, screenHeight/2-480/2+31, screenWidth/2+400/2, screenHeight/2-480/2+31, tocolor(255,255,255, 255	*endingScoreAlpha), 2)
		if endingScoreAlpha + 0.05 > 1 then
			endingScoreAlpha = 1
		else
			endingScoreAlpha = endingScoreAlpha + 0.025
		end
		
		for id = 1, 32 do
			if (playerWinTable[id]) then
				dxDrawText ( tostring(id)..". "..tostring(playerWinTable[id].name).." ("..tostring(playerWinTable[id].score)..")",screenWidth/2-400/2+5, screenHeight/2-480/2+18+14*id, screenWidth/2+400/2, screenHeight/2+480/2, tocolor ( 255, 255, 255, 255*endingScoreAlpha ), 1, "default-bold", "left" )
			else
				dxDrawText ( tostring(id)..". -",screenWidth/2-400/2+5, screenHeight/2-480/2+18+14*id, screenWidth/2+400/2, screenHeight/2+480/2, tocolor ( 255, 255, 255, 255*endingScoreAlpha ), 1, "default-bold", "left" )
			end
		end
		
		dxDrawText ( getElementData(getLocalPlayer(), "wareText"), 0+1, screenHeight - 200 + 1, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "wareText"), 0, screenHeight - 200, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 2, "default-bold", "center" ) 		
		return
	end
	local loosingplayers = ""
	local winningplayers = ""
	local numberOfLoosingPlayers = 0
	local numberOfWinningPlayers = 0
		
	for i, player in ipairs(getGamemodePlayers(4)) do
		if getElementData(player, "wareWon") == false then
			numberOfLoosingPlayers = numberOfLoosingPlayers +1
			loosingplayers = loosingplayers.."("..tostring(getElementData(player, "wareScore")).."/"..tostring(getElementData(player, "wareGameCount"))..") "..removeColorCoding(getPlayerName(player)).."\n"
		elseif getElementData(player, "wareWon") == true then
			numberOfWinningPlayers = numberOfWinningPlayers +1
			winningplayers = winningplayers..""..removeColorCoding(getPlayerName(player)).." ("..tostring(getElementData(player, "wareScore")).."/"..tostring(getElementData(player, "wareGameCount"))..")\n"
		end	
	end

	if getElementData(getLocalPlayer(), "wareText") ~= false then
		dxDrawText ( getElementData(getLocalPlayer(), "wareText"), 0+1, screenHeight - 200 + 1, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "wareText"), 0, screenHeight - 200, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 2, "default-bold", "center" ) 
	end
	dxDrawRectangle ( screenWidth/2-250, 50, 200, 40, tocolor ( 125, 0, 0, 200 ) )
	dxDrawRectangle ( screenWidth/2-250, 50+40, 200, 15*numberOfLoosingPlayers, tocolor ( 125, 0, 0, 150 ) )
	dxDrawText ( "("..tostring(numberOfLoosingPlayers)..")        Losers", screenWidth/2-250, 55, screenWidth/2-60, 60, tocolor ( 255, 255, 255, 255 ), 2, "default-bold", "right" )	
	dxDrawText ( loosingplayers, screenWidth/2-250, 50+40, screenWidth/2-60, 60, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "right" )	
	
	dxDrawRectangle ( screenWidth/2-50, 50, 100, 40, tocolor ( 0, 0, 0, 200 ) )
	if getElementData(getLocalPlayer(), "wareGameCount") == 0 then
		dxDrawText ( tostring(getElementData(getLocalPlayer(), "wareScore")).." / "..tostring(getElementData(getLocalPlayer(), "wareGameCount")).."\n0%", screenWidth/2-50, 55, screenWidth/2+50, 60, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "center" )
	else
		dxDrawText ( tostring(getElementData(getLocalPlayer(), "wareScore")).." / "..tostring(getElementData(getLocalPlayer(), "wareGameCount")).."\n"..tostring(math.floor(getElementData(getLocalPlayer(), "wareScore")/getElementData(getLocalPlayer(), "wareGameCount")*100)).."%", screenWidth/2-50, 55, screenWidth/2+50, 60, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "center" )	
	end

	dxDrawRectangle ( screenWidth/2+50, 50, 200, 40, tocolor ( 0, 125, 0, 200 ) )
	dxDrawRectangle ( screenWidth/2+50, 50+40, 200, 15*numberOfWinningPlayers, tocolor ( 0, 125, 0, 150 ) )
	dxDrawText ( "Winners      ("..tostring(numberOfWinningPlayers)..")", screenWidth/2+60, 55, screenWidth/2+60, 60, tocolor ( 255, 255, 255, 255 ), 2, "default-bold", "left" )	
	dxDrawText ( winningplayers, screenWidth/2+60, 50+40, screenWidth/2+60, 60, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "left" )			
end


function wareVehicsCollide(vehicles)
	for i, vehicle in pairs(vehicles) do
		for i2, vehicle2 in pairs(vehicles) do
			setElementCollidableWith (vehicle, vehicle2,  false)
		end
	end	
end

function wareClient(toggle)
	if toggle == true then
		addEventHandler ( "onClientRender", root, wareRender )
		g_hasWareEnded = false
		endingScoreAlpha = 0.0
		playerWinTable = {}		
	else
		removeEventHandler ( "onClientRender", root, wareRender )
	end
end


function endWareClient(datWinTable)	
	g_hasWareEnded = true
	local numb = false
	playerWinTable = datWinTable
	for i,v in ipairs(playerWinTable) do
		if v.player == getLocalPlayer() then numb = i end
	end

					
			--[[		local endPoints = math.floor(8*(#getGamemodePlayers(gGamemodeRA)-i+1))
					local endMoney = math.floor(32*(#getGamemodePlayers(gGamemodeRA)-i+1))					
						
					outputChatBox("#996633:Points: #ffffff You received "..tostring(endPoints).." points and "..tostring(endMoney).." Vero for finishing this map as number "..i.." of "..onlinePlayers..".", hitElement, 255, 255, 255, true)
					setElementData(hitElement, "Points", getElementData(hitElement, "Points")+ endPoints)
					setElementData(hitElement, "Money", getElementData(hitElement, "Money")+ endMoney)]]
						
	
	if numb then
		local endPoints = math.floor(32*(#getGamemodePlayers(4)-numb+1))
		local endMoney = math.floor(128*(#getGamemodePlayers(4)-numb+1))	
		if getElementData(getLocalPlayer(), "isDonator") == true then endMoney = endMoney*2 end
							
		outputChatBox("#996633:Points: #ffffff You received "..tostring(endPoints).." points and "..tostring(endMoney).." Vero for being number "..numb.." of "..#getGamemodePlayers(4)..".", 255, 255, 255, true)
		setElementData(getLocalPlayer(), "Points", getElementData(getLocalPlayer(), "Points")+ endPoints)
		setElementData(getLocalPlayer(), "Money", getElementData(getLocalPlayer(), "Money")+ endMoney)
	end
end