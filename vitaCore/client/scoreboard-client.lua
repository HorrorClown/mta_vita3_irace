--[[
Project: vitaCore
File: scoreboard-client.lua
Author(s):	Jake
			Sebihunter
]]--

scdatas = {}

---Other values---
scdatas.cursor = false

---Player values---
scdatas.extendedplayers = {}
scdatas.playerclickables = {}


---Gamemode Values---
scdatas.gameMode = 0
scdatas.lastMode = 0

scdatas.gmDM = clickableAreaCreate(0,0,0,0)
addEventHandler("onClickableAreaClick", scdatas.gmDM, function(button, state) if button == "left" and state == "down" and scdatas.enabled == true then scdatas.gameMode = 5 end end)

scdatas.gmDD = clickableAreaCreate(0,0,0,0)
addEventHandler("onClickableAreaClick", scdatas.gmDD, function(button, state) if button == "left" and state == "down" and scdatas.enabled == true then scdatas.gameMode = 2 end end)

scdatas.gmSH = clickableAreaCreate(0,0,0,0)
addEventHandler("onClickableAreaClick", scdatas.gmSH, function(button, state) if button == "left" and state == "down" and scdatas.enabled == true then scdatas.gameMode = 1 end end)

scdatas.gmRA = clickableAreaCreate(0,0,0,0)
addEventHandler("onClickableAreaClick", scdatas.gmRA, function(button, state) if button == "left" and state == "down" and scdatas.enabled == true then scdatas.gameMode = 3 end end)

scdatas.gmMI = clickableAreaCreate(0,0,0,0)
addEventHandler("onClickableAreaClick", scdatas.gmMI, function(button, state) if button == "left" and state == "down" and scdatas.enabled == true then scdatas.gameMode = 4 end end)

---Scoreboardvalues---

scdatas.bcolor = tocolor(255,255,255,150)
scdatas.x, scdatas.y = guiGetScreenSize()
scdatas.x2, scdatas.y2 = guiGetScreenSize()
scdatas.width = 800
scdatas.alignx, scdatas.aligny = "left","top"
scdatas.set1,scdatas.set2,scdatas.set3 = false,false,true
scdatas.colorcoded = true
scdatas.rowid = 0
scdatas.height = 480

---Textheadvalues---


---Textvalues---
scdatas.textscale = 0.8
scdatas.textfont = "default-bold"
scdatas.textfontheight = dxGetFontHeight(scdatas.textscale,scdatas.textfont)
scdatas.textfontcalc = scdatas.textfontheight + 2

---Titlevalues---
scdatas.titlefont = "default-bold"        
--scdatas.titlestats = "Name                                                                                          Country              Points                            Rank                  Money                                         Ping"
scdatas.titlefontheight = dxGetFontHeight(10,scdatas.titlefont) 
scdatas.titlefontcalc = scdatas.titlefontheight + 2
scdatas.titlecolor = {}
scdatas.titlecolor = tocolor(119,119,119,255)
scdatas.titlecolorfont = tocolor(255,255,255,255)
scdatas.titlebgheight = 25
scdatas.titleplayertextwidth = scdatas.x/2+270

---Headline--
--scdatas.hr, scdatas.hg, scdatas.hb = getColorFromString("#ffa019")
scdatas.headcolor = tocolor(0,0,0,200)
scdatas.headtitlecolor = tocolor(255,255,255,255)

---Playervalues---
scdatas.playercolor = tocolor(255,255,255,255)
scdatas.playerfont = "default-bold"
scdatas.id = 0
scdatas.playerbgheight = 548
scdatas.playerbgcolor = tocolor(0,0,0,200)

---Other Scoreboardvariables---
scdatas.enabled = false
scdatas.players = { users = {}, donators = {}, recruit = {}, member = {}, smember = {}, moderator = {}, gmoderator = {}, admin = {}}

function isLevelVitaTeam(teamname)
	local teamNames = {
	[1] = "Recruit", 
	[2] = "Member",
	[3] = "SeniorMember",
	[4] = "Moderator",
	[5] = "GlobalModerator",
	[6] = "Admin"
	}
	for i,v in ipairs(teamNames) do
		if v == teamname then return true end
	end
	return false
end

