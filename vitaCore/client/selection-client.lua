--[[
Project: vitaCore
File: selection-client.lua
Author(s):	Sebihunter
]]--

--Race Selection--

function startSelection(modes)
	gRaceModes = modes
	gSelectionGUI = {}
	local moveUp = 1
	local moveDown = 1		
	
	local totalHeight = table.size(gRaceModes)*200

	local heightFix = 1 --Use this because i = 1, 2, 5 | Not all gamemodes active!
	for i,v in pairs(modes) do
		heightFix = heightFix + 1
		gSelectionGUI[i] = {}
		gSelectionGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2-totalHeight/2+100*(heightFix-1), 738, 100, v.img, false )
		--[[if i == 1 then
			gSelectionGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2, 738, 100, v.img, false )
		elseif i/2 == math.floor(i/2) then
			gSelectionGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2+100*moveUp, 738, 100, v.img, false )
			moveUp = moveUp + 1
		else
			gSelectionGUI[i].img = guiCreateStaticImage (  screenWidth/2-369, screenHeight/2-100*moveDown, 738, 100, v.img, false )
			moveDown = moveDown + 1
		end]]
		setElementData(gSelectionGUI[i].img, "img", v.img)
		setElementData(gSelectionGUI[i].img, "imghover", v.imghover)
		setElementData(gSelectionGUI[i].img, "isHovering", false)
		setElementData(gSelectionGUI[i].img, "joinfunc", v.joinfunc)
		
		for _, v2 in ipairs(getElementsByType(tostring(v.element))) do
			gRaceModes[i].realelement = v2
			break
		end
		
		addEventHandler( "onClientMouseEnter", gSelectionGUI[i].img, 
			function(aX, aY)
				setElementData(source, "isHovering", true)
				playSound("files/audio/hover.mp3")
			end
		)	
		addEventHandler("onClientMouseLeave", gSelectionGUI[i].img, function(aX, aY)
			setElementData(source, "isHovering", false)
		end)		
		
		addEventHandler ( "onClientGUIClick", gSelectionGUI[i].img,
		function(button)
			if button  ~= "left" then return false end
			triggerServerEvent(getElementData(source, "joinfunc"), getRootElement(), getLocalPlayer())
			playSound("files/audio/click.mp3")
		end, false )
	end
	
	for i,v in pairs(gSelectionGUI) do
		--guiSetVisible(gSelectionGUI[i].img, false)
	end	

	if getElementData(getLocalPlayer(), "language") ~= 1 then
		showSelection()
	else
		showLangSelect()
	end
end
addEvent("startSelection", true)
addEventHandler("startSelection", getRootElement(), startSelection)

function showSelection()
	hideGUIComponents("nextMap", "mapdisplay", "money", "initiate", "timeleft", "timepassed")
	showChat(false)
	fadeCamera(true)
	showCursor(true)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
	setTime(12,0)
	
	for i,v in pairs(gSelectionGUI) do
		guiSetVisible(gSelectionGUI[i].img, true)	
	end
	
	vitaBackgroundToggle(true)
	addEventHandler("onClientRender", getRootElement(), renderSelection)
end
addEvent("showSelection", true)
addEventHandler("showSelection", getRootElement(), showSelection)

