--[[
Project: vitaCore - vitaWave
File: help.lua
Author(s):	Sebihunter
]]--


waveVitaMembers = {}

helpBox = guiCreateComboBox ( screenWidth/2+212, screenHeight/2+200, 180, 125, "", false )
guiComboBoxAddItem( helpBox, "Members" )
guiComboBoxAddItem( helpBox, "Commands #1" )
guiComboBoxAddItem( helpBox, "Commands #2" )
guiComboBoxAddItem( helpBox, "Binds" )
guiComboBoxAddItem( helpBox, "Rules" )
guiComboBoxAddItem( helpBox, "About" )
guiComboBoxSetSelected ( helpBox, 0 )
guiSetVisible(helpBox, false)


function waveRefreshVitaMembers()
	waveVitaMembers = {}
	waveVitaMembers.admins = {}
	waveVitaMembers.gmods = {}
	waveVitaMembers.mods = {}
	waveVitaMembers.seniors = {}
	waveVitaMembers.members = {}
	waveVitaMembers.recruits = {}
	
	for i, v in pairs(getElementsByType("userAccount")) do
		local userLevel = getElementData(v, "Level")
		local userName = getElementData(v, "PlayerName")
		if tostring(userName) ~= "false" and tostring(userLevel) ~= "false" then
			if (userLevel == "Leader") then
				waveVitaMembers.admins[#waveVitaMembers.admins+1] = userName
			elseif (userLevel == "CoLeader") then
				waveVitaMembers.gmods[#waveVitaMembers.gmods+1] = userName
			elseif (userLevel == "Moderator") then
				waveVitaMembers.mods[#waveVitaMembers.mods+1] = userName
			elseif (userLevel == "SeniorMember") then
				waveVitaMembers.seniors[#waveVitaMembers.seniors+1] = userName
			elseif (userLevel == "Member") then
				waveVitaMembers.members[#waveVitaMembers.members+1] = userName
			elseif (userLevel == "Recruit") then
				waveVitaMembers.recruits[#waveVitaMembers.recruits+1] = userName
			end
		end
	end
end

function waveDrawHelp()
	if guiComboBoxGetSelected ( helpBox ) == -1 then guiComboBoxSetSelected ( helpBox, 0 ) end
	if guiComboBoxGetSelected ( helpBox ) == 0 then

		local lines = 0
		local isDrawn = false
		
		--[[
		First row
		]]--
		
		--Members
		dxDrawShadowedText("Members ("..#waveVitaMembers.members..")",screenWidth/2-392,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.members) do
			isDrawn = true
			dxDrawShadowedText(tostring(v),screenWidth/2-392,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines+15
		end
		
		if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2-392,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines +15
		end
		lines = lines +5
		isDrawn = false

		--[[
		Second row
		]]--
		lines = 0
		
		--Recruits
		--[[dxDrawShadowedText("Recruits ("..#waveVitaMembers.recruits..")",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.recruits) do
			isDrawn = true
			dxDrawShadowedText(v,screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			lines = lines+15
		end
		
		if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines +15
		end
		lines = lines +5
		isDrawn = false	]]
		
		--Seniors
		--[[dxDrawShadowedText("Senior Members ("..#waveVitaMembers.seniors..")",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.seniors) do
			isDrawn = true
			dxDrawShadowedText(v,screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines+15
		end]]
		
		--[[if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			lines = lines +15
		end
		lines = lines+5
		isDrawn = false]]
		
		dxDrawShadowedText("Moderators ("..#waveVitaMembers.mods..")",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.mods) do
			isDrawn = true
			dxDrawShadowedText(v,screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines+15
		end
		
		if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2-192,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			lines = lines +15
		end	

		
		--[[
		Third row, reset dat stuff
		]]--
		
		lines = 0
		isDrawn = false	
		
		--[[dxDrawShadowedText("Global Moderators ("..#waveVitaMembers.gmods..")",screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.gmods) do
			isDrawn = true
			dxDrawShadowedText(v,screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines+15
		end
		
		if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			lines = lines +15
		end	
		isDrawn = false		
		lines = lines+5]]

		dxDrawShadowedText("Admins ("..#waveVitaMembers.admins..")",screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		lines = lines + 20
		for i,v in ipairs(waveVitaMembers.admins) do
			isDrawn = true
			dxDrawShadowedText(v,screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			lines = lines+15
		end
		
		if isDrawn == false then
			dxDrawShadowedText("none",screenWidth/2+92,screenHeight/2-240+lines, screenWidth, screenHeight, tocolor(255, 255, 255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			lines = lines +15
		end
		lines = lines+5
		isDrawn = false			
	elseif guiComboBoxGetSelected ( helpBox ) == 1 then
		dxDrawShadowedText("General Commands",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("/spin [1-3] [money] - Spin and win! (or more likely lose your money)",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		if getPlayerGameMode(getLocalPlayer()) == 4 then
			dxDrawShadowedText("/roll - Roll the dice for random things to happen",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/bet [playername] [money] - Bet on a player. If he wins earn some cash for doing nothing!",screenWidth/2-392,screenHeight/2-190, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/repair - Fix your vehicle for a small fee.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/flip - Your vehicle is upside-down? Flip it for some cash to drive further.",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/pvp [playername] [money] - Start a PvP war with somebody by using this command.",screenWidth/2-392,screenHeight/2-145, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		else
			dxDrawShadowedText("/roll - Roll the dice for random things to happen",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/bet [playername] [money] - Bet on a player. If he wins earn some cash for doing nothing!",screenWidth/2-392,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/repair - Fix your vehicle for a small fee.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/flip - Your vehicle is upside-down? Flip it for some cash to drive further.",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/pvp [playername] [money] - Start a PvP war with somebody by using this command.",screenWidth/2-392,screenHeight/2-145, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		end
		dxDrawShadowedText("/send [playername] [money] - Be a nice guy and share your money with others.",screenWidth/2-392,screenHeight/2-130, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/pm [playername] [text] - Got a private mesage to send? Here you go!",screenWidth/2-392,screenHeight/2-115, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/bt - This simple command buys you a lottery ticket for 300 Vero.",screenWidth/2-392,screenHeight/2-100, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)

		dxDrawShadowedText("Member Commands",screenWidth/2-392,screenHeight/2-80, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("/lang | /glang | /camp | /ins | /spam - Send different warnings.",screenWidth/2-392,screenHeight/2-60, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/mutePlayer | /pmute [player] [minutes] - Mute a player for several minutes.",screenWidth/2-392,screenHeight/2-45, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/killPlayer | /pkill [player] - Kill an alive player.",screenWidth/2-392,screenHeight/2-30, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/kickPlayer | /pkick [player] - Kick a player from the server.",screenWidth/2-392,screenHeight/2-15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Senior Member Commands",screenWidth/2-392,screenHeight/2+5, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		if getPlayerGameMode(getLocalPlayer()) == 4 then
			dxDrawShadowedText("/setnextmap [mapname] - Sets the next map for the current gamemode.",screenWidth/2-392,screenHeight/2+25, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/redo - Sets the current map of your gamemode for redo.",screenWidth/2-392,screenHeight/2+40, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		else
			dxDrawShadowedText("/setnextmap [mapname] - Sets the next map for the current gamemode.",screenWidth/2-392,screenHeight/2+25, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("/redo - Sets the current map of your gamemode for redo.",screenWidth/2-392,screenHeight/2+40, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		end
		dxDrawShadowedText("Moderator Commands",screenWidth/2-392,screenHeight/2+60, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		if getPlayerGameMode(getLocalPlayer()) ~= 3 and getPlayerGameMode(getLocalPlayer()) ~= 5 then
			dxDrawShadowedText("/deletetime [ID] - Deletes a toptime with the given ID.",screenWidth/2-392,screenHeight/2+80, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		else
			dxDrawShadowedText("/deletetime [ID] - Deletes a toptime with the given ID.",screenWidth/2-392,screenHeight/2+80, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		end
		dxDrawShadowedText("/skipMap - Skips the current map.",screenWidth/2-392,screenHeight/2+95, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/deleteMap [mapname] - Deletes the map from the server.",screenWidth/2-392,screenHeight/2+110, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/fixMap [mapname] - Marks the map to be fixed.",screenWidth/2-392,screenHeight/2+125, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/banPlayer | /pban [player] [minutes] - Bans a player for a certain time.",screenWidth/2-392,screenHeight/2+140, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
	elseif guiComboBoxGetSelected ( helpBox ) == 2 then
		dxDrawShadowedText("Co-Leader Commands",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("/setdonator [player] [0/1] [date] - Give a player donator rights or revoke them.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/setmoney [player] [money] - Give somebody more or less money than he had before.",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/setrights [player] [User/Member/...] - Welcome a player to Vita, or to simply tell him to GTFO.",screenWidth/2-392,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/setmemeacc [player] [0/1] - Allow a player to use memes or not.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/addachievement [player] [ID] - Manually give a player an achievement.",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Leader Commands",screenWidth/2-392,screenHeight/2-140, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("/setlevel [player] [level] - Change the level of somebody on the server.",screenWidth/2-392,screenHeight/2-120, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("/setpoints [player] [points] - Set a players points to a different ammount.",screenWidth/2-392,screenHeight/2-105, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
	
	elseif guiComboBoxGetSelected ( helpBox ) == 3 then
		dxDrawShadowedText("General Binds",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("F1 / F9 - Shortcut to 'Information' page in the userpanel.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("F2 - Toggle carfade mode.",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("F3 - Back to gamemode selection.",screenWidth/2-392,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		if getPlayerGameMode(getLocalPlayer()) == 4 then
			dxDrawShadowedText("F / ENTER - Kill yourself when playing.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(150,150,150,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		else
			dxDrawShadowedText("F / ENTER - Kill yourself when playing.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		end
		dxDrawShadowedText("U - Toggle userpanel.",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("G - Global chat.",screenWidth/2-392,screenHeight/2-145, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("L - Global language chat.",screenWidth/2-392,screenHeight/2-130, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		if getPlayerGameMode(getLocalPlayer()) == 4 then
			dxDrawShadowedText("R - Radio.",screenWidth/2-392,screenHeight/2-115, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		else
			dxDrawShadowedText("R / SCROLL - Radio.",screenWidth/2-392,screenHeight/2-115, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		end
		
		dxDrawShadowedText("Gamemode Specific Binds",screenWidth/2-392,screenHeight/2-95, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("[DM/RACE] F5 - Show toptimes.",screenWidth/2-392,screenHeight/2-75, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("[DM] N - Respawn at the last saved position.",screenWidth/2-392,screenHeight/2-60, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("[DM] C - Respawn at the spawn.",screenWidth/2-392,screenHeight/2-45, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Member Binds",screenWidth/2-392,screenHeight/2-25, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("P - Toggle your adminpanel.",screenWidth/2-392,screenHeight/2-5, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Y - Gamemode teamchat.",screenWidth/2-392,screenHeight/2+10, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("X - Global teamchat.",screenWidth/2-392,screenHeight/2+25, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
	elseif guiComboBoxGetSelected ( helpBox ) == 4 then	
		dxDrawShadowedText("1) General Rules",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("(a) The rules must be always obeyed. The administration must not inform anybody if there is a rule change.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(b) You may not do actions which lead to conflicts between members.",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(c) Multi-accounting and account-sharing is forbidden.",screenWidth/2-392,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(d) You may not hurt somebodies dignity. This also affects insults, hating speeches, annoying others and any form of bullying.",screenWidth/2-392,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(e) You may always follow the orders by the administration and any moderator. Do not insult the administration, respect them.",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(f) Every member can be either warned, punished or kicked out of the community for various reasons.",screenWidth/2-392,screenHeight/2-145, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
	
		dxDrawShadowedText("5) Vita3 Serverrules",screenWidth/2-392,screenHeight/2-125, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("(a) Cheating, Hacking, Bugusing etc. is not allowed.",screenWidth/2-392,screenHeight/2-105, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(b) You may only talk english in the mainchat.",screenWidth/2-392,screenHeight/2-90, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(c) When camping you may be killed by the server moderation.",screenWidth/2-392,screenHeight/2-75, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(d) Use appropriate language in the main chat.",screenWidth/2-392,screenHeight/2-60, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(e) Using colors in the nickname used by Vita teams is not allowed. You may also not use black as color as it is hardly readable.",screenWidth/2-392,screenHeight/2-45, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(f) You may only kill/block people on DM maps after reaching the final vehicle.",screenWidth/2-392,screenHeight/2-30, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(g) The administration/moderation may exclude any player from the server.",screenWidth/2-392,screenHeight/2-15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(h) You may not use the AFK-reason script while you are muted to avoid the mute.",screenWidth/2-392,screenHeight/2+0, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(i) Excessive setting of maps or redoing is forbidden.",screenWidth/2-392,screenHeight/2+15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("(j) Vita members may follow the extra serverguidelines stated below.",screenWidth/2-392,screenHeight/2+30, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("-(j1) You may only name yourself on the server as stated in the application when logged in.",screenWidth/2-392,screenHeight/2+45, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("-(j2) You may kill non Vita| members before killing your clanmates in DD, SH and DM.",screenWidth/2-392,screenHeight/2+60, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("-(j3) You may not change the color of the Vita| clantag.",screenWidth/2-392,screenHeight/2+75, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("-(j4) Skipping maps without a real reason is striclty forbidden and will be punished by being kicked from the clan. ",screenWidth/2-392,screenHeight/2+90, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
	elseif guiComboBoxGetSelected ( helpBox ) == 5 then
		dxDrawShadowedText("Vita3 created by:",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Sebastian 'Sebihunter' M.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Contributions by:",screenWidth/2-392,screenHeight/2-200, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Johannes 'Jake' H.",screenWidth/2-392,screenHeight/2-180, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Rick 'Werni' S.",screenWidth/2-392,screenHeight/2-165, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Alex 'Lexlo' B.",screenWidth/2-392,screenHeight/2-150, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Pascal 'MrX' S.",screenWidth/2-392,screenHeight/2-135, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Justus 'Jusonex' H.",screenWidth/2-392,screenHeight/2-120, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Aeron",screenWidth/2-392,screenHeight/2-105, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		--TODO: Add Ransom if Fallout added
		
		dxDrawShadowedText("Special thanks to:",screenWidth/2-392,screenHeight/2-85, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Dean 'ExXoTicC' T.",screenWidth/2-392,screenHeight/2-65, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Roman 'Corby' W.",screenWidth/2-392,screenHeight/2-50, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Daniel 'Sense' B.",screenWidth/2-392,screenHeight/2-35, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Michael 'mopey24' S.",screenWidth/2-392,screenHeight/2-20, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Silvio 'SickStar' S.",screenWidth/2-392,screenHeight/2-5, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Testing by:",screenWidth/2-192,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Sebihunter",screenWidth/2-192,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Corby",screenWidth/2-192,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Jones",screenWidth/2-192,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("KruemeL",screenWidth/2-192,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("DeSmith",screenWidth/2-192,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Jake",screenWidth/2-192,screenHeight/2-145, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Schranzeule",screenWidth/2-192,screenHeight/2-130, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("ExXoTicC",screenWidth/2-192,screenHeight/2-115, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("#Dome^^",screenWidth/2-192,screenHeight/2-100, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Tazmaniiac",screenWidth/2-192,screenHeight/2-85, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Tobes",screenWidth/2-192,screenHeight/2-70, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Cookie",screenWidth/2-192,screenHeight/2-55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("FaZe",screenWidth/2-192,screenHeight/2-40, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("SickStar",screenWidth/2-192,screenHeight/2-25, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("fudel",screenWidth/2-192,screenHeight/2-10, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Snicker",screenWidth/2-192,screenHeight/2+5, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("xDemO",screenWidth/2-192,screenHeight/2+20, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("NiKe",screenWidth/2-192,screenHeight/2+35, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("DubZ",screenWidth/2-192,screenHeight/2+50, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("revliS",screenWidth/2-192,screenHeight/2+65, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Hypnotic",screenWidth/2-92,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Sinatra",screenWidth/2-92,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Radion",screenWidth/2-92,screenHeight/2-190, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("LioNKinG",screenWidth/2-92,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Vaali",screenWidth/2-92,screenHeight/2-160, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("[D]ubStep",screenWidth/2-92,screenHeight/2-145, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Gerard",screenWidth/2-92,screenHeight/2-130, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Leyo",screenWidth/2-92,screenHeight/2-115, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Nitaco",screenWidth/2-92,screenHeight/2-100, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
	end
	guiSetVisible(helpBox, true)
end
