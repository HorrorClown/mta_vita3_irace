--[[
Project: vitaCore
File: login-client.lua
Author(s):	Sebihunter
]]--

local passwordHash

function startLogin()
	gLoginGUI = {}
	
	gLoginGUI["edit_name"] = guiCreateEdit ( screenWidth/2+140,screenHeight/2-50, 150, 20, "", false )
	gLoginGUI["edit_password"] = guiCreateEdit ( screenWidth/2+140,screenHeight/2, 150, 20, "", false )
	guiEditSetMasked(gLoginGUI["edit_password"], true)
	
	gLoginGUI["checkbox"] = guiCreateCheckBox ( screenWidth/2+140,screenHeight/2+40, 20, 20, "", false, false )
	
	local vitaXML = xmlLoadFile("vita_settings.xml")
	if vitaXML then
		local vitaNode = xmlFindChild(vitaXML, "saved", 0)
		if xmlNodeGetValue(vitaNode) == "1" then
			vitaNode = xmlFindChild(vitaXML, "username", 0)
			guiSetText(gLoginGUI["edit_name"], xmlNodeGetValue(vitaNode))
			vitaNode = xmlFindChild(vitaXML, "password", 0)
			passwordHash = xmlNodeGetValue(vitaNode)
			guiSetText(gLoginGUI["edit_password"], passwordHash)
			guiCheckBoxSetSelected(gLoginGUI["checkbox"], true)
		end
		xmlUnloadFile(vitaXML)
	end
		
	gLoginGUI["btn_login"] = guiCreateStaticImage ( screenWidth/2+138,screenHeight/2+80, 146, 41, "files/btn_login.png", false )
	setElementData(gLoginGUI["btn_login"], "hoverIMG", "files/btn_loginHover.png")
	setElementData(gLoginGUI["btn_login"], "IMG", "files/btn_login.png")

	addEventHandler ( "onClientGUIClick", gLoginGUI["btn_login"],
	function(button)
		if button  ~= "left" then return false end
		playSound("files/audio/click.mp3")
		loginAttempt()
	end, false )	
	
	addEventHandler( "onClientMouseEnter", gLoginGUI["btn_login"], 
		function(aX, aY)
			setElementData(source, "isHovering", true)
			playSound("files/audio/hover.mp3")
		end
	)	
	addEventHandler("onClientMouseLeave", gLoginGUI["btn_login"], function(aX, aY)
		setElementData(source, "isHovering", false)
	end)			
	
	gLoginGUI["btn_register"] = guiCreateStaticImage ( screenWidth/2+138,screenHeight/2+130, 146, 41, "files/btn_register.png", false )
	setElementData(gLoginGUI["btn_register"], "hoverIMG", "files/btn_registerHover.png")
	setElementData(gLoginGUI["btn_register"], "IMG", "files/btn_register.png")

	addEventHandler ( "onClientGUIClick", gLoginGUI["btn_register"],
	function(button)
		if button  ~= "left" then return false end
		playSound("files/audio/click.mp3")
		if guiGetText(gLoginGUI["edit_name"]) == "" or guiGetText(gLoginGUI["edit_password"]) == "" then addNotification(1, 200, 50, 50, "Provided data is incomplete.") return false end
			
		local vitaXML = xmlLoadFile("vita_settings.xml")
		if vitaXML then
			if guiCheckBoxGetSelected(gLoginGUI["checkbox"]) == true then
				local vitaNode = xmlFindChild(vitaXML, "saved", 0)
				xmlNodeSetValue ( vitaNode, "1")			
				vitaNode = xmlFindChild(vitaXML, "username", 0)
				xmlNodeSetValue ( vitaNode, guiGetText(gLoginGUI["edit_name"]))
				vitaNode = xmlFindChild(vitaXML, "password", 0)
				xmlNodeSetValue ( vitaNode, guiGetText(gLoginGUI["edit_password"]))				
			else
				local vitaNode = xmlFindChild(vitaXML, "saved", 0)
				xmlNodeSetValue ( vitaNode, "0")			
				vitaNode = xmlFindChild(vitaXML, "username", 0)
				xmlNodeSetValue ( vitaNode, "")
				vitaNode = xmlFindChild(vitaXML, "password", 0)
				xmlNodeSetValue ( vitaNode, "")				
			end
			xmlSaveFile(vitaXML)
			xmlUnloadFile(vitaXML)
		end
	
		triggerServerEvent("registerPlayer", getRootElement(), getLocalPlayer(), guiGetText(gLoginGUI["edit_name"]), guiGetText(gLoginGUI["edit_password"]))
	end, false )	
	
	
	addEventHandler( "onClientMouseEnter", gLoginGUI["btn_register"], 
		function(aX, aY)
			setElementData(source, "isHovering", true)
			playSound("files/audio/hover.mp3")
		end
	)	
	addEventHandler("onClientMouseLeave", gLoginGUI["btn_register"], function(aX, aY)
		setElementData(source, "isHovering", false)
	end)			

	showLogin()
