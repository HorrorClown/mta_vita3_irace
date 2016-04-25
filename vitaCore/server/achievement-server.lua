--[[
Project: Vita3
File: achievement-server.lua
Author(s):	Lexlo
			Sebihunter
]]--

local tArchivements = {}

function addArchivement(staticID, archName, archDesc)
	if tArchivements[staticID] then return false end
	
	tArchivements[staticID] = {}
	tArchivements[staticID]["name"] = archName
	tArchivements[staticID]["des"] = archDesc
	return true
end

function isCorrectArchivement(archName)
	for archID, arch in pairs(tArchivements) do
		if arch["name"] == archName then return true end
	end
	return false
end

function getArchivementFromName(archName)
	for archID, arch in pairs(tArchivements) do
		if archName == tArchivements[archID]["name"] then
			return archID 
		end
	end
	return false
end

function getArchivementName(staticID)
	for archID, arch in pairs(tArchivements) do
		if archID == staticID then
			return tArchivements[archID]["name"]
		end
	end
	return false
end

function getArchivementDescription(staticID)
	for archID, arch in pairs(tArchivements) do
		if archID == staticID then
			return tArchivements[archID]["des"]
		end
	end
	return false
end

function addPlayerArchivement(player, staticID)
	if player and staticID then
		if isLoggedIn(player) then 
			local atable = getElementData(player, "Archivements")
			if not atable then return false end
			if atable[tostring(staticID)] then return false
			else
				outputChatBoxToGamemode( "#486214:Achievement: #FFFFFF"..getPlayerName(player).." earned #00FF00"..getArchivementName( staticID ).."#FFFFFF.", getPlayerGameMode(player), 0, 255, 0, true )
				atable[tostring(staticID)] = true
				setElementData(player, "Archivements", atable)
				callClientFunction ( player, "addAchievementNotification" , getArchivementName(staticID), getArchivementDescription(staticID) )
				return true
			end
			return false
		end
		else
		return false
	end
	return false
end
addEvent( "addPlayerArchivement", true )
addEventHandler( "addPlayerArchivement", getRootElement(), addPlayerArchivement )

function removePlayerArchivement(player, staticID)
	if player and staticID then
		if isLoggedIn(player) then
			local atable = getElementData(player, "Archivements")
			if not atable then return false end
			atable[tostring(staticID)] = nil
			setElementData(player, "archivements", atable)
			return true
		end
		return false
	end
	return false
end

---------------------------
--Sonstige FUNKTION
---------------------------

function syncArchivmentTableForPlayer(client)
    triggerClientEvent(client, "receiveArchivementsFromServer", getResourceRootElement(), tArchivements)
end


function getAllArchivementNames()
	for archID, arch in pairs(tArchivements) do
		return arch["name"]
	end
end

--[[
--------- NEW IDEAS FOR ACHIEVEMENTS ---------

Failer
- You failed after 30 Seconds without pressing Enter

]]

