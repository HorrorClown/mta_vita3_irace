--[[
Project: vitaCore - vitaWave
File: donator.lua
Author(s):	Sebihunter
]]--

winsoundNames = {
	[0] = { name = "None" },	
	[1] = { name = "Play Hard" },	
	[2] = { name = "What's going on?" },
	[3] = { name = "Me gusta" },
	[4] = { name = "Bazaar" },
	[5] = { name = "Feel This Moment" },
	[6] = { name = "Ready 2 Go" },
	[7] = { name = "Hello" },
	[8] = { name = "Every Sperm Is Sacred" },
	[9] = { name = "Rosana" },
	[10] = { name = "Tricker" },
	[11] = { name = "I Can Only Imagine" },
	[12] = { name = "500 Miles" },
	[13] = { name = "Won't stop rocking the beat" },
	[14] = { name = "Cantina" },
	[15] = { name = "Champion" },
	[16] = { name = "Our Own Way" },
	[17] = { name = "A wonderful time" },
	[18] = { name = "Killin' It" },
	[19] = { name = "I Love It" },
	[20] = { name = "Sherlock Holmes Dubstep" },
	[21] = { name = "Atemlos"},
	[22] = { name = "Wonderful Life" }
}

function previewWinsound(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( g_donatorgui["tabDonatorList"] )
		if dxGridListGetItemData (g_donatorgui["tabDonatorList"], row ) then
			playSound("files/winsounds/"..dxGridListGetItemData(g_donatorgui["tabDonatorList"], row )..".mp3")
		end
	end
end

function clickOnWinsound(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( g_donatorgui["tabDonatorList"] )
		if dxGridListGetItemData (g_donatorgui["tabDonatorList"], row) then
			setWinsound("winsound", dxGridListGetItemData(g_donatorgui["tabDonatorList"], row))
		end
	end
end

function setWinsound(commandName, number)
	number = math.floor(tonumber(number))
	if number >= 0 and number <= #winsoundNames then
		if getElementData(getLocalPlayer(), "isDonator") == true then
			setElementData(getLocalPlayer(), "useWinsound", number)
			updateSettings("useWinsound", tostring(number))
			addNotification(1, 0, 200, 0, "New winsound has been set.")
		end
	end
end
addCommandHandler ( "winsound", setWinsound )


function toggleRainbowColor ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(), "rainbowColor") == true then
			setElementData(getLocalPlayer(), "rainbowColor", false)
			updateSettings("rainbowColor", "0")
			addNotification(2, 153, 102, 150, "Rainbow color turned off.")
			setElementData(g_donatorgui["toggle_rainbowcolor"], "text", "Rainbow Color: Off")
		else
			updateSettings("rainbowColor", "1")
			setElementData(getLocalPlayer(), "rainbowColor", true)
			setElementData(g_donatorgui["toggle_rainbowcolor"], "text", "Rainbow Color: On")
			addNotification(2, 153, 102, 150, "Rainbow color turned on.")
			if getElementData(getLocalPlayer(), "discoColor") == true then
				setElementData(getLocalPlayer(), "discoColor", false)
				setElementData(g_donatorgui["toggle_discocolor"], "text", "Disco Color: Off")
				updateSettings("discoColor", "0")
			end
		end
	end
end

function toggleDisoColor ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(), "discoColor") == true then
			setElementData(getLocalPlayer(), "discoColor", false)
			updateSettings("discoColor", "0")
			addNotification(2, 153, 102, 150, "Disco color turned off.")
			setElementData(g_donatorgui["toggle_discocolor"], "text", "Disco Color: Off")
		else
			updateSettings("discoColor", "1")
			setElementData(getLocalPlayer(), "discoColor", true)
			setElementData(g_donatorgui["toggle_discocolor"], "text", "Disco Color: On")
			addNotification(2, 153, 102, 150, "Disco color turned on.")
			if getElementData(getLocalPlayer(), "rainbowColor") == true then
				setElementData(getLocalPlayer(), "rainbowColor", false)
				setElementData(g_donatorgui["toggle_rainbowcolor"], "text", "Rainbow Color: Off")
				updateSettings("rainbowColor", "0")
			end
		end
	end
end

