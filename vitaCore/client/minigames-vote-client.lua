--[[
Project: vitaCore
File: minigames-vote-client.lua
Author(s):	Sebihunter
]]--

local leftVoteTimer = "30"
minigamesVoteShown = false
voteWonMode = 0

function startMinigamesVote(modes, timer)
	gMinigameModes = modes
	leftVoteTimer = timer
	voteWonMode = 0
	gMinigamesVoteGUI = {}
	setElementData(getLocalPlayer(), "vitaVoteMi", 0)
	local moveUp = 1
	local moveDown = 1		
	
	for i,v in ipairs(modes) do
		gMinigamesVoteGUI[i] = {}
		if i == 1 then
			gMinigamesVoteGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2, 738, 50, v.img, false )
		elseif i/2 == math.floor(i/2) then
			gMinigamesVoteGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2+52*moveUp, 738, 50, v.img, false )
			moveUp = moveUp + 1
		else
			gMinigamesVoteGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2-52*moveDown, 738, 50, v.img, false )
			moveDown = moveDown + 1
		end
		setElementData(gMinigamesVoteGUI[i].img, "img", v.img)
		setElementData(gMinigamesVoteGUI[i].img, "imghover", v.imghover)
		setElementData(gMinigamesVoteGUI[i].img, "isHovering", false)
		setElementData(gMinigamesVoteGUI[i].img, "id", i)
		addEventHandler( "onClientMouseEnter", gMinigamesVoteGUI[i].img, 
			function(aX, aY)
				setElementData(source, "isHovering", true)
				playSound("files/audio/hover.mp3")
			end
		)	
		addEventHandler("onClientMouseLeave", gMinigamesVoteGUI[i].img, function(aX, aY)
			setElementData(source, "isHovering", false)
		end)		
		
		addEventHandler ( "onClientGUIClick", gMinigamesVoteGUI[i].img,
		function(button)
			if button  ~= "left" then return false end
			setElementData(getLocalPlayer(), "vitaVoteMi", getElementData(source, "id"))
			playSound("files/audio/click.mp3")
		end, false )
	end
	
	for i,v in pairs(gMinigamesVoteGUI) do
		guiSetVisible(gMinigamesVoteGUI[i].img, false)	
	end	
	
 	
	showMinigamesVote()
end
addEvent("startMinigamesVote", true)
addEventHandler("startMinigamesVote", getRootElement(), startMinigamesVote)

addEvent("setLeftTimeVote", true)
addEventHandler("setLeftTimeVote", getRootElement(), function(theTime) leftVoteTimer = tostring(theTime) end)

addEvent("voteWonMode", true)
addEventHandler("voteWonMode", getRootElement(), function(theTime) voteWonMode = theTime end)

function showMinigamesVote()
	if minigamesVoteShown then return false end
	minigamesVoteShown = true
	hideGUIComponents("nextMap", "mapdisplay", "spectators", "money", "initiate", "timeleft", "timepassed")
	showChat(false)
	fadeCamera(true)
	showCursor(true)
	setTime(12,0)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
	
	for i,v in pairs(gMinigamesVoteGUI) do
		guiSetVisible(gMinigamesVoteGUI[i].img, true)	
	end
	
	vitaBackgroundToggle(true)
	addEventHandler("onClientRender", getRootElement(), renderMinigamesVote)
end
addEvent("showMinigamesVote", true)
addEventHandler("showMinigamesVote", getRootElement(), showMinigamesVote)

function renderMinigamesVote()
	--dxDrawRectangle( 0,0, screenWidth, screenHeight, tocolor ( 0, 0, 0, 200 ) )
	dxDrawText("Minigames",(screenWidth*0.025),screenHeight-(screenHeight*0.95), screenWidth, screenHeight, tocolor(255,255,255,255), 1,ms)
	dxDrawLine((screenWidth*0.025), screenHeight-(screenHeight*0.87), (screenWidth*0.32), screenHeight-(screenHeight*0.87), tocolor(255,255,255,255))
	dxDrawText("Vote your mode...",screenWidth*0.2,screenHeight-(screenHeight*0.87), screenWidth, screenHeight, tocolor(255,255,255,255), 0.4,ms)
	dxDrawImage(screenWidth*0.05-(screenWidth/40),((screenHeight*0.92))+(screenWidth/200), screenWidth/50, screenWidth/50, "files/clock.png")
	dxDrawText(tostring(leftVoteTimer),screenWidth*0.05,(screenHeight*0.92)+3, screenWidth, screenHeight, tocolor(255,255,255,255), 0.5,ms)	
	
	if voteWonMode ~= 0 then
		for i,v in ipairs(gMinigamesVoteGUI) do
			destroyElement(v.img)
		end	
		gMinigamesVoteGUI = {}
		
		dxDrawImage ( screenWidth/2-369, screenHeight/2, 738, 50, gMinigameModes[voteWonMode].img, 0, 0, 0, white, true )
	end
	
	for i,v in pairs(gMinigamesVoteGUI) do
		local x, y = guiGetPosition(gMinigamesVoteGUI[i].img, false)
		local w, h = guiGetSize(gMinigamesVoteGUI[i].img, false)	
		dxDrawImage ( x, y, w, h, getElementData(gMinigamesVoteGUI[i].img, "img") , 0, 0, 0, white, true )
		if getElementData(gMinigamesVoteGUI[i].img, "isHovering") == true then
			dxDrawImage ( x, y, w, h, getElementData(gMinigamesVoteGUI[i].img, "imghover") , 0, 0, 0, white, true )
		end
		if getElementData(getLocalPlayer(), "vitaVoteMi") == i then
			dxDrawImage ( x, y, w, h, "files/minigames_vote/games_chosen.png" , 0, 0, 0, white, true )
		end
	end	
end

function hideMinigamesVote()
	if not minigamesVoteShown == true then return end
	minigamesVoteShown = false
	showChat(true)
	showCursor(false)
	for i,v in pairs(gMinigamesVoteGUI) do
		guiSetVisible(gMinigamesVoteGUI[i].img, false)	
	end
	vitaBackgroundToggle(false)
	removeEventHandler("onClientRender", getRootElement(), renderMinigamesVote)
	
	for i,v in ipairs(gMinigamesVoteGUI) do
		destroyElement(v.img)
	end
	gMinigamesVoteGUI = {}
end
addEvent("hideMinigamesVote", true)
addEventHandler("hideMinigamesVote", getRootElement(), hideMinigamesVote)