bindKey("mouse_wheel_down","down",function() 
	if scdatas.enabled == true and allowScroll == true then
		local dif = scdatas.height - scdatas.y2 
		if scdatas.y+100 > scdatas.y2+dif then
			scdatas.y = scdatas.y2 + dif
		else
			scdatas.y = scdatas.y +100
		end
	end
end)
bindKey("mouse_wheel_up","down",function() 
	if scdatas.enabled == true and allowScroll == true then
		scdatas.y = scdatas.y - 100
	end
end)

bindKey("tab","down",function()
	if isLoggedIn(getLocalPlayer()) == true and isInGamemode(getLocalPlayer(), 0) == false and minigamesVoteShown == false then	
		scdatas.enabled = true
		if scdatas.lastMode ~= getPlayerGameMode(getLocalPlayer()) then
			scdatas.lastMode = getPlayerGameMode(getLocalPlayer())
			scdatas.gameMode = getPlayerGameMode(getLocalPlayer())
		end
		addEventHandler("onClientRender",root,drawScoreboard, false, "low-1")
	end
end)

bindKey ( "mouse2", "down", function()
	if scdatas.enabled == true then
		if not isCursorShowing () then 
			showCursor ( true, false)
			scdatas.cursor = true
		end	
	end
end)

bindKey ( "mouse2", "up", function()
	if scdatas.enabled == true then
		if scdatas.cursor == true then 
			showCursor ( false, false)
			scdatas.cursor = false
			if getKeyState ( "tab" ) == false then
				scdatas.enabled = false
				removeEventHandler("onClientRender",root,drawScoreboard)		
			end
		end
	end
end)

bindKey("tab","up",function()
	if scdatas.enabled == true then
		if scdatas.cursor == false then 
			scdatas.enabled = false
			removeEventHandler("onClientRender",root,drawScoreboard)
		end
	end
end)

