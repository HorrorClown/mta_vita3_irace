--[[
Project: vitaCore
File: commands-server.lua
Author(s):	Sebihunter
]]--

function pm ( player, commandname, toplayer, ... )
	local newplayer
	local Text = table.concat( { ... }, " " )
	if toplayer == nil or Text	== nil then
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /pm [player] [Text]", player, 255, 0, 0, true )
	elseif getPlayerFromName(toplayer) ~= false or getPlayerFromName(toplayer) ~= nil then
		newplayer = getPlayerFromName2(toplayer)
		if newplayer == false or type(targetPlayer) == "table" or tostring(getPlayerName(newplayer)) == "false" then
			outputChatBox ( "#FF0000:ERROR: #FFFFFFThe player doesn't exist or there are more then 1 possible player choice.", player, 255, 0, 0, true )
		else
			outputChatBox ( "#527EF4:PM TO "..getPlayerName(newplayer)..": #FFFFFF"..Text , player, 139,69,19, true )
			outputChatBox ( "#527EF4:PM FROM "..getPlayerName(player)..": #FFFFFF"..Text, newplayer, 139,69,19, true )
		end
	else
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /pm [player][text]", player, 255, 0, 0, true )
	end
end
addCommandHandler ( "pm", pm )

function send ( player, commandname, toplayer, Value )
	if isLoggedIn(player) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", player, 255, 0, 0, true ) return false end
	local newplayer
	if toplayer == nil or Value	== nil or tonumber(Value) < 0 then
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /send [player] [Value]", player, 255, 0, 0, true )
	elseif getPlayerFromName(toplayer) ~= false or getPlayerFromName(toplayer) ~= nil or Value >= 0  then
		Value = math.round(Value)
		newplayer = getPlayerFromName2(toplayer)
		if newplayer == false or type(targetPlayer) == "table" or tostring(getPlayerName(newplayer)) == "false" then
			outputChatBox ( "#FF0000:ERROR: #FFFFFFThe player doesn't exist or there are more then 1 possible player choice.", player, 255, 0, 0, true )
		elseif getPlayerMoney(player) >= tonumber(Value) then 	
				setPlayerMoney(player, getPlayerMoney(player) - tonumber(Value))
			outputChatBox ( "#327CA4:SEND: #FFFFFF You send "..tostring(Value).." Vero to "..tostring(getPlayerName(newplayer)).."!" , player, 139,69,19, true )
			setPlayerMoney(newplayer, getPlayerMoney(newplayer) + tonumber(Value))
			outputChatBox ( "#327CA4:SEND: #FFFFFF You received "..tostring(Value).." Vero from "..tostring(getPlayerName(player)).."!" , newplayer, 139,69,19, true )
			if tonumber(Value) >= 300000 then
				addPlayerArchivement( player,61 )
			end
		else 
			outputChatBox ( "#FF0000:ERROR: #FFFFFFYou don't have enough money for that.", player, 255, 0, 0, true )
		end
	else
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /send [player] [Value]", player, 255, 0, 0, true )
	end
end
addCommandHandler ( "send", send )