function initArchivments()
	addArchivement(1, "I just came to say hello", "Join the server for the first time.") --DONE
	addArchivement(2, "Secret Phrase", "Say the secret phrase.") --DONE
	addArchivement(3, "Lucky motherfucker", "Win the lottery.") --DONE
	addArchivement(4, "Is it a plane?", "Explode while flying with a vehicle through the air.") --DONE	
	addArchivement(5, "Me gusta", "Use a meme.") --DONE
	addArchivement(6, "Spin me right round", "Spin at least 500 Vero or more and win.") --DONE
	addArchivement(7, "Lucky Hand", "Bet on someone and win.") --DONE
	addArchivement(8, "Win a map", "Win a map with at least 10 players online.") --DONE
	addArchivement(9, "Take it to the end.", "Get the hunter once.") --DONE
	addArchivement(10, "Hunt the hunter", "Get the Hunter 2 times in a row.")--DONE
	addArchivement(11, "Dominating", "Get the Hunter 3 times in a row.") --DONE
	addArchivement(12, "Rampage", "Win 5 DM maps in a row.") --DONE
	addArchivement(13, "Godlike", "Win 7 DM maps in a row.") --DONE
	addArchivement(14, "Wicked sick", "Win 11 DM maps in a row.") --DONE
	addArchivement(15, "No Lifer", "Be online for 5 days. (120 hours)") --DONE
	addArchivement(16, "RL?! What's that?", "Be online for 10 days. (240 hours)") --DONE
	addArchivement(17, "Enter lover", "Die in less than 0.30 seconds.")
	addArchivement(18, "Lagger", "Get a ping higher than 1000.") --DONE
	addArchivement(19, "Deathmatch Pro", "Win 100 DM maps.") --DONE
	addArchivement(20, "Destruction Derby Pro", "Win 100 DD maps.") --DONE
	addArchivement(21, "Super Sexy Deathmatch King", "Win 1000 DM maps.") --DONE
	addArchivement(22, "Super Sexy Destruction Derby King", "Win 1000 DD maps.") --DONE
	addArchivement(23, "A beginning", "Earn 100 points and 100 Vero.") --DONE
	addArchivement(24, "Newbie", "Earn 1000 points and 2000 Vero.") --DONE
	addArchivement(25, "Racer", "Earn 5000 points and 2500 Vero.") --DONE
	addArchivement(26, "Drift King", "Earn 10.000 points and 5.000 Vero.") --DONE
	addArchivement(27, "Race Veteran", "Earn 50.000 points and 100.000 Vero.") --DONE
	addArchivement(28, "Famous Racer", "Earn 100.000 points and 15.000 Vero.") --DONE
	addArchivement(29, "Vita Race Legend", "Earn 25.000 points and 250.000 Vero.") --DONE
	addArchivement(30, "Godlike Racer", "Earn 50.000 points and 500.000 Vero.") --DONE
	addArchivement(31, "Mother of God", "Earn 100.000 points and 1.000.000 Vero.") --DONE
	addArchivement(32, "Get a life", "Earn 1.000.000 points and 10.000.000 Vero.") --DONE
	addArchivement(33, "Rich bitch", "Earn 100.000 Vero.") --DONE
	addArchivement(34, "Bill Gates", "Earn 1.000.000 Vero.")  --DONE
	addArchivement(35, "Dagobert Duck", "Earn 10.000.000 Vero.") --DONE
	addArchivement(36, "New identity", "Rename yourself while playing on the server.") --DONE
	addArchivement(37, "Time to say Goodbye", "Leave the server for the first time.") --DONE
	addArchivement(38, "And so ends the fun...", "Be online while an admin connects.") --DONE
	addArchivement(39, "Propaganda", "Do an advert for race.vita-online.eu in the chat.") --DONE
	addArchivement(40, "Welcome in our team", "You are or have been a Vita Race member.") --DONE	
	addArchivement(41, "There we go again...", "Replay any [DM] map after failing.") --DONE	
	addArchivement(42, "ThirtyTwo", "Play while there are 32 players in your gamemode.") --DONE	
	addArchivement(43, "It's okay to be gay", "Listen to gay music.") --DONE	
	addArchivement(44, "A winner and a loser", "Win a PVP fight.") --DONE
	addArchivement(45, "Ka-Ching!", "Donate something to Vita.") --DONE
	addArchivement(46, "I haz se money and se powah!", "Buy a map.") --DONE
	addArchivement(47, "I want it again!", "Buy a map redo.") --DONE	
	addArchivement(48, "Shooter Pro", "Win 100 SHOOTER maps.") --DONE
	addArchivement(49, "Super Sexy Shooter King", "Win 1000 SHOOTER maps.") --DONE
	addArchivement(50, "Last man standing", "Win a Destruction Derby map.") --DONE
	addArchivement(51, "Rockets everywhere", "Win a SHOOTER map.") --DONE
	addArchivement(52, "Damn am I hot!", "Win a Destruction Derby map while burning.") --DONE
	addArchivement(53, "FIRST!", "Play a map on the first time run on the server.") --DONE
	addArchivement(54, "Finish!", "Reach the finish line of a race map.") --DONE
	addArchivement(55, "Le number one", "End a race map as first.") --DONE
	addArchivement(56, "Race Pro", "Win 100 RACE maps.") --DONE
	addArchivement(57, "Super Sexy Race King", "Win 1000 RACE maps.") --DONE
	addArchivement(58, "Traveller", "Drive 10.000 kilometres.") --DONE
	addArchivement(59, "Improved", "Beat your own top12 race- or huntertoptime.") --DONE
	addArchivement(60, "Megalomaniac", "Spin at least 100.000 Vero and win.") --DONE
	addArchivement(61, "Mr. Nice Guy", "Give at least 300.000 Vero to another player.") --DONE
	addArchivement(62, "Like a rainbow", "Buy a color for your car.") --DONE
	addArchivement(63, "The 'Nosejob'", "Stop being an ugly fag and buy a new skin.") --DONE
	addArchivement(64, "All by myself", "Be forever alone since all other people left your gamemode :((") --DONE
	addArchivement(65, "They see me rollin', they hatin'", "Get a new pair of wheels.") --DONE
	addArchivement(66, "Nigger stole my bike", "Stealing a bike in Ware as CJ.") --DONE
	addArchivement(67, "Lolz I haz minigun!", "Humiliate somebody with your minigun and win GunGame.") --DONE
	addArchivement(68, "Master of Hay.", "Climb the tower of hay.") --DONE
	addArchivement(69, "69", "Be level 69.") --DONE
	addArchivement(70, "Fat guys running", "Complete a map of Running Men.") --DONE
	addArchivement(71, "Coward", "Saving your position in Running Men.") --DONE
	addArchivement(72, "Fat fighter", "Stay alive for 180 seconds in an active Sumo fight.") --DONE
	addArchivement(73, "Perfect game", "Finish Ware with a score of 30/30.") --DONE
	addArchivement(74, "Headshot!", "Perform a headshot.") --DONE
	addArchivement(75, "Opinion leader", "Voting for the mode in Minigames which gets chosen.") --DONE
	addArchivement(76, "Light me up", "Modify your backlights.") --DONE