end

function showLogin()
	hideGUIComponents("nextMap", "mapdisplay", "spectators", "money", "initiate", "timeleft", "timepassed")
	showChat(false)
	fadeCamera(true)
	showCursor(true)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
	
	for i,v in pairs(gLoginGUI) do
		guiSetVisible(v, true)
	end
	
	vitaBackgroundToggle(true)
	addEventHandler("onClientRender", getRootElement(), renderLogin)
	bindKey ( "enter", "down", pressEnterLogin)
end

local waitForReceive = false

function loginAttempt()
	local editName = guiGetText(gLoginGUI["edit_name"])
	local editPassword = guiGetText(gLoginGUI["edit_password"])
	if editName == "" or editPassword == "" then addNotification(1, 200, 50, 50, "Provided data is incomplete.") return false end

	if waitForReceive then return false end
	waitForReceive = true

	if passwordHash and passwordHash == editPassword then
		triggerServerEvent("accountlogin", root, editName, "", editPassword)
	else
		triggerServerEvent("accountlogin", root, editName, editPassword)
	end
end

addEvent("loginfailed", true)
addEventHandler("loginfailed", root,
	function(text)
		addNotification(1, 200, 50, 50, text)
		waitForReceive = false
	end
)

addEvent("loginsuccess", true)
addEventHandler("loginsuccess", root,
	function(pwhash)
		addNotification(2, 50, 200, 50, "Successfully logged in")

		local vitaXML = xmlLoadFile("vita_settings.xml")
		if vitaXML then
			if guiCheckBoxGetSelected(gLoginGUI["checkbox"]) == true then
				local vitaNode = xmlFindChild(vitaXML, "saved", 0)
				xmlNodeSetValue ( vitaNode, "1")
				vitaNode = xmlFindChild(vitaXML, "username", 0)
				xmlNodeSetValue ( vitaNode, guiGetText(gLoginGUI["edit_name"]))
				vitaNode = xmlFindChild(vitaXML, "password", 0)
				xmlNodeSetValue ( vitaNode, pwhash)
			else
				local vitaNode = xmlFindChild(vitaXML, "saved", 0)
				xmlNodeSetValue ( vitaNode, "0")
				vitaNode = xmlFindChild(vitaXML, "username", 0)
				xmlNodeSetValue ( vitaNode, "")
				vitaNode = xmlFindChild(vitaXML, "password", 0)
				xmlNodeSetValue ( vitaNode, "")
			end
			xmlSaveFile(vitaXML)
			xmlUnloadFile(vitaXML)
		end

		initSettings()
		showChat(true)
		--showCursor(false)
		--vitaBackgroundToggle(false)
		bindKey ( "m", "down", toggleVitaMusic )
		unbindKey ( "enter", "down", pressEnterLogin)


		for _,v in pairs(gLoginGUI) do
			--guiSetVisible(v, false)
			destroyElement(v)
		end
		removeEventHandler("onClientRender", getRootElement(), renderLogin)
	end
)

function pressEnterLogin(key, keyState)
	if keyState == "down" then
		loginAttempt()
	end
end



local loginText = [[Welcome to the official Vita Race server!
By playing on our server you accept the server rules.

___________________LATEST UPDATE (24.01.2016)___________________
NEW: Disabled certain vehicles when there are less than 6 players in SUMO
FIX: Weapon names instead of IDs are listed in the killist
FIX: Resolved displaying issues related to the mapshop
TWEAK: Rankingboard in SUMO is now colored like the nametags
TWEAK: Added a cooldown for map-buying and redo
TWEAK: Removed unused ranks from the teamlist
TWEAK: Edited some texts (new URLs for the forum)
]]