bettedPlayer = {}
function bet ( player, commandname, bettedplayer, Value )
	if isLoggedIn(player) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", player, 255, 0, 0, true ) return false end

	if not bettedplayer or not tonumber(Value) then
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /bet [Player] [500-10000]", player, 255, 0, 0, true )
		return
	end

	Value = math.ceil(tonumber(Value))

	if bettedplayer ~= nil and bettedplayer ~= false and Value ~= nil and Value ~= false and Value <= 10000 and Value ~= 0 and Value >= 500 and not bettedPlayer[player] then
		if #getGamemodePlayers(getPlayerGameMode(player)) >= 5 then
			if getElementData(getGamemodeElement(getPlayerGameMode(player)), "betAvailable") == true then
				local B_Player = getPlayerFromName2(bettedplayer)
				if B_Player == false or B_Player == nil or B_Player == "false" or type(targetPlayer) == "table" or tostring(getPlayerName(B_Player)) == "false" then
					outputChatBox ( "#FF0000:ERROR: #FFFFFFThe player doesn't exist or there are more than one players found with that name.", player, 255, 0, 0, true )
				elseif getPlayerGameMode(player) ~= getPlayerGameMode(B_Player) then
					outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be in the same gamemode as the other.", player, 255, 0, 0, true )
				else if getPlayerMoney(player) >= 0 and getPlayerMoney(player) >= tonumber ( Value ) then
						outputChatBoxToGamemode ( ":BET: #FFFFFF"..tostring(getPlayerName ( player )).." betted "..tonumber(Value).." Vero on "..tostring(getPlayerName( B_Player) ), getPlayerGameMode(player), 139,69,19, true )
						outputChatBox ( ":BET: #FFFFFFIf you leave or change gamemode you'll lose the bet instantly.", player, 139,69,19, true )
						bettedPlayer[player] = {B_Player, tonumber(Value)}
						setPlayerMoney(player, getPlayerMoney(player) -tonumber(Value))
					else
						outputChatBox ( "#FF0000:ERROR: #FFFFFFYou don't have enough money for that.", player, 255, 0, 0, true )
					end
				end
			else
				outputChatBox ( "#FF0000:ERROR: #FFFFFFSorry, you cannot bet at the moment.", player, 255, 0, 0, true )
			end
		else
			outputChatBox ( "#FF0000:ERROR: #FFFFFFYou need atleast 5 players to bet.", player, 255, 0, 0, true )
		end
	else
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /bet [Player] [Money(500-10000)]", player, 255, 0, 0, true )
	end
end
addCommandHandler ( "bet", bet )

function givePlayerBetWinning(theWinner)
	for player, bet in pairs(bettedPlayer) do
		if isElement(player) and bettedPlayer[player] ~= false and getPlayerGameMode(player) == getPlayerGameMode(theWinner) then
			local Money = getPlayerMoney(player)
			if bet[1] == theWinner then
				setPlayerMoney(player, getPlayerMoney(player) + bet[2]*2)
				outputChatBox(":BET:#FFFFFF You earned "..(bet[2]*2).." Vero!", player, 139,69,19, true)
				setElementData(player, "betCounter", getElementData(player, "betCounter")+1)
				--if getElementData(source, "betCounter") >= 50 then
					addPlayerArchivement( player, 7 )
				--end
			else
				outputChatBox(":BET:#FFFFFF Sorry you lost!", player, 139,69,19, true)
			end
			bettedPlayer[player] = false
		end  
	end
end

local rollTimer = {}
rollOldNick = {}
function roll ( player, commandname)
	if isLoggedIn(player) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", player, 255, 0, 0, true ) return false end
	if getPlayerGameMode(player) == 0 or getPlayerGameMode(player) == 4 or getPlayerGameMode(player) == 6 then return end
	if isTimer(rollTimer[player]) == false then
		rollTimer[player] = setTimer ( function () end, 20000, 1 )
		local rollnumber = math.random(1,6)
		if rollnumber == 1 then
			local money = math.random(1,1000)
			setPlayerMoney(player, getPlayerMoney(player)-money)
			outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 1 and looses "..money.." Vero.", getPlayerGameMode(player), 255, 0, 0, true )
		elseif rollnumber == 2 then
			local money = math.random(1,1000)
			setPlayerMoney(player, getPlayerMoney(player)+money)
			outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 2 and gets "..money.." Vero.", getPlayerGameMode(player), 255, 0, 0, true )
		elseif rollnumber == 3 then
			if rollOldNick[player] ~= false and rollOldNick[player] ~= nil then
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 3 and should have been a noob for a minute, but he already is.", getPlayerGameMode(player), 255, 0, 0, true )
			else
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 3 and is a noob for a minute.", getPlayerGameMode(player), 255, 0, 0, true )
				rollOldNick[player] = _getPlayerName(player)
				local rnd = math.random(1,1337)
				if rnd == 1337 then
					addPlayerArchivement(player, 77)
				end
				setPlayerName(player, "Noob"..tostring(rnd))
				setTimer(function(player)
					if not isElement(player) then return end
					setPlayerName(player, rollOldNick[player])
					rollOldNick[player] = false
				end, 60000, 1, player )			
			end			
		elseif rollnumber == 4 then
			if setPlayerMuted ( player, true ) == false then
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 4 and should have been muted, but he already is.", getPlayerGameMode(player), 255, 0, 0, true )
			else
				setTimer ( function(player)
					outputChatBox ( "#1C86EE:ROLL: #FFFFFFYou are now unmuted again", player, 255, 0, 0, true )			
					setPlayerMuted ( player, false )
				end, 60000, 1, player )		
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 4 and gets muted for a minute.", getPlayerGameMode(player), 255, 0, 0, true )
			end
		elseif rollnumber == 5 then
			if isPedInVehicle(player) then
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 5 and so his vehicle rotation has been changed.", getPlayerGameMode(player), 255, 0, 0, true )	
				setElementRotation(getPedOccupiedVehicle(player), math.random(0,360), math.random(0,360), math.random(0,360))
			else
				outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 5 and so his vehicle rotation should be changed, but he's not in a vehicle.", getPlayerGameMode(player), 255, 0, 0, true )		
			end
		elseif rollnumber == 6 then
			callClientFunction(player, "playSound", "files/audio/gay_music.mp3")
			outputChatBoxToGamemode ( "#1C86EE:ROLL: #FFFFFF"..getPlayerName(player).." rolls 6 and is now listening to some gay music.", getPlayerGameMode(player), 255, 0, 0, true )	
			addPlayerArchivement(player, 43)
		end
	else
		outputChatBox ( "#FF0000:ERROR: #FFFFFF/roll can only be used once every 20 seconds!", player, 255, 0, 0, true )
	end