local isScoreboardEntryDarker = false
function drawScoreboard()
	if isInGamemode(getLocalPlayer(), 0) == true or minigamesVoteShown == true then
		scdatas.enabled = false
		removeEventHandler("onClientRender",root,drawScoreboard)	
	end
	
	for i,v in ipairs(scdatas.playerclickables) do
		if v and isElement(v) then destroyElement(v) end
	end
	scdatas.playerclickables = {}
	
	local gameMode = scdatas.gameMode
	---Some newly added settings--
	--scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)
	scdatas.titletext = "Vita Race | race.vita-online.eu | "..gRaceModes[gameMode].name
	
	---Draws the Title---
	dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2, scdatas.width, 50, tocolor(0,0,0,200))
	dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2, scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2, tocolor(119,119,119,255), 1, false )
	dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2, scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2+50, tocolor(119,119,119,255), 1, false )
	dxDrawLine ( scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2, scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2+50, tocolor(119,119,119,255), 1, false )
	dxDrawText(scdatas.titletext,scdatas.x/2-scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 10, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Server: "..#getElementsByType ("player" ).."/128 - Gamemode: "..#getGamemodePlayers(gameMode).."/"..gRaceModes[gameMode].maxplayers,scdatas.x/2-scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 10, scdatas.x/2+scdatas.width/2-10, scdatas.y, tocolor(175,175,175,255), 1, "default-bold", "right", "top", false, false, true, true)
	
	dxDrawText("Name",scdatas.x/2-scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Rank",scdatas.x/2 - scdatas.width/2 + 300, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Money",scdatas.x/2 - scdatas.width/2 + 350, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Level",scdatas.x/2 - scdatas.width/2 + 460, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Points",scdatas.x/2 - scdatas.width/2 + 520, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
	dxDrawText("State",scdatas.x/2 - scdatas.width/2 + 600, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
	dxDrawText("FPS",scdatas.x/2 - scdatas.width/2 + 710, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
	dxDrawText("Ping",scdatas.x/2 - scdatas.width/2 + 760, scdatas.y/2 - scdatas.height/2 + 30, scdatas.x, scdatas.y, tocolor(175,175,175,255), 1,  "default-bold", "left", "top", false, false, true, true)
		
	---Drawin the Playercolumns
	for id, pl in ipairs(getGamemodePlayers(gameMode)) do
		
		---Settings some playervalues ---
		scdatas.player = pl
		scdatas.name = _getPlayerName(pl)
		scdatas.points = "-"
		scdatas.rank = "-"
		scdatas.money = "-"
		scdatas.country = getElementData(pl, "country") -- must be still done
		scdatas.ping = getPlayerPing(pl)
		scdatas.fps = "-"
		scdatas.state = "-"
		scdatas.level = "-"
		scdatas.accountname = "-"
		local teamrank = "User"
		donatorstate = 0
			
		if isLoggedIn(getLocalPlayer()) == true then
			scdatas.points = tostring(getElementData(pl,"Points"))
			scdatas.rank = tostring(getElementData(pl,"rankScoreboard"))
			scdatas.level = tostring(getElementData(pl,"Rank"))
			scdatas.accountname = tostring(getElementData(pl, "AccountName"))
			if scdatas.rank  == false or scdatas.rank  == nil or scdatas.rank  == "false" then scdatas.rank = "-" end
			scdatas.money = tostring(getElementData(pl,"Money")).." Vero"
			teamrank = getElementData(pl,"Level")
			scdatas.fps = tostring(getElementData(pl, "FPS"))
			if getElementData(pl, "AFK") == true then
				scdatas.state = "AFK"
			else
				scdatas.state = tostring(getElementData(pl, "state"))
			end
			donatorstate = getElementData(pl,"isDonator")
		else
			scdatas.state = "logged out"
		end	
				
		if isCursorShowing ( ) then
			scdatas.playerclickables[#scdatas.playerclickables+1] = clickableAreaCreate(0,0,0,0)
			setElementData(scdatas.playerclickables[#scdatas.playerclickables], "AccountName",  scdatas.accountname)
			addEventHandler("onClickableAreaClick", scdatas.playerclickables[#scdatas.playerclickables], togglePlayerExtension)
		end
		
		if isLevelVitaTeam(teamrank) == false and donatorstate == false then
			table.insert(scdatas.players.users, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "Recruit" then
			table.insert(scdatas.players.recruit, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "Member" then
			table.insert(scdatas.players.member, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "SeniorMember" then
			table.insert(scdatas.players.smember, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "Moderator" then
			table.insert(scdatas.players.moderator, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "GlobalModerator" then
			table.insert(scdatas.players.gmoderator, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif teamrank == "Admin" then
			table.insert(scdatas.players.admin, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		elseif donatorstate == true and isLevelVitaTeam(teamrank) == false then
			table.insert(scdatas.players.donators, { name = scdatas.name, country = scdatas.country, points = scdatas.points, rank = scdatas.rank, money = scdatas.money, ping = scdatas.ping, state = scdatas.state, fps = scdatas.fps, level = scdatas.level, accountname = scdatas.accountname, player = scdatas.player } )
		end
		
	end
	isScoreboardEntryDarker = false
	scdatas.rowid = 1
	--Users
	for id, user in ipairs(scdatas.players.users) do	
		drawUserstats(user, 255,255,255)
		scdatas.rowid = scdatas.rowid + 1
	end

		
	--Donator
	for id, user in ipairs(scdatas.players.donators) do	
		drawUserstats(user, 194,103,255, "Donator")
		scdatas.rowid = scdatas.rowid + 1
	end
	
	--Recruit
	for id, team in ipairs(scdatas.players.recruit) do
		drawUserstats(team, 0, 51, 221, "Recruit")
		scdatas.rowid = scdatas.rowid + 1
	end
	
	--Member
	for id, team in ipairs(scdatas.players.member) do
		drawUserstats(team, 0, 119, 255, "Member")
		scdatas.rowid = scdatas.rowid + 1	
	end
	
	--SeniorMember
	for id, team in ipairs(scdatas.players.smember) do
		drawUserstats(team, 0, 187, 255, "Senior Member")
		scdatas.rowid = scdatas.rowid + 1
	end
	
	--Moderator
	for id, team in ipairs(scdatas.players.moderator) do
		drawUserstats(team, 0, 189, 57, "Moderator")
		scdatas.rowid = scdatas.rowid + 1
	end
	
	--GlobalModerator	
	for id, team in ipairs(scdatas.players.gmoderator) do
		drawUserstats(team, 0, 243, 113, "Global Moderator")
		scdatas.rowid = scdatas.rowid + 1
	end	
	
	--Admin
	for id, team in ipairs(scdatas.players.admin) do
		drawUserstats(team, 130, 134, 134, "Admin")
		scdatas.rowid = scdatas.rowid + 1
	end
	
	--GameMode Selection
	dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, dxGetFontHeight(1,"default-bold")+5+20, tocolor(0,0,0,200))
	dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20+5+dxGetFontHeight(1,"default-bold"),tocolor(119,119,119,255), 1, false )
	dxDrawLine ( scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20+5+dxGetFontHeight(1,"default-bold"), tocolor(119,119,119,255), 1, false )		
	dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2+ 30 + ( 20 * scdatas.rowid)+dxGetFontHeight(1,"default-bold")+5+20, scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2+ 30 + ( 20 * scdatas.rowid)+dxGetFontHeight(1,"default-bold")+5+20, tocolor(119,119,119,255), 1, false )
	
	clickableAreaSetPosition(scdatas.gmDM, scdatas.x/2 - 400, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7)
	clickableAreaSetSize(scdatas.gmDM,160, dxGetFontHeight(1,"default-bold")+2)
	if clickableAreaIsHovering(scdatas.gmDM) then
		--dxDrawRectangle(scdatas.x/2 - 206, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(10,10,10,255))
		dxDrawText("Deathmatch", scdatas.x/2 - 400, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 - 240, scdatas.y, tocolor(255,255,50,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	else
		--dxDrawRectangle(scdatas.x/2 - 206, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(5,5,5,255))
		dxDrawText("Deathmatch", scdatas.x/2 - 400, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 - 240, scdatas.y, tocolor(130,130,130,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	end

	clickableAreaSetPosition(scdatas.gmDD, scdatas.x/2 - 240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7)
	clickableAreaSetSize(scdatas.gmDD,160, dxGetFontHeight(1,"default-bold")+2)	
	if clickableAreaIsHovering(scdatas.gmDD) then
		--dxDrawRectangle(scdatas.x/2 - 102, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(10,10,10,255))
		dxDrawText("Destruction Derby", scdatas.x/2 - 240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 - 80, scdatas.y, tocolor(255,255,50,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	else	
		--dxDrawRectangle(scdatas.x/2 - 102, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(5,5,5,255))
		dxDrawText("Destruction Derby", scdatas.x/2 - 240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 - 80, scdatas.y, tocolor(130,130,130,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	end

	clickableAreaSetPosition(scdatas.gmSH, scdatas.x/2 -80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7)
	clickableAreaSetSize(scdatas.gmSH,160, dxGetFontHeight(1,"default-bold")+2)	
	if clickableAreaIsHovering(scdatas.gmSH) then
		--dxDrawRectangle(scdatas.x/2 + 2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(10,10,10,255))
		dxDrawText("Shooter", scdatas.x/2 - 80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 80, scdatas.y, tocolor(255,255,50,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	else
		--dxDrawRectangle(scdatas.x/2 + 2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(5,5,5,255))
		dxDrawText("Shooter", scdatas.x/2 - 80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 80, scdatas.y, tocolor(130,130,130,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	end
	
	clickableAreaSetPosition(scdatas.gmRA, scdatas.x/2 + 80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7)
	clickableAreaSetSize(scdatas.gmRA,160, dxGetFontHeight(1,"default-bold")+2)	
	if clickableAreaIsHovering(scdatas.gmRA) then
		--dxDrawRectangle(scdatas.x/2 + 106, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(10,10,10,255))
		dxDrawText("Race", scdatas.x/2 +80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 240, scdatas.y, tocolor(255,255,50,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	else	
		--dxDrawRectangle(scdatas.x/2 + 106, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(5,5,5,255))
		dxDrawText("Race", scdatas.x/2 +80, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 240, scdatas.y, tocolor(130,130,130,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	end

	clickableAreaSetPosition(scdatas.gmMI, scdatas.x/2 + 240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7)
	clickableAreaSetSize(scdatas.gmMI,160, dxGetFontHeight(1,"default-bold")+2)	
	if clickableAreaIsHovering(scdatas.gmMI) then
		--dxDrawRectangle(scdatas.x/2 + 106, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(10,10,10,255))
		dxDrawText("Minigames", scdatas.x/2 +240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 400, scdatas.y, tocolor(255,255,50,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	else	
		--dxDrawRectangle(scdatas.x/2 + 106, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 7, 100, dxGetFontHeight(1,"default-bold")+2, tocolor(5,5,5,255))
		dxDrawText("Minigames", scdatas.x/2 +240, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 9, scdatas.x/2 + 400, scdatas.y, tocolor(130,130,130,255), 0.9, "default-bold", "center", "top", false, false, true, true)
	end
	
	scdatas.rowid = scdatas.rowid + 1
	dxDrawText("hold right to toggle mouse", 0, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid) + 1+3, scdatas.x, scdatas.y, tocolor(130,130,130,255), 0.8, "clear", "center", "top", false, false, true, true) 	
	
	scdatas.players = { users = {}, donators = {}, recruit = {}, member = {}, smember = {}, moderator = {}, gmoderator = {}, admin = {}}
	
	scdatas.height = 30 + ( 20 * scdatas.rowid)+ 3
	
	if scdatas.height > scdatas.y2 then
		allowScroll = true
		local dif = scdatas.height - scdatas.y2 
		if scdatas.y > scdatas.y2+dif then
			scdatas.y = scdatas.y2 + dif
		elseif scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+dxGetFontHeight(1,"default-bold")+5 < scdatas.y2 then
			--scdatas.y = scdatas.y2/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+dxGetFontHeight(1,"default-bold")+5
			dxDrawShadowedText("SHTAAP SCROLLING :'(", 0, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+4)) + 1+3, scdatas.x, scdatas.y, tocolor(255,255,255,255), tocolor(0,0,0,255), 3, "clear", "center", "top", false, false, true, true) 	
		end
	else
		allowScroll = false
		scdatas.y = scdatas.y2
	end
end
	

function drawUserstats(user, r, g, b, team)
	if isCursorShowing ( ) then
		for i,v in ipairs(scdatas.playerclickables) do
			if user.accountname == getElementData(v, "AccountName") then
				clickableAreaSetPosition(v, scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid))
				clickableAreaSetSize(v, scdatas.width, dxGetFontHeight(1,"default-bold")+2)	
				if clickableAreaIsHovering(v) then
					dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20, tocolor(50,50,50,150))
				else
					if isScoreboardEntryDarker == true then
						dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20, tocolor(20,20,20,150))
					else
						dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20, tocolor(0,0,0,150))
					end
				end
				break
			end
		end
	else
		if isScoreboardEntryDarker == true then
			dxDrawRectangle ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20, tocolor(20,20,20,150) )
		else
			dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20, tocolor(0,0,0,150))
		end		
	end
	dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20, tocolor(119,119,119,255), 1, false )
	dxDrawLine ( scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20, tocolor(119,119,119,255), 1, false )		

	if user.country ~= "Unknown" then
		if fileExists("files/flags/"..string.lower(tostring(user.country))..".png") then
			dxDrawImage(scdatas.x/2 - scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid ) + 5 , 16, 11, "files/flags/"..string.lower(tostring(user.country))..".png", 0, 0, 0, tocolor(255,255,255,255), false)
		else
			dxDrawText(tostring(user.country), scdatas.x/2 - scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid) + 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
		end
	else
		dxDrawText("??", scdatas.x/2 - scdatas.width/2 + 10, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid) + 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	end
	
	if team then
		dxDrawText("-"..tostring(team).."-  #FFFFFF"..user.name, scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid) + 3, scdatas.x, scdatas.y, tocolor(r,g,b,255), 1, "default-bold", "left", "top", false, false, true, true) 
	else
		dxDrawText(user.name, scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid) + 3, scdatas.x, scdatas.y, tocolor(r,g,b,255), 1, "default-bold", "left", "top", false, false, true, true) 
	end
	dxDrawText(user.rank, scdatas.x/2 - scdatas.width/2 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.money, scdatas.x/2 - scdatas.width/2 + 350, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.level, scdatas.x/2 - scdatas.width/2 + 460, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.points, scdatas.x/2 - scdatas.width/2 + 520, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.state, scdatas.x/2 - scdatas.width/2 + 600, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.fps, scdatas.x/2 - scdatas.width/2 + 710, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	dxDrawText(user.ping, scdatas.x/2 - scdatas.width/2 + 760, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+ 3, scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
	for i,v in ipairs(scdatas.extendedplayers) do
		if v == user.accountname then
			scdatas.rowid = scdatas.rowid + 1
			if isScoreboardEntryDarker == true then
				dxDrawRectangle ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20*3, tocolor(20,20,20,150) )
			else
				dxDrawRectangle(scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.width, 20*3, tocolor(0,0,0,150))
			end					
			dxDrawLine ( scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 - scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20*3, tocolor(119,119,119,255), 1, false )
			dxDrawLine ( scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x/2 + scdatas.width/2, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid)+20*3, tocolor(119,119,119,255), 1, false )				
			if scdatas.gameMode == 1 then
				dxDrawText("Played [SHOOTER] maps: "..tostring(getElementData(user.player, "SHMaps")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won [SHOOTER] maps: "..tostring(getElementData(user.player, "SHWon")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				dxDrawText("Kilometers driven: "..tostring(getElementData(user.player, "KM")).."km", scdatas.x/2 - scdatas.width/2 + 35 , scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 				
				dxDrawText("Played maps: "..tostring(getElementData(user.player, "PlayedMaps")), scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won maps: "..tostring(getElementData(user.player, "WonMaps")), scdatas.x/2 - scdatas.width/2 + 35 +300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Played time: "..tostring(math.floor(getElementData(user.player, "TimeOnServer")/60)).." Minutes", scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				scdatas.rowid = scdatas.rowid + 2
			elseif scdatas.gameMode == 3 then
				dxDrawText("Played [RACE] maps: "..tostring(getElementData(user.player, "RAMaps")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won [RACE] maps: "..tostring(getElementData(user.player, "RAWon")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				dxDrawText("Top 12 toptimes: "..tostring(getElementData(user.player, "TopTimesRA")), scdatas.x/2 - scdatas.width/2 + 35 , scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)		
				dxDrawText("Played maps: "..tostring(getElementData(user.player, "PlayedMaps")), scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won maps: "..tostring(getElementData(user.player, "WonMaps")), scdatas.x/2 - scdatas.width/2 + 35 +300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Played time: "..tostring(math.floor(getElementData(user.player, "TimeOnServer")/60)).." Minutes", scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				scdatas.rowid = scdatas.rowid + 2
			elseif scdatas.gameMode == 2 then
				dxDrawText("Played [DD] maps: "..tostring(getElementData(user.player, "DDMaps")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won [DD] maps: "..tostring(getElementData(user.player, "DDWon")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				dxDrawText("Kilometers driven: "..tostring(getElementData(user.player, "KM")).."km", scdatas.x/2 - scdatas.width/2 + 35 , scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 				
				dxDrawText("Played maps: "..tostring(getElementData(user.player, "PlayedMaps")), scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won maps: "..tostring(getElementData(user.player, "WonMaps")), scdatas.x/2 - scdatas.width/2 + 35 +300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Played time: "..tostring(math.floor(getElementData(user.player, "TimeOnServer")/60)).." Minutes", scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				scdatas.rowid = scdatas.rowid + 2				
			elseif scdatas.gameMode == 5 then
				dxDrawText("Played [DM] maps: "..tostring(getElementData(user.player, "DMMaps")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won [DM] maps: "..tostring(getElementData(user.player, "DMWon")), scdatas.x/2 - scdatas.width/2 + 35, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				dxDrawText("Top 12 huntertimes: "..tostring(getElementData(user.player, "TopTimes")), scdatas.x/2 - scdatas.width/2 + 35 , scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)		
				dxDrawText("Played maps: "..tostring(getElementData(user.player, "PlayedMaps")), scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * scdatas.rowid), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Won maps: "..tostring(getElementData(user.player, "WonMaps")), scdatas.x/2 - scdatas.width/2 + 35 +300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+1)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true) 
				dxDrawText("Played time: "..tostring(math.floor(getElementData(user.player, "TimeOnServer")/60)).." Minutes", scdatas.x/2 - scdatas.width/2 + 35 + 300, scdatas.y/2 - scdatas.height/2 + 30 + ( 20 * (scdatas.rowid+2)), scdatas.x, scdatas.y, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, true, true)
				scdatas.rowid = scdatas.rowid + 2
			elseif scdatas.gameMode == 4 then
				scdatas.rowid = scdatas.rowid + 2
			end		
			
		end
	end	
	if isScoreboardEntryDarker == false then isScoreboardEntryDarker = true else isScoreboardEntryDarker = false end
end

function togglePlayerExtension(button,state)
	if button == "left" and state == "down" and scdatas.enabled == true then
		for i,v in ipairs(scdatas.extendedplayers) do
			if tostring(v) == getElementData(source, "AccountName") then
				table.remove(scdatas.extendedplayers, i)
				return
			end
		end
		if getElementData(getLocalPlayer(), "gameMode") == 4 then return end
		scdatas.extendedplayers[#scdatas.extendedplayers+1] = tostring(getElementData(source, "AccountName"))
	end
end