function renderSelection()
	--dxDrawRectangle( 0,0, screenWidth, screenHeight, tocolor ( 0, 0, 0, 200 ) )
	dxDrawText("Vita3 Mode",(screenWidth*0.025),screenHeight-(screenHeight*0.95), screenWidth, screenHeight, tocolor(255,255,255,255), 1,ms)
	dxDrawLine((screenWidth*0.025), screenHeight-(screenHeight*0.87), (screenWidth*0.32), screenHeight-(screenHeight*0.87), tocolor(255,255,255,255))
	dxDrawText("Select your mode...",screenWidth*0.2,screenHeight-(screenHeight*0.87), screenWidth, screenHeight, tocolor(255,255,255,255), 0.4,ms)
	dxDrawText("Total players: "..#getElementsByType("player"),(screenWidth*0.025),((screenHeight*0.92))+(screenWidth/200), screenWidth, screenHeight, tocolor(255,255,255,255), 0.6,ms, "left", "top", false, false, false, true)

	
	if screenWidth < 1024 or screenHeight < 780 then
		dxDrawText("WARNING: You are running on a low resolution.\nSome GUI may be placed or appear incorrectly.", 1, screenHeight-99, screenWidth, screenHeight, tocolor(0,0,0,100), 0.5, ms_bold, "center",  "top", false, false, true)
		dxDrawText("WARNING: You are running on a low resolution.\nSome GUI may be placed or appear incorrectly.", 0, screenHeight-100, screenWidth, screenHeight, tocolor(255,0,0,255), 0.5, ms_bold, "center", "top", false, false, true)
	end
	
	for i,v in pairs(gSelectionGUI) do
		local x, y = guiGetPosition(gSelectionGUI[i].img, false)
		local w, h = guiGetSize(gSelectionGUI[i].img, false)	
		dxDrawImage ( x, y, w, h, getElementData(gSelectionGUI[i].img, "img") , 0, 0, 0, white, true )
		if getElementData(gSelectionGUI[i].img, "isHovering") == true then
			dxDrawImage ( x, y, w, h, getElementData(gSelectionGUI[i].img, "imghover") , 0, 0, 0, white, true )
		end
		if gRaceModes[i].maxplayers ~= 0 then
			if i == 4 then
				if getElementData(gRaceModes[i].realelement, "mapname") == false or getElementData(gRaceModes[i].realelement, "mapname") == "loading..." then
					dxDrawText("Mode: None", x+1, y+6, x+w-9, y+h+1, tocolor(0,0,0,100),1, "default-bold", "right",  "top", false, false, true)
					dxDrawText("Mode: None", x, y+5, x+w-10, y+h, tocolor(255,255,255,255),1, "default-bold", "right", "top", false, false, true)			
				else
					dxDrawText("Mode:"..tostring(getElementData(gRaceModes[i].realelement, "mapname")), x+1, y+6, x+w-9, y+h+1, tocolor(0,0,0,100),1, "default-bold", "right",  "top", false, false, true)
					dxDrawText("Mode: "..tostring(getElementData(gRaceModes[i].realelement, "mapname")), x, y+5, x+w-10, y+h, tocolor(255,255,255,255),1, "default-bold", "right", "top", false, false, true)
				end		
			elseif i == 6 then
					
			else
				if getElementData(gRaceModes[i].realelement, "mapname") == false or getElementData(gRaceModes[i].realelement, "mapname") == "loading..." then
					dxDrawText("Map: None", x+1, y+6, x+w-9, y+h+1, tocolor(0,0,0,100),1, "default-bold", "right",  "top", false, false, true)
					dxDrawText("Map: None", x, y+5, x+w-10, y+h, tocolor(255,255,255,255),1, "default-bold", "right", "top", false, false, true)			
				else
					dxDrawText("Map "..tostring(getElementData(gRaceModes[i].realelement, "mapname")), x+1, y+6, x+w-9, y+h+1, tocolor(0,0,0,100),1, "default-bold", "right",  "top", false, false, true)
					dxDrawText("Map: "..tostring(getElementData(gRaceModes[i].realelement, "mapname")), x, y+5, x+w-10, y+h, tocolor(255,255,255,255),1, "default-bold", "right", "top", false, false, true)
				end
			end
			dxDrawText("Players: "..#getGamemodePlayers(i).."/"..gRaceModes[i].maxplayers, x+1, y+18, x+w-9, y+h+1, tocolor(0,0,0,100),1, "default-bold", "right",  "top", false, false, true)
			dxDrawText("Players: "..#getGamemodePlayers(i).."/"..gRaceModes[i].maxplayers, x, y+17, x+w-10, y+h, tocolor(255,255,255,255),1, "default-bold", "right", "top", false, false, true)		
		else

		end		
	end	
end

function hideSelection()
	showChat(true)
	showCursor(false)
	for i,v in pairs(gSelectionGUI) do
		guiSetVisible(gSelectionGUI[i].img, false)	
	end
	vitaBackgroundToggle(false)
	removeEventHandler("onClientRender", getRootElement(), renderSelection)
	
	if isRPSelection == true then
		stopSelectionRP()
	end
end
addEvent("hideSelection", true)
addEventHandler("hideSelection", getRootElement(), hideSelection)


--RolePlay Selection--

local isRPSelection = false

function startSelectionRP()
	showChat(false)
	fadeCamera(true)
	showCursor(true)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
	isRPSelection = true
	
	gYesNoRP = {}
	gYesNoRP[1] = guiCreateStaticImage ( screenWidth/2-433, screenHeight/2+200, 240, 60, "files/selection/rpYes.png", false )
	setElementData(gYesNoRP[1], "imghover", "files/selection/rpYesHover.png")
	gYesNoRP[2] = guiCreateStaticImage ( screenWidth/2-190, screenHeight/2+200, 240, 60, "files/selection/rpNo.png", false )
	setElementData(gYesNoRP[2], "imghover", "files/selection/rpNoHover.png")
	for i,v in pairs(gYesNoRP) do
		addEventHandler( "onClientMouseEnter", v, 
			function(aX, aY)
				setElementData(source, "isHovering", true)
				--guiSetAlpha(source, 50)
				playSound("files/audio/hover.mp3")
			end
		)	
		addEventHandler("onClientMouseLeave", v, function(aX, aY)
			setElementData(source, "isHovering", false)
			--guiSetAlpha(source, 100)
		end)	
			
	end
	vitaBackgroundToggle(true)
	addEventHandler("onClientRender", getRootElement(), renderSelectionRP)
	
	addEventHandler ( "onClientGUIClick", gYesNoRP[1], function(button)
		if button  ~= "left" then return false end
		playSound("files/audio/click.mp3")	
		triggerServerEvent("redirectRP", getRootElement(), getLocalPlayer())
	end )
	
	addEventHandler ( "onClientGUIClick", gYesNoRP[2], function(button)
		if button  ~= "left" then return false end
		playSound("files/audio/click.mp3")	
		stopSelectionRP()
		
		if getPlayerGameMode(getLocalPlayer()) == 0 then
			showSelection()
		end
	end )	
end
addEvent("startSelectionRP", true)
addEventHandler("startSelectionRP", getRootElement(), startSelectionRP)

function renderSelectionRP()
	dxDrawRectangle( 0,0, screenWidth, screenHeight, tocolor ( 0, 0, 0, 200 ) )
	
	dxDrawImage(screenWidth/2-512, screenHeight/2-512, 1024, 1024, "files/selection/rpBG.png")
	for i,v in pairs(gYesNoRP) do
		if getElementData(gYesNoRP[i], "isHovering") == true then
			local x, y = guiGetPosition(gYesNoRP[i], false)
			local w, h = guiGetSize(gYesNoRP[i], false)
			dxDrawImage ( x, y, w, h, getElementData(gYesNoRP[i], "imghover") , 0, 0, 0, white, true )
		end
	end		
end

function stopSelectionRP()
	isRPSelection = false
	for i,v in pairs(gYesNoRP) do
		destroyElement(v)
	end
	gYesNoRP = false
	showChat(true)
	showCursor(false)
	for i,v in pairs(gSelectionGUI) do
		guiSetVisible(gSelectionGUI[i].img, false)	
	end
	removeEventHandler("onClientRender", getRootElement(), renderSelectionRP)
end
addEvent("stopSelectionRP", true)
addEventHandler("stopSelectionRP", getRootElement(), stopSelectionRP)