end
addCommandHandler("roll", roll)

local spinTimer = {}
function spin ( player, commandname, Zahl, Einsatz )
	if isLoggedIn(player) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", player, 255, 0, 0, true ) return false end
	if Zahl ~= nil and Zahl ~= false and Einsatz ~= nil and Einsatz ~= false then
		Zahl = math.ceil(Zahl)
		Einsatz = math.ceil(Einsatz)
		if tonumber(Zahl) >= 1 and tonumber(Zahl) <= 3 then
			if getPlayerMoney(player) >= 0 and getPlayerMoney(player) >= tonumber(Einsatz) then 
				if tonumber(Einsatz) > 0 then
					if isTimer(spinTimer[player]) == false then
						spinTimer[player] = setTimer ( function () end, 20000, 1 )
						if math.random ( 1, 3 ) == tonumber(Zahl) then
							setPlayerMoney(player, getPlayerMoney(player) + tonumber(Einsatz))
							outputChatBoxToGamemode ( "#1C86EE:SPIN: #FFFFFF "..getPlayerName ( player ).." won "..Einsatz , getPlayerGameMode(player), 255, 0, 0, true )
							if tonumber(Einsatz) >= 500 then
								addPlayerArchivement( player, 6 )
							end
							if tonumber(Einsatz) >= 100000 then
								addPlayerArchivement( player,60 )
							end							
						else 
							setPlayerMoney(player, getPlayerMoney(player) - tonumber(Einsatz))
							outputChatBoxToGamemode ( "#1C86EE:SPIN: #FFFFFF "..getPlayerName ( player ).." lost "..Einsatz , getPlayerGameMode(player), 255, 0, 0, true )
							if getPlayerMoney(player) < 0 then setPlayerMoney(player, 0) end
							if tonumber(Einsatz) >= 20000 then
								addPlayerArchivement(player, 78)
							end
						end
					else
						outputChatBox ( "#FF0000:ERROR: #FFFFFF/spin can only be used once every 20 seconds!", player, 255, 0, 0, true )
					end
				else
					outputChatBox ( "#FF0000:ERROR: #FFFFFFYour Number must be a positive number! ", player, 255, 0, 0, true )
				end
			else
				outputChatBox ( "#FF0000:ERROR: #FFFFFFYou don't have enough money for that ", player, 255, 0, 0, true )
			end
		else
			outputChatBox ( "#FF0000:ERROR: #FFFFFFYour number must between 1 - 3 ", player, 255, 0, 0, true )
		end
		else
		outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /spin [1-3] [Money]", player, 255, 0, 0, true )
	end