g_donatorgui = {}
g_donatorgui["tabDonatorList"] = dxCreateGridList(screenWidth/2-392,screenHeight/2-215,250,400)
g_donatorgui["set_winsound"] = dxCreateButton(screenWidth/2-392,screenHeight/2+190,250,24,"Set Winsound",false)
addEventHandler ( "onClientDXClick", g_donatorgui["set_winsound"], clickOnWinsound, false )
g_donatorgui["preview_winsound"] = dxCreateButton(screenWidth/2-392,screenHeight/2+219,250,24,"Preview Winsound",false)
addEventHandler ( "onClientDXClick", g_donatorgui["preview_winsound"], previewWinsound, false )

g_donatorgui["toggle_discocolor"] = dxCreateButton(screenWidth/2-137,screenHeight/2+45,250,24,"Disco Color: Off",false)
addEventHandler ( "onClientDXClick", g_donatorgui["toggle_discocolor"], toggleDisoColor, false ) 

g_donatorgui["toggle_rainbowcolor"] = dxCreateButton(screenWidth/2-137,screenHeight/2+75,250,24,"Rainbow Color: Off",false)
addEventHandler ( "onClientDXClick", g_donatorgui["toggle_rainbowcolor"], toggleRainbowColor, false ) 

donatorWinmsg = guiCreateEdit ( screenWidth/2-137,screenHeight/2-40,250,24, "Ohai Thar", false )	
guiSetVisible(donatorWinmsg, false)
donatorStatus = guiCreateEdit ( screenWidth/2-137,screenHeight/2+10,250,24, "Ohai Thar", false )	
guiSetVisible(donatorStatus, false)
donatorBlank = guiCreateLabel ( 0,0,0,0,"",false )
guiSetVisible(donatorBlank, false)	


for num = 0, #winsoundNames do
	local row = dxGridListAddRow ( g_donatorgui["tabDonatorList"],  winsoundNames[num]["name"].." ("..num..")",  tostring(num))
end	


for i, v in pairs(g_donatorgui) do
	dxSetVisible(v, false)
end

function waveDrawDonator()
	if getElementData(getLocalPlayer(), "isDonator") == true then
		dxDrawShadowedText("Available Winsounds",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("In order to use a Winsound just select it\nin the list and press the button.\n\nYou can also use /winsound [ID]\nto choose your winsound while driving.\n\nIf you can't find the winsound you're\nlooking for please contact us so we\ncan add it for you.",screenWidth/2-137,screenHeight/2-215, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		
		dxDrawShadowedText("Custom Wintext ('none' to disable)",screenWidth/2-137,screenHeight/2-60, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		
		if string.len(removeColorCoding(guiGetText(donatorStatus))) <= 15 then
			dxDrawShadowedText("Nametag Status ('none' to disable)",screenWidth/2-137,screenHeight/2-12, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		else
			dxDrawShadowedText("Nametag Status (Status too long - max. 15 letters)",screenWidth/2-137,screenHeight/2-12, screenWidth, screenHeight, tocolor(255,0,0,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		end
		for i, v in pairs(g_donatorgui) do
			dxSetVisible(v, true)
		end
		if guiGetVisible(donatorWinmsg) ~= true then
			guiSetVisible(donatorWinmsg, true)
			guiSetVisible(donatorStatus, true)
		end
	else
		dxDrawShadowedText([[This is the Vita3 donator panel!
		
		Please note that you can only visit this panel by
		becoming a donator of our community.
		Donating is very easy and helps the administration
		to keep up all the Vita services.
		
		Donator features (1 Euro per 6 days):
		-Donator rank on forums, Vita3 and Teamspeak
		-4 times free mapbuying and redoing per day
		-Double money per map
		-Instant and free access to "Memes"
		-Instant and free access to backlights
		-Disco color
		-Rainbow color
		-Winsound
		-Custom wintext
		-Custom nametag status
		-20.000 Vero per each Euro donated
		
		For more information on donations visit:
		race.vita-online.eu]],0,0, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "center", "center", false, false, false, true)
	end
end

function checkIfNotClickedOnEditDonator ( button, state, sx, sy, worldX, worldY, worldZ, clickedElement )
	if waveSelected == 7 and state == "down" and showUserGui == true then
		local x,y  = guiGetPosition(donatorWinmsg, false)
		local w, h = guiGetSize(donatorWinmsg, false)
		local x1,y1  = guiGetPosition(donatorStatus, false)
		local w1, h1 = guiGetSize(donatorStatus, false)
		if not (sx >= x and sx <= x+w and sy >= y and sy <= y+h) and not (sx >= x1 and sx <= x1+w1 and sy >= y1 and sy <= y1+h1) then guiBringToFront ( donatorBlank ) end
	end
end
addEventHandler ( "onClientClick", getRootElement(), checkIfNotClickedOnEditDonator )