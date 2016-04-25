--[[
Project: vitaCore
File: chatsystem-server.lua
Author(s):	Sebihunter
]]--

function onChat(message, messageType)
	if isPlayerMuted ( source ) then cancelEvent() end
	if getElementData(source, "wareMaths") == true then cancelEvent() return end
	if messageType == 0 then
		for i,v in pairs(getGamemodePlayers(getPlayerGameMode(source))) do
			cancelEvent()
			local r,g,b = getPlayerNametagColor ( source )
			outputChatBox( _getPlayerName(source)..": #E7D9B0"..message, v, r,g,b,true  )
			--outputServerLog("(Mode: "..getPlayerGameMode(source)..") "..getPlayerName(source)..": "..tostring(message))
		end
		if pLogger[getPlayerGameMode(source)] then
			pLogger[getPlayerGameMode(source)]:addEntry(getPlayerName(source)..": "..tostring(message))
		end		
	elseif messageType == 1 then 
	--/me not needed on this server, disable it
		cancelEvent()
	elseif messageType == 2 then
		if getElementData(source, "Level") == "User" then return cancelEvent() end
		for id, player in pairs(getGamemodePlayers(getPlayerGameMode(source))) do
			if getElementData(player, "Level") == "Admin" or getElementData(player, "Level") == "Moderator" or getElementData(player, "Level") == "Member" or getElementData(player, "Level") == "Recruit" or getElementData(player, "Level") == "GlobalModerator" or getElementData(player, "Level") == "SeniorMember" then
				cancelEvent()
				outputChatBox ("(Team) "..getPlayerName(source)..": "..tostring(message), player, 173, 255, 47, true)
			end
		end
		if pLogger[getPlayerGameMode(source)] then
			pLogger[getPlayerGameMode(source)]:addEntry("(Team) "..getPlayerName(source)..": "..tostring(message))
		end
		--outputServerLog("(Team: "..getPlayerGameMode(source)..") "..getPlayerName(source)..": "..tostring(message))
	end	
end
addEventHandler ( "onPlayerChat", getRootElement(), onChat, true, "high")

addCommandHandler( "Lang",
	function( thePlayer, commandName, ... )
		if isLoggedIn(thePlayer) == true then
			local lang = getElementData(thePlayer, "language")
			if lang == 1 then outputChatBox( "Error: No language selected.", thePlayer, 255,0,0,true  ) return false end
			if isPlayerMuted ( thePlayer ) then
				outputChatBox( "Error: "..gSupportedLanguages[lang].." chat not active while being muted", thePlayer, 255,0,0,true  )
				return false
			end			
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				for id, player in pairs(getElementsByType("player")) do
					if getElementData(player, "language") == lang then
						outputChatBox ("("..gSupportedLanguages[lang]..") "..getPlayerName(thePlayer)..": #E7D9B0"..tostring(message), player, 199, 44, 125, true)					
					end
				end		
				if langLogger[lang] then
					langLogger[lang]:addEntry(getPlayerName(thePlayer)..": "..tostring(message))
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " ["..gSupportedLanguages[lang].." message]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

addCommandHandler( "GTeam",
	function( thePlayer, commandName, ... )
		if isLoggedIn(thePlayer) == true then
			if isPlayerMuted ( thePlayer ) then
				outputChatBox( "Error: Global teamchat not active while being muted", thePlayer, 255,0,0,true  )
				return false
			end
			if getElementData(thePlayer, "Level") == "User" then return false end
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				for id, player in pairs(getElementsByType("player")) do
					if getElementData(player, "Level") == "Admin" or getElementData(player, "Level") == "Moderator" or getElementData(player, "Level") == "Member" or getElementData(player, "Level") == "Recruit" or getElementData(player, "Level") == "GlobalModerator" or getElementData(player, "Level") == "SeniorMember" then
						outputChatBox ("(GTeam) "..getPlayerName(thePlayer)..": "..tostring(message), player, 47, 173, 255, true)
					end
				end			
				outputServerLog("(GGlobal) "..getPlayerName(thePlayer)..": "..tostring(message))
			else
				outputChatBox( "Syntax: /" .. commandName .. " [global message]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

addCommandHandler( "Global",
	function( thePlayer, commandName, ... )
		if isLoggedIn(thePlayer) == true then
			if isPlayerMuted ( thePlayer ) then
				outputChatBox( "Error: Globalchat not active while being muted", thePlayer, 255,0,0,true  )
				return false
			end		
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				outputServerLog("(Global) "..getPlayerName(thePlayer)..": "..tostring(message))
				outputChatBox("[Global] "..getPlayerName(thePlayer)..": #E7D9B0"..message, getRootElement(), 255,165,0,true)
			else
				outputChatBox( "Syntax: /" .. commandName .. " [global message]", thePlayer, 255, 255, 255 )
			end
		end
	end
)