end
addCommandHandler ( "spin", spin )

function commandRateMap(player, commandName, rating)
	local gameMode = getPlayerGameMode(player)
	if gameMode ~= 0 and gameMode ~= 4 and gameMode ~= 6 then
		local rating = tonumber(rating)

		if not rating or rating < 0 or rating > 1 then
			outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /rate [0-1]", player, 255, 0, 0, true )
			return false
		end

		--[[if not rating or not tonumber(rating) or tonumber(rating) > 1 or tonumber(rating) < 0 then
			outputChatBox ( "#FF0000:ERROR: #FFFFFFUsage: /rate [0-1]", player, 255, 0, 0, true )
			return false
		end]]

		if getElementData(getGamemodeElement(gameMode), "map") == "none" then
			outputChatBox ( "#FF0000:ERROR: #FFFFFFA map must be running in order to rate it.", player, 255, 0, 0, true )
			return false
		end		
		
		
		local ratingElement
		if gameMode == 1 then ratingElement = gRatingsSH
		elseif gameMode == 2 then ratingElement = gRatingsDD
		elseif gameMode == 3 then ratingElement = gRatingsRA
		elseif gameMode == 5 then ratingElement = gRatingsDM end
		--rating = math.round(tonumber(rating))

		outputChatBox((":MAPRATING: #FFFFFFYou %s this map now!"):format(rating == 1 and "like" or "dislike"), player, 255, 255, 0, true)

		for _, v in pairs(ratingElement) do
			if v.PlayerID == player.m_ID then
				v.Rating = rating
				if gameMode == 1 then gRatingsSH = ratingElement
				elseif gameMode == 2 then gRatingsDD = ratingElement
				elseif gameMode == 3 then gRatingsRA = ratingElement
				elseif gameMode == 5 then gRatingsDM = ratingElement end

				return
			end
		end

		table.insert(ratingElement, {PlayerID = player.m_ID, Rating = rating})
		if gameMode == 1 then gRatingsSH = ratingElement
		elseif gameMode == 2 then gRatingsDD = ratingElement
		elseif gameMode == 3 then gRatingsRA = ratingElement
		elseif gameMode == 5 then gRatingsDM = ratingElement end

		--[[for i,v in ipairs(ratingElement) do
			local anus = split( v,":" )
			if anus[1] == getElementData(player, "AccountName") then
				ratingElement[i] = getElementData(player, "AccountName")..":"..rating
				outputChatBox("#FFFF00:MAPRATING: #FFFFFFYour rating has been changed to "..rating.."/10.",player, 0, 0, 0, true )
				if gameMode == 1 then gRatingsSH = ratingElement
				elseif gameMode == 2 then gRatingsDD = ratingElement
				elseif gameMode == 3 then gRatingsRA = ratingElement
				elseif gameMode == 5 then gRatingsDM = ratingElement end				
				return true
			end
		end
		ratingElement[#ratingElement+1] = getElementData(player, "AccountName")..":"..rating
		outputChatBox("#FFFF00:MAPRATING: #FFFFFFYou have rated the map "..rating.."/10.",player, 0, 0, 0, true )	
		if gameMode == 1 then gRatingsSH = ratingElement
		elseif gameMode == 2 then gRatingsDD = ratingElement
		elseif gameMode == 3 then gRatingsRA = ratingElement
		elseif gameMode == 5 then gRatingsDM = ratingElement end			
		return true]]
	end
end
addCommandHandler ( "rate", commandRateMap)

function buyRedoMap(player, commandName)
	local gameMode = getPlayerGameMode(player)
	if gameMode ~= 0 and gameMode ~= 4 and gameMode ~= 6 then
		local gameModeElement = getGamemodeElement(gameMode)
		if getElementData(gameModeElement, "map") ~= "none" and getElementData(gameModeElement, "nextmap") == "random" then
			if getRedoCounter(getPlayerGameMode(player)) == 0 then
				if getPlayerMoney(player) >= 3000 or getDonatorBonusState(player, "map", 4) then
					if setNextMap(gameMode, getElementData(gameModeElement, "map")) then
						setRedoCounter(getPlayerGameMode(player), 2)
						addPlayerArchivement(player, 47)
						if getDonatorBonusState(player, "map", 4) then
							incraseDonatorBonusState(player, "map")
							triggerClientEvent ( player, "addNotification", getRootElement(), 2, 0,255,0, "Map bought for free as donator.\n"..tostring(4-getDonatorBonusNumber(player, "map")).." left for today." )
						else
							setPlayerMoney( player, getPlayerMoney(player) - 3000 )
						end

						for i,v in ipairs(getGamemodePlayers(getPlayerGameMode(player))) do
							triggerClientEvent ( v, "addNotification", getRootElement(), 3, 255,0,255, "Mapredo bought by "..getPlayerName(player).."." )
						end
					end
				else
					triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Not enough money." )
				end
			else
				triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Map has already been redone." )
			end
		else
			triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Next map is already set." )
		end
	end
end
addCommandHandler("buyredo", buyRedoMap)
addCommandHandler("br", buyRedoMap)

function buySetMap(player, commandName, ...)
	local mapname = table.concat(arg, " ")
	local gameMode = getPlayerGameMode(player)
	
	if gameMode ~= 0 and gameMode ~= 4 and gameMode ~= 6 then

		local allMaps = getElementsByType ( "mapElement" )
		for theKey,mapElement in ipairs(allMaps) do 
			if getElementData(mapElement, "name") == mapname or getElementData(mapElement, "name") == getMapNameByRealName(mapname) then
				triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Map has been played in the last 30 minutes." )
				return
			end
		end
		local gameModeElement = getGamemodeElement(gameMode)
		if getElementData(gameModeElement, "map") ~= "none" and getElementData(gameModeElement, "nextmap") == "random" then
			if getPlayerMoney(player) >= 6000 or getDonatorBonusState(player, "map", 4) then
				if setNextMap(gameMode, mapname) or (getMapNameByRealName(mapname) ~= false and setNextMap(gameMode, getMapNameByRealName(mapname))) then
					for i,v in ipairs(getGamemodePlayers(getPlayerGameMode(player))) do
						triggerClientEvent ( v, "addNotification", getRootElement(), 3, 255,0,255, "Next map ("..getElementData(gameModeElement, "nextmapname")..") bought by "..getPlayerName(player).."." )
					end				
					addPlayerArchivement(player, 46)
					if getDonatorBonusState(player, "map", 4) then
						incraseDonatorBonusState(player, "map")
						triggerClientEvent ( player, "addNotification", getRootElement(), 2, 0,255,0, "Map bought for free as donator.\n"..tostring(4-getDonatorBonusNumber(player, "map")).." left for today." )
					else
						setPlayerMoney( player, getPlayerMoney(player) - 6000 )
					end

					local mapElement = createElement("mapElement")
					setElementData(mapElement, "name", getElementData(gameModeElement, "nextmap"))
					setElementData(mapElement, "realname", getElementData(gameModeElement, "nextmapname"))
					setElementData(mapElement, "gameMode", gameMode)
					setTimer(function (mapElement)
						for i,v in pairs(getGamemodePlayers(getElementData(mapElement, "gameMode"))) do
							triggerClientEvent ( v, "addNotification", getRootElement(), 3, 245,0,246, getElementData(mapElement, "realname").." can be bought again." )
						end
						destroyElement(mapElement)	
					end, 1800000, 1, mapElement)			
				else
					triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Map could not be found." )
				end
			else
				triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Not enough money." )
			end
		else
			triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Next map is already set." )
		end
	end
end
addCommandHandler ( "buynextmap", buySetMap )


lotteryElement = createElement("lotteryElement")
setElementData(lotteryElement, "money", 0)
setElementData(lotteryElement, "players", 0)
setElementData(lotteryElement, "lotteryRunning", false)
setElementData(lotteryElement, "deposit", math.random(300, 1000))

addCommandHandler("bt", 
function (source, command)
	local deposit = getElementData(lotteryElement, "deposit")
	if getPlayerMoney(source) >= deposit and isLoggedIn(source) == true then
		if getElementData(source, "inLottery") == false then
			setPlayerMoney(source, getPlayerMoney(source)-deposit)
			setElementData(lotteryElement, "money", getElementData(lotteryElement, "money") + deposit)
			setElementData(lotteryElement, "players", getElementData(lotteryElement, "players") + 1)
			setElementData(source, "inLottery", getElementData(lotteryElement, "players"))
			if getElementData(lotteryElement, "lotteryRunning") == false then
				setElementData(lotteryElement, "lotteryRunning", true)
				for i,v in pairs(getElementsByType("player")) do
					if getPlayerGameMode(v) ~= 0 then
						--triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "A new lottery has been started by "..getPlayerName(source)..".\nUse /bt to buy a ticket (" .. deposit ..")")
						triggerClientEvent(v, "addNotification", getRootElement(), 4, 72,145,136, ("A new lottery has been started by %s.\nUse /bt to buy a ticket (%s)"):format(source:getName(), deposit))
					end
				end				
				--triggerClientEvent ( source, "addNotification", getRootElement(), 2, 0,200,0, "Lottery ticket bought: -300 Vero" )

				setTimer(function()
					for i,v in pairs(getElementsByType("player")) do
						if getPlayerGameMode(v) ~= 0 then
							triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "The lottery ends in 4 minutes - /bt to buy a ticket\nThere are currently "..getElementData(lotteryElement, "money").." Vero in the lottery!")
						end
					end					
				end,60000, 1)
				setTimer(function()
					for i,v in pairs(getElementsByType("player")) do
						if getPlayerGameMode(v) ~= 0 then
							triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "The lottery ends in 3 minutes - /bt to buy a ticket\nThere are currently "..getElementData(lotteryElement, "money").." Vero in the lottery!")
						end
					end	
				end,120000, 1)
				setTimer(function()
					for i,v in pairs(getElementsByType("player")) do
						if getPlayerGameMode(v) ~= 0 then
							triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "The lottery ends in 2 minutes - /bt to buy a ticket\nThere are currently "..getElementData(lotteryElement, "money").." Vero in the lottery!")
						end
					end	
				end,180000, 1)
				setTimer(function()
					for i,v in pairs(getElementsByType("player")) do
						if getPlayerGameMode(v) ~= 0 then
							triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "The lottery ends in 1 minutes - /bt to buy a ticket\nThere are currently "..getElementData(lotteryElement, "money").." Vero in the lottery!")
						end
					end	
				end,240000, 1)
				setTimer(endLottery,300000, 1)
			else
				--triggerClientEvent ( source, "addNotification", getRootElement(), 2, 0,200,0, "Lottery ticket bought: -300 Vero" )
				for i,v in pairs(getElementsByType("player")) do
					if getPlayerGameMode(v) ~= 0 then
						triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, getPlayerName(source).." has bought a lottery ticket (/bt)\nThere are now "..getElementData(lotteryElement, "money").." Vero in the lottery!")
					end
				end
				
			end
		else
			triggerClientEvent ( source, "addNotification", getRootElement(), 1, 200,50,50, "Already bought a lottey ticket." )
		end
	else
		triggerClientEvent ( source, "addNotification", getRootElement(), 1, 200,50,50, "Not enough money." )
	end