function renderLogin()
	--dxDrawRectangle( 0,0, screenWidth, screenHeight, tocolor ( 0, 0, 0, 200 ) )
	dxDrawImage ( screenWidth/2-512, screenHeight/2-256, 1024, 512, "files/vita_login.png" , 0, 0, 0, tocolor(255,255,255,255), false )

	dxDrawText(loginText, screenWidth/2-342+1,screenHeight/2-50+1,screenWidth, screenHeight, tocolor(0,0,0,150), 1, "default-bold", "left", "top", false, false, false, true)
	dxDrawText(loginText, screenWidth/2-342,screenHeight/2-50,screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, false, true)
	
	dxDrawText("Hello "..getPlayerName(getLocalPlayer()).."\nPlease fill in your account data.", screenWidth/2+140+1,screenHeight/2-140+1,screenWidth, screenHeight, tocolor(0,0,0,150), 1, "default-bold", "left", "top", false, false, false, true)
	dxDrawText("Hello "..getPlayerName(getLocalPlayer()).."\nPlease fill in your account data.", screenWidth/2+140,screenHeight/2-140,screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, false, true)
	
	dxDrawText("Username:", screenWidth/2+140+1,screenHeight/2-70+1,screenWidth, screenHeight, tocolor(0,0,0,150), 1, "default-bold", "left", "top", false, false, false, true)
	dxDrawText("Username:", screenWidth/2+140,screenHeight/2-70,screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, false, true)	
	
	dxDrawText("Password:", screenWidth/2+140+1,screenHeight/2-20+1,screenWidth, screenHeight, tocolor(0,0,0,150), 1, "default-bold", "left", "top", false, false, false, true)
	dxDrawText("Password:", screenWidth/2+140,screenHeight/2-20,screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, false, true)	
	
	dxDrawText("Remember data?", screenWidth/2+140+1+21,screenHeight/2+42+1,screenWidth, screenHeight, tocolor(0,0,0,150), 1, "default-bold", "left", "top", false, false, false, true)
	dxDrawText("Remember data?", screenWidth/2+140+21,screenHeight/2+42,screenWidth, screenHeight, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, false, false, true)	
	
	dxDrawText("� Vita 2011-2016", screenWidth/2+130+1,screenHeight/2+200+1,screenWidth/2+361+1, screenHeight, tocolor(0,0,0,150), 1, "default", "center", "top", false, false, false, true)
	dxDrawText("� Vita 2011-2016", screenWidth/2+130,screenHeight/2+200,screenWidth/2+361, screenHeight, tocolor(255,255,255,255), 1, "default", "center", "top", false, false, false, true)		
	
	dxDrawImage(screenWidth/2+138,screenHeight/2+130, 146, 41, getElementData(gLoginGUI["btn_register"], "IMG"), 0,0,0, tocolor(255,255,255,255), true)
	if getElementData(gLoginGUI["btn_register"], "isHovering") == true then
		dxDrawImage(screenWidth/2+138,screenHeight/2+130, 146, 41, getElementData(gLoginGUI["btn_register"], "hoverIMG"), 0,0,0, tocolor(255,255,255,255), true)
	end
	
	dxDrawImage(screenWidth/2+138,screenHeight/2+80, 146, 41, getElementData(gLoginGUI["btn_login"], "IMG"), 0,0,0, tocolor(255,255,255,255), true)
	if getElementData(gLoginGUI["btn_login"], "isHovering") == true then
		dxDrawImage(screenWidth/2+138,screenHeight/2+80, 146, 41, getElementData(gLoginGUI["btn_login"], "hoverIMG"), 0,0,0, tocolor(255,255,255,255), true)
	end
	
	if screenWidth < 1024 or screenHeight < 786 then
		dxDrawText("WARNING: You are running on a resolution lower than 1024x786.\nSome GUI may be placed or appear incorrectly.", 1, screenHeight-99, screenWidth, screenHeight, tocolor(0,0,0,100), 0.5, ms_bold, "center",  "top", false, false, true)
		dxDrawText("WARNING: You are running on a resolution lower than 1024x786.\nSome GUI may be placed or appear incorrectly.", 0, screenHeight-100, screenWidth, screenHeight, tocolor(255,0,0,255), 0.5, ms_bold, "center", "top", false, false, true)
	end
end