end
addEventHandler("onResourceStart", getResourceRootElement(), initArchivments)

function triggerArchievment2 ( message, messageType )
	if message == "I really like her mane?" then
		addPlayerArchivement(source, 2)
	end
	if string.find(message, "online.eu") ~= nil and string.find(message, "vita") ~= nil  then
		addPlayerArchivement(source, 39)
	end
end
addEventHandler( "onPlayerChat", getRootElement(), triggerArchievment2 )

function triggerArcheivment23_35 ( Money, Points, Number )
	setTimer (function ()
		for __, player in ipairs (getElementsByType("player")) do
			if isLoggedIn(player) then
				if getElementData(player, "Money") >= Money and getElementData(player, "Points") >= Points then
					addPlayerArchivement( player, Number )
				end
			end
		end
	end, 1000, 0)
end

triggerArcheivment23_35 ( 100, 100, 23 )
triggerArcheivment23_35 ( 2000, 1000, 24 )
triggerArcheivment23_35 ( 2500, 5000, 25 )
triggerArcheivment23_35 ( 5000, 10000, 26 )
triggerArcheivment23_35 ( 10000, 50000, 27 )
triggerArcheivment23_35 ( 15000, 100000, 28 )
triggerArcheivment23_35 ( 250000, 25000, 29 )
triggerArcheivment23_35 ( 500000, 50000, 30 )
triggerArcheivment23_35 ( 1000000, 100000, 31 )
triggerArcheivment23_35 ( 10000000, 1000000, 32 )
triggerArcheivment23_35 ( 100000, 0, 33 )
triggerArcheivment23_35 ( 1000000, 0, 34 )
triggerArcheivment23_35 ( 10000000, 0, 35 )