end
)

function endLottery()
	local hasEnded = false
	local randomNumber = math.random(1, getElementData(lotteryElement, "players"))
	local players = 0
	for id, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "inLottery") ~= false then
			players = players +1
		end
		if getElementData(player, "inLottery") == randomNumber then
			setPlayerMoney(player, getPlayerMoney(player)+getElementData(lotteryElement, "money"))
			addPlayerArchivement(player, 3)
			for i,v in pairs(getElementsByType("player")) do
				if getPlayerGameMode(v) ~= 0 then
					callClientFunction(v, "playSound", "files/audio/lottery.ogg")	
					triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, getPlayerName(player).." has won "..getElementData(lotteryElement, "money").." Vero in the lottery!\nStart a new lottery round with /bt.")
				end
			end			
			setElementData(lotteryElement, "lotteryRunning", false)
			setElementData(lotteryElement, "money", 0)
			setElementData(lotteryElement, "players", 0)
			setElementData(lotteryElement, "deposit", math.random(300, 1000))
			hasEnded = true
		end
	end
	if hasEnded == false then
		if players == 0 then
			for i,v in pairs(getElementsByType("player")) do
				if getPlayerGameMode(v) ~= 0 then
					triggerClientEvent ( v, "addNotification", getRootElement(), 4, 72,145,136, "Lottery ended with no winners, as all participants left!\nStart a new lottery round with /bt.")
				end
			end	
			setElementData(lotteryElement, "lotteryRunning", false)
			setElementData(lotteryElement, "money", 0)
			setElementData(lotteryElement, "players", 0)			
		else
			endLottery()
		end
	else
		for id, player in ipairs(getElementsByType("player")) do
			setElementData(player, "inLottery", false)
		end
	end
end

--User Commands
addCommandHandler("pvp", 
	function (source, command, target, price)
	if isLoggedIn(source) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", source, 255, 0, 0, true ) return false end
	target = getPlayerFromName2(target)
	if isLoggedIn(source) ~= true then return false end
	--if string.find(g_MapName, "[DM]", 1, true) or string.find(g_MapName, "race-[DM]", 1, true) then
		if target then
			if type(target) == "table" then
				outputChatBox("#FF0000:ERROR: #FFFFFFMore than one player found.",source,255,0,0, true)
				return
			end
			if target == source then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't fight a PVP war against yourself.",source,255,0,0, true)
				return
			end
			--[[if #getElementsByType ( "player" ) < 10 then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou need atleast 10 players on the server to start a PVP war.",source,255,0,0, true)
				return			
			end]]--
			if getElementData(getGamemodeElement(getPlayerGameMode(source)), "betAvailable") == false then
				outputChatBox("#FF0000:ERROR: #FFFFFFThe time to start a PVP war is already over.",source,255,0,0, true)
				return
			end
			local targetname = getPlayerName(target)
			price = tonumber(price)
			if not price or price < 0 then
				outputChatBox("#FF0000:ERROR: #FFFFFF/pvp [playername] [money]",source,255,0,0, true)
				return
			end
			
			if getPlayerGameMode(target) ~= getPlayerGameMode(source) then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't start a PVP fight with a player from another gamemode.",source,255,0,0, true)
				return			
			end
			
			if isPlayerAlive(target) == false or isPlayerAlive(source) == false  then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't start a PVP fight when one of the players is dead.",source,255,0,0, true)
				return
			end
			
			local hasPVP = false
			local pvpElements = getElementsByType ( "pvpElement" )
			for theKey,pvpElement in ipairs(pvpElements) do
				if getElementData(pvpElement, "player1") == target or getElementData(pvpElement, "player2") == target or getElementData(pvpElement, "player1") == source or getElementData(pvpElement, "player2") == source then 
					hasPVP = true
				end                                                             
			end			
			
			if hasPVP == false then
				local pvpElement = createElement ( "pvpElement" )
				setElementData(pvpElement, "player1", source)
				setElementData(pvpElement, "player2", target)	
				setElementData(pvpElement, "money", tonumber(price))
				setElementData(pvpElement, "accepted", false)
				setElementData(pvpElement, "gameMode", getPlayerGameMode(source))
				
				--[[if getElementData(source, "country") == "DE" or getElementData(source, "country") == "AT" or getElementData(source, "country") == "CH" then
					callClientFunction( source, "playSound", "audio/pvp_ger.wav" )
				else
					callClientFunction( source, "playSound", "audio/pvp_eng.wav" )
				end]]
				
				
				outputChatBox("#256484:PVP: #FFFFFFYou sent "..targetname.." a PVP request about "..tostring(price).." Vero.", source,0,255,0, true)
				outputChatBox("#256484:PVP: #FFFFFFYou got a PVP request by "..getPlayerName(source).." about "..tostring(price).." Vero.",target,0,255,0, true)
				outputChatBox("#256484:PVP: #FFFFFFUse '/acceptpvp' to accept the PVP fight, '/declinepvp' to decline it.",target,0,255,0, true)
			else
				outputChatBox("#FF0000:ERROR: #FFFFFFEither you or the other player already got a PVP request.",source,255,0,0, true)
			end
		else
			outputChatBox("#FF0000:ERROR: #FFFFFF/pvp [playername] [money]",source,255,0,0, true)
		end
	--else
	--	outputChatBox("#FF0000:ERROR: #FFFFFFPVP wars can be only started on [DM] maps.",source,255,0,0, true)
	--end
end
)

addCommandHandler("acceptpvp", 
function (source, command)
	if isLoggedIn(source) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", source, 255, 0, 0, true ) return false end
	local hasPVP = false
	local pvpElements = getElementsByType ( "pvpElement" )
	for theKey,pvpElement in ipairs(pvpElements) do
		if getElementData(pvpElement, "player1") == source or getElementData(pvpElement, "player2") == source then 
			if getElementData(getGamemodeElement(getPlayerGameMode(source)), "betAvailable") == false then
				outputChatBox("#FF0000:ERROR: #FFFFFFThe time to start a PVP war is already over.",source,255,0,0, true)
				destroyElement(pvpElement)
				return				
			end
			local player1 = getElementData(pvpElement, "player1")
			local player2 = getElementData(pvpElement, "player2")
			local money = getElementData(pvpElement, "money")
			if getPlayerGameMode(player1) ~= getPlayerGameMode(player2) then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't start a PVP fight with a player from another gamemode.",source,255,0,0, true)
				return
			end
			if isPlayerAlive(player2) == false or isPlayerAlive(player1) == false  then
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't start a PVP fight when one of the players is dead.",player1,255,0,0, true)
				outputChatBox("#FF0000:ERROR: #FFFFFFYou can't start a PVP fight when one of the players is dead.",player2,255,0,0, true)
				return
			end	
			if getElementData(pvpElement, "accepted") == false then
				if getPlayerMoney(player1) >= tonumber(money) and getPlayerMoney(player2) >= tonumber(money) then
					setPlayerMoney(player1, getPlayerMoney(player1)-money)
					setPlayerMoney(player2, getPlayerMoney(player2)-money)
					setElementData(pvpElement, "accepted", true)
					outputChatBox("#256484:PVP: #FFFFFFPVP war against "..getPlayerName(player2).." started.",player1,255,0,0, true)
					outputChatBox("#256484:PVP: #FFFFFFPVP war against "..getPlayerName(player1).." started.",player2,255,0,0, true)
				else
					outputChatBox("#256484:PVP: #FFFFFFOne of the players does not have enough money for this PVP request. Request automatically terminated.",player1,255,0,0, true)
					outputChatBox("#256484:PVP: #FFFFFFOne of the players does not have enough money for this PVP request. Request automatically terminated.",player2,255,0,0, true)
					destroyElement(pvpElement)
				end
			else
				outputChatBox("#FF0000:ERROR: #FFFFFFYou have already started a PVP war.",source,255,0,0, true)
			end
			return true
		end                                                             
	end	
	outputChatBox("#FF0000:ERROR: #FFFFFFThere was no PVP request found.",source,255,0,0, true)
end
)

addCommandHandler("declinepvp", 
function (source, command)
	if isLoggedIn(source) ~= true then outputChatBox ( "#FF0000:ERROR: #FFFFFFYou must be logged in to use this command.", source, 255, 0, 0, true ) return false end
	local hasPVP = false
	local pvpElements = getElementsByType ( "pvpElement" )
	for theKey,pvpElement in ipairs(pvpElements) do
		if getElementData(pvpElement, "player1") == source or getElementData(pvpElement, "player2") == source and getElementData(pvpElement, "accepted") == false then 
			local player1 = getElementData(pvpElement, "player1")
			local player2 = getElementData(pvpElement, "player2")
			outputChatBox("#256484:PVP: #FFFFFFThe PVP war was declined. Use '/pvp [player] [money]' to start another war.",player1,255,0,0, true)
			outputChatBox("#256484:PVP: #FFFFFFThe PVP war was declined. Use '/pvp [player] [money]' to start another war.",player2,255,0,0, true)
			destroyElement(pvpElement)
			return true
		end                                                             
	end	
	outputChatBox("#FF0000:ERROR: #FFFFFFThere was no PVP request found.",source,255,0,0, true)
end
)
