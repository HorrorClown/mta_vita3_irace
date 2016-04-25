--[[
Project: vitaCore - vitaWave
File: shop.lua
Author(s):	Sebihunter
			arc_
]]--

gWaveWheels = {
	1025,
	1073,
	1074,
	1075,
	1076,
	1077,
	1078,
	1079,
	1080,
	1081,
	1082,
	1083,
	1084,
	1085,
	1096,
	1097,
	1098
}

function Flip ( button )
	if button == "left" then
		if getPlayerMoney() >= 4000 then
			if getPlayerGameMode(getLocalPlayer()) == 5 or getPlayerGameMode(getLocalPlayer()) == 3 then
				if getPedOccupiedVehicle(getLocalPlayer()) then
					setPlayerMoney( getPlayerMoney() - 4000 )
					addNotification(2, 0, 200, 0, "Vehicle has been flipped.")
					local rz, ry, rx = getElementRotation ( getPedOccupiedVehicle ( getLocalPlayer() ), "ZYX" )
					setElementRotation ( getPedOccupiedVehicle ( getLocalPlayer() ), 0, ry, rx, "ZYX")
				else
					addNotification(1, 200, 50, 50, "Not in a vehicle.")
				end
			else
				addNotification(1, 200, 50, 50, "Not available in this gamemode.")
			end
		else
			addNotification(1, 200, 50, 50, "Not enough money.")
		end
	end
end	

function Flip ( button )
	if button == "left" then
		if getPlayerMoney() >= 4000 then
			if getPlayerGameMode(getLocalPlayer()) == 5 or getPlayerGameMode(getLocalPlayer()) == 3 then
				if getPedOccupiedVehicle(getLocalPlayer()) then
					setPlayerMoney( getPlayerMoney() - 4000 )
					addNotification(2, 0, 200, 0, "Vehicle has been flipped.")
					local rz, ry, rx = getElementRotation ( getPedOccupiedVehicle ( getLocalPlayer() ), "ZYX" )
					setElementRotation ( getPedOccupiedVehicle ( getLocalPlayer() ), 0, ry, rx, "ZYX")
				else
					addNotification(1, 200, 50, 50, "Not in a vehicle.")
				end
			else
				addNotification(1, 200, 50, 50, "Not available in this gamemode.")
			end
		else
			addNotification(1, 200, 50, 50, "Not enough money.")
		end
	end
end	

function flipfunc()
	Flip("left")
end
addCommandHandler ( "flip", flipfunc )

function Repair ( button )
	if button == "left" then
		if getPlayerMoney() >= 3000 then
			if getPlayerGameMode(getLocalPlayer()) == 5 or getPlayerGameMode(getLocalPlayer()) == 3 then
				if getPedOccupiedVehicle(getLocalPlayer()) then
					setPlayerMoney( getPlayerMoney() - 3000 )
					addNotification(2, 0, 200, 0, "Vehicle has been repaired.")
					fixVehicle ( getPedOccupiedVehicle ( getLocalPlayer() ) )
				else
					addNotification(1, 200, 50, 50, "Not in a vehicle.")
				end
			else
				addNotification(1, 200, 50, 50, "Not available in this gamemode.")
			end
		else
			addNotification(1, 200, 50, 50, "Not enough money.")
		end
	end
end

function repairfunc()
	Repair( "left" )
end
addCommandHandler ( "repair", repairfunc )

function buyColorPicker()
	if getPlayerMoney() >= 10000 then
		local checkBoxSelected = false
		local r,g,b = colorPickersTable[1]:getPickedColor()
		
		if guiCheckBoxGetSelected ( g_customization1g["check_color1"]) == true then
			checkBoxSelected = true
			setElementData(getLocalPlayer(), "r1", tonumber(r))
			setElementData(getLocalPlayer(), "g1", tonumber(g))
			setElementData(getLocalPlayer(), "b1", tonumber(b))
		end
	
		if guiCheckBoxGetSelected ( g_customization1g["check_color2"]) == true then
			checkBoxSelected = true
			setElementData(getLocalPlayer(), "r2", tonumber(r))
			setElementData(getLocalPlayer(), "g2", tonumber(g))
			setElementData(getLocalPlayer(), "b2", tonumber(b))
		end
	
		if guiCheckBoxGetSelected ( g_customization1g["check_colorl"]) == true then
			checkBoxSelected = true
			setElementData(getLocalPlayer(), "rl", tonumber(r))
			setElementData(getLocalPlayer(), "gl", tonumber(g))
			setElementData(getLocalPlayer(), "bl", tonumber(b))
		end	
	
		if checkBoxSelected == false then
			addNotification(1, 200, 50, 50, "No checkbox selected.")
			return
		end
		addNotification(2, 0, 200, 0, "Color successfully changed.")
		setPlayerMoney( getPlayerMoney() - 10000 )
		triggerServerEvent ( "addPlayerArchivement", getRootElement(), getLocalPlayer(), 62 ) 
	else
		addNotification(1, 200, 50, 50, "Not enough money.")
	end
end

function buySkin()
	if getPlayerMoney() >= 10000 then
		setElementModel(getLocalPlayer(), tonumber(shopSelectedSkin))
		setElementData(getLocalPlayer(), "Skin", tonumber(shopSelectedSkin))
		addNotification(2, 0, 200, 0, "Skin successfully changed.")
		triggerServerEvent ( "addPlayerArchivement", getRootElement(), getLocalPlayer(), 63 ) 
		setPlayerMoney( getPlayerMoney() - 10000 )
	else
		addNotification(1, 200, 50, 50, "Not enough money.")
	end
end

function buyWheel()
	if getPlayerMoney() >= 12000 then
		setElementData(getLocalPlayer(), "Wheels", tonumber(gWaveWheels[shopSelectedWheel]))
		addNotification(2, 0, 200, 0, "Wheels successfully changed.")
		triggerServerEvent ( "addPlayerArchivement", getRootElement(), getLocalPlayer(), 65 ) 
		setPlayerMoney( getPlayerMoney() - 12000 )
	else
		addNotification(1, 200, 50, 50, "Not enough money.")
	end
end

function buyBacklight()
	if getPlayerMoney() >= 50000 or getElementData(getLocalPlayer(), "isDonator")then
		if getElementData(getLocalPlayer(),"Rank") >= 20 or getElementData(getLocalPlayer(), "isDonator") then
			setElementData(getLocalPlayer(), "Backlights", tonumber(shopSelectedBacklight))
			addNotification(2, 0, 200, 0, "Backlights successfully changed.")
			triggerServerEvent ( "addPlayerArchivement", getRootElement(), getLocalPlayer(), 76 ) 
			if getElementData(getLocalPlayer(), "isDonator") ~= true then
				setPlayerMoney( getPlayerMoney() - 50000 )
			end
			if getPedOccupiedVehicle(getLocalPlayer()) then setVehicleShaderBL(getPedOccupiedVehicle(getLocalPlayer()), tonumber(shopSelectedBacklight)) end
		else
			addNotification(1, 200, 50, 50, "You must be atleast level 20 or donator to buy this.")
		end
	else
		addNotification(1, 200, 50, 50, "Not enough money.")
	end
end

shopSelectedBacklight = 0
function selectNextBacklight(value)
	if shopSelectedBacklight + value < 0 then shopSelectedBacklight = 47 return end
	if shopSelectedBacklight + value > 47 then shopSelectedBacklight = 0 return end
	shopSelectedBacklight = shopSelectedBacklight + value
end

shopSelectedSkin = 0
function selectNextSkin(value)
	if shopSelectedSkin + value < 0 then shopSelectedSkin = 287 return end
	if shopSelectedSkin + value > 287 then shopSelectedSkin = 0 return end
	if fileExists ( "files/wave/skins/"..tostring(shopSelectedSkin + value)..".png" ) then
		shopSelectedSkin = shopSelectedSkin + value
	else
		shopSelectedSkin = shopSelectedSkin + value
		selectNextSkin(value)
	end
end

shopSelectedWheel = 1
function selectNextWheel(value)
	if shopSelectedWheel + value < 1 then shopSelectedWheel = #gWaveWheels return end
	if shopSelectedWheel + value > #gWaveWheels then shopSelectedWheel = 1 return end
	if fileExists ( "files/wave/wheels/"..tostring(gWaveWheels[shopSelectedWheel + value])..".jpg" ) then
		shopSelectedWheel = shopSelectedWheel + value
	else
		shopSelectedWheel = shopSelectedWheel + value
		selectNextWheel(value)
	end
end

function previewHorn(button)
	if button == "left" then
	local row = dxGridListGetSelectedItem ( g_customization1["horn_list"] )
		if row ~= false and dxGridListGetItemData (g_customization1["horn_list"], row ) then
			playSound("files/horns/"..dxGridListGetItemData (g_customization1["horn_list"], row ) ..".wav")
		end
	end
end

function buyHorn ( button )
	if button == "left" then
		if getPlayerMoney() >= 30000 then
			local row = dxGridListGetSelectedItem ( g_customization1["horn_list"] )
			local number = tonumber(dxGridListGetItemData (g_customization1["horn_list"], row ))
			if number >= 0 and number <= 18 then
				if getElementData(getLocalPlayer(), "usedHorn") == number then
					addNotification(1, 200, 50, 50, "Horn already bought.")
				else
					setPlayerMoney( getPlayerMoney() - 30000 )
					addNotification(2, 0, 200, 0, "Horn successfully bought.")
					setElementData(getLocalPlayer(), "usedHorn", number)
				end
			end
		else
			addNotification(1, 200, 50, 50, "Not enough money.")
		end
	end
end

shopBox = guiCreateComboBox ( screenWidth/2+212, screenHeight/2+200, 180, 85, "", false )
guiComboBoxAddItem( shopBox, "General" )
guiComboBoxAddItem( shopBox, "Customization" )
guiComboBoxAddItem( shopBox, "Mapshop" )
guiComboBoxSetSelected ( shopBox, 0 )
guiSetVisible(shopBox, false)


g_shopgui = {}
g_shopgui["buy_repair"] = dxCreateButton(screenWidth/2+253,screenHeight/2-239,139,24,"Buy Repair (3000 Vero)",false)
addEventHandler ( "onClientDXClick", g_shopgui["buy_repair"], Repair, false ) 
g_shopgui["buy_flip"] = dxCreateButton(screenWidth/2+253,screenHeight/2-184,139,24,"Buy Flip (4000 Vero)",false)
addEventHandler ( "onClientDXClick", g_shopgui["buy_flip"], Flip, false )
g_shopgui["buy_ticket"] = dxCreateButton(screenWidth/2+253,screenHeight/2-129,139,24,"Buy Ticket (300 Vero)",false)
addEventHandler ( "onClientDXClick", g_shopgui["buy_ticket"], function() executeServerCommandHandler ( "bt" ) end, false )

g_mapshop = {}
g_mapshop["map_list"] = dxCreateGridList(screenWidth/2-392,screenHeight/2-215,250,400)
gMapSearch = guiCreateEdit ( screenWidth/2-136,screenHeight/2-200, 150, 20, "", false )
g_mapshop["buy"] = dxCreateButton(screenWidth/2-392,screenHeight/2+190,250,24,"Buy Map (6000 Vero)",false)
addEventHandler ( "onClientDXClick", g_mapshop["buy"], function()
	local row = dxGridListGetSelectedItem ( g_mapshop["map_list"] )
	if row and dxGridListGetItemData ( g_mapshop["map_list"], row ) then
		executeServerCommandHandler ( "buynextmap", dxGridListGetItemData ( g_mapshop["map_list"], row ) )
	end
end, false )
g_mapshop["redo"]= dxCreateButton(screenWidth/2-392,screenHeight/2+219,250,24,"Redo Current Map (3000 Vero)",false)
addEventHandler ( "onClientDXClick",g_mapshop["redo"], function() executeServerCommandHandler ( "buyredo" ) end, false )

g_customization1 = {}
g_customization1["buy_color"] = dxCreateButton(screenWidth/2-75,screenHeight/2-110,139,24,"Buy Color (10000 Vero)",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_color"], buyColorPicker, false ) 
g_customization1["buy_skinprev"] = dxCreateButton(screenWidth/2-392,screenHeight/2+148,20,20,"<",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_skinprev"], function() selectNextSkin(-1) end, false )
g_customization1["buy_skinnext"] = dxCreateButton(screenWidth/2-327,screenHeight/2+148,20,20,">",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_skinnext"], function() selectNextSkin(1) end, false )
g_customization1["buy_skin"] = dxCreateButton(screenWidth/2-392,screenHeight/2+170,85,24,"Buy\n(10000 Vero)",false, true)
addEventHandler ( "onClientDXClick", g_customization1["buy_skin"], buySkin, false ) 

g_customization1["buy_wheelprev"] = dxCreateButton(screenWidth/2-292,screenHeight/2+148,20,20,"<",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_wheelprev"], function() selectNextWheel(-1) end, false ) 
g_customization1["buy_wheelnext"] = dxCreateButton(screenWidth/2-227,screenHeight/2+148,20,20,">",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_wheelnext"], function() selectNextWheel(1) end, false ) 
g_customization1["buy_wheel"] = dxCreateButton(screenWidth/2-292,screenHeight/2+170,85,24,"Buy\n(12000 Vero)",false, true)
addEventHandler ( "onClientDXClick", g_customization1["buy_wheel"], buyWheel, false ) 

g_customization1["buy_blprev"] = dxCreateButton(screenWidth/2-192,screenHeight/2+148,20,20,"<",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_blprev"], function() selectNextBacklight(-1) end, false ) 
g_customization1["buy_blnext"] = dxCreateButton(screenWidth/2-127,screenHeight/2+148,20,20,">",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_blnext"], function() selectNextBacklight(1) end, false ) 
g_customization1["buy_bl"] = dxCreateButton(screenWidth/2-192,screenHeight/2+170,85,24,"Buy\n(50000 Vero)",false, true)
addEventHandler ( "onClientDXClick", g_customization1["buy_bl"], buyBacklight, false ) 

g_customization1["horn_list"] = dxCreateGridList(screenWidth/2+130,screenHeight/2-215,200,220)

g_customization1["buy_horn"] = dxCreateButton(screenWidth/2+130,screenHeight/2+10,200,24,"Buy (30000 Vero)",false)
addEventHandler ( "onClientDXClick", g_customization1["buy_horn"], buyHorn, false ) 
g_customization1["preview_horn"] = dxCreateButton(screenWidth/2+130,screenHeight/2+48,200,24,"Preview Horn",false)
addEventHandler ( "onClientDXClick", g_customization1["preview_horn"], previewHorn, false ) 

g_customization1g = {}
g_customization1g["hex_color"] = guiCreateEdit ( screenWidth/2-75,screenHeight/2-145,139,24, "Anus",false )
g_customization1g["check_color1"] = guiCreateCheckBox ( screenWidth/2-75,screenHeight/2-215, 20,20, "", true, false)
g_customization1g["check_color2"] = guiCreateCheckBox ( screenWidth/2-75,screenHeight/2-195, 20,20, "", true, false)
g_customization1g["check_colorl"] = guiCreateCheckBox ( screenWidth/2-75,screenHeight/2-175, 20,20, "", true, false)

addEventHandler("onClientGUIChanged", g_customization1g["hex_color"], function() 
   updateViaHex(1)
end)

for num = 0, 26 do
	if num == 0 then
		dxGridListAddRow ( g_customization1["horn_list"], "Default Horn", tostring(num) )
	else
		dxGridListAddRow ( g_customization1["horn_list"], "Horn "..num, tostring(num) )
	end
end


for i,v in pairs(g_shopgui) do
	dxSetVisible(v, false)
end
for i,v in pairs(g_customization1) do
	dxSetVisible(v, false)
end
for i,v in pairs(g_customization1g) do
	guiSetVisible(v, false)
end		
for i,v in pairs(g_mapshop) do
	dxSetVisible(v, false)
end		
guiSetVisible(gMapSearch, false)

function waveDrawShop()
	if guiComboBoxGetSelected ( shopBox ) == -1 then guiComboBoxSetSelected ( shopBox, 0 ) end
	if guiComboBoxGetSelected ( shopBox ) == 0 then
		if getPlayerGameMode(getLocalPlayer()) == 5 or getPlayerGameMode(getLocalPlayer()) == 3 then --DM and RA
			dxSetVisible(g_shopgui["buy_repair"], true)
			dxSetVisible(g_shopgui["buy_flip"], true)
		else
			dxDrawShadowedText("NOT AVAILABLE",screenWidth/2+233,screenHeight/2-239, screenWidth, screenHeight, tocolor(125,125,125,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("NOT AVAILABLE",screenWidth/2+233,screenHeight/2-184, screenWidth, screenHeight, tocolor(125,125,125,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		end
			dxSetVisible(g_shopgui["buy_ticket"], true)
			dxDrawShadowedText("Repair",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
			dxDrawShadowedText("Repair your vehicle to full health again.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	

			dxDrawShadowedText("Flip",screenWidth/2-392,screenHeight/2-200, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
			dxDrawShadowedText("Lying on your back? Turn yourself around again by flipping!",screenWidth/2-392,screenHeight/2-180, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)

			dxDrawShadowedText("Lottery Ticket",screenWidth/2-392,screenHeight/2-160, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
			dxDrawShadowedText("Do you trust in your luck? The lottery is an easy way to get some cash.",screenWidth/2-392,screenHeight/2-140, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)			
	elseif guiComboBoxGetSelected( shopBox ) == 1 then
		openPicker(1, "#FFFFFF", "ANUS")
		gColorPickerShallBeDrawn = true
		dxDrawShadowedText("Vehicle Color",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		colorPickersTable[1]:render()
		
		dxDrawShadowedText("Color #1", screenWidth/2-50,screenHeight/2-213, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Color #2", screenWidth/2-50,screenHeight/2-193, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxDrawShadowedText("Headlight Color", screenWidth/2-50,screenHeight/2-173, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		
		dxDrawShadowedText("Skin",screenWidth/2-392,screenHeight/2+43, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawRectangle ( screenWidth/2-392,screenHeight/2+65, 85,78, tocolor(0,0,0,100))
		if fileExists ( "files/wave/skins/"..shopSelectedSkin..".png" ) then
			dxDrawImage ( screenWidth/2-392,screenHeight/2+65, 85,78, "files/wave/skins/"..shopSelectedSkin..".png", 0,0,0,tocolor(255,255,255,255*waveAlpha*waveMenuAlpha) )
		end

		dxDrawShadowedText("Wheels",screenWidth/2-292,screenHeight/2+43, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawRectangle ( screenWidth/2-292,screenHeight/2+65, 85,78, tocolor(0,0,0,100))
		if fileExists ( "files/wave/wheels/"..gWaveWheels[shopSelectedWheel]..".jpg" ) then
			dxDrawImage ( screenWidth/2-292,screenHeight/2+65, 85,78, "files/wave/wheels/"..gWaveWheels[shopSelectedWheel]..".jpg", 0,0,0,tocolor(255,255,255,255*waveAlpha*waveMenuAlpha) )
		end		
		
		dxDrawShadowedText("Backlight",screenWidth/2-192,screenHeight/2+43, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawRectangle ( screenWidth/2-192,screenHeight/2+65, 85,78, tocolor(0,0,0,100))
		if fileExists ( "files/backlights/"..shopSelectedBacklight..".jpg" ) then
			dxDrawImageSection ( screenWidth/2-182,screenHeight/2+90, 64,32,128-64,0,64,32, "files/backlights/"..shopSelectedBacklight..".jpg", 0,0,0,tocolor(255,255,255,255*waveAlpha*waveMenuAlpha) )
		elseif shopSelectedBacklight == 0 then
			dxDrawShadowedText("Default",screenWidth/2-192,screenHeight/2+65, screenWidth/2-192+85,screenHeight/2+65+78, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "center", "center", false, false, false, true)
		end			
		
		dxDrawShadowedText("Custom Horns",screenWidth/2+130,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		
		for i,v in pairs(g_customization1) do
			dxSetVisible(v, true)
		end	
		
		if getElementData(getLocalPlayer(), "isDonator") then
			setElementData(g_customization1["buy_bl"], "text", "Buy\n(free for donators)")
		elseif getElementData(getLocalPlayer(),"Rank") >= 20 then
			setElementData(g_customization1["buy_bl"], "text", "Buy\n(50000 Vero)")
		else
			dxSetVisible(g_customization1["buy_bl"], false)
			dxDrawShadowedText("buyable at level 20+\nor as donator",screenWidth/2-192,screenHeight/2+170,screenWidth/2-192+85,screenHeight/2+170+24, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 0.8,"default-bold", "center", "center", false, false, false, true)
		end
		
		for i,v in pairs(g_customization1g) do
			guiSetVisible(v, true)
		end				
	elseif guiComboBoxGetSelected( shopBox ) == 2 then
		if getPlayerGameMode(getLocalPlayer()) == 4 or getPlayerGameMode(getLocalPlayer()) == 6 then
			dxDrawShadowedText("'Maps' currently disabled",0,0, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 2,"default-bold", "center", "center", false, false, false, true)	
		else
			dxDrawShadowedText("Available Maps",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
			dxDrawShadowedText("Map searching:",screenWidth/2-137,screenHeight/2-215, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
			dxDrawShadowedText("The maps listed here are currently buyable.\nYou can buy each map every 15 minutes but be aware:\nMass setting of maps is against the rules!\n\nSelect the map you want and press the 'Buy Map' button.\nRedoing the current map only costs the half of buying it again!",screenWidth/2-137,screenHeight/2-175, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
			for i,v in pairs(g_mapshop) do
				dxSetVisible(v, true)
			end		
			guiSetVisible(gMapSearch, true)
		end
	end
	guiSetVisible(shopBox, true)
end

addEventHandler("onClientGUIChanged", gMapSearch, function() 
	if guiGetText(source) == "" then
		if getPlayerGameMode(getLocalPlayer()) == 1 then
			dxGridListReplaceRows(g_mapshop["map_list"], gAllTheMapsSH)
		elseif getPlayerGameMode(getLocalPlayer()) == 2 then
			dxGridListReplaceRows(g_mapshop["map_list"], gAllTheMapsDD)
		elseif getPlayerGameMode(getLocalPlayer()) == 3 then
			dxGridListReplaceRows(g_mapshop["map_list"], gAllTheMapsRA)		
		elseif getPlayerGameMode(getLocalPlayer()) == 5 then
			dxGridListReplaceRows(g_mapshop["map_list"], gAllTheMapsDM)
		end	
	else
		local mapTable = {}
		local mapTable2 = {}
		if getPlayerGameMode(getLocalPlayer()) == 1 then
			mapTable = gAllTheMapsSH
		elseif getPlayerGameMode(getLocalPlayer()) == 2 then
			mapTable = gAllTheMapsDD
		elseif getPlayerGameMode(getLocalPlayer()) == 3 then
			mapTable = gAllTheMapsRA
		elseif getPlayerGameMode(getLocalPlayer()) == 5 then
			mapTable = gAllTheMapsDM
		end	
		
		for i,v in ipairs(mapTable) do
			if string.find (string.upper (tostring(v.text)), string.upper (guiGetText(source))) ~= nil then
				mapTable2[#mapTable2+1] = v
			end
		end
		dxGridListClear(g_mapshop["map_list"])
		dxGridListReplaceRows(g_mapshop["map_list"], mapTable2)
	end
end)

 
function checkIfNotClickedOnEdit ( button, state, sx, sy, worldX, worldY, worldZ, clickedElement )
	if waveSelected == 5 and guiComboBoxGetSelected( shopBox ) == 2 and state == "down" and showUserGui == true	then
		local x,y  = guiGetPosition(gMapSearch, false)
		local w, h = guiGetSize(gMapSearch, false)
		if sx >= x and sx <= x+w and sy >= y and sy <= y+h then else guiBringToFront ( shopBox ) end
	elseif waveSelected == 5 and guiComboBoxGetSelected( shopBox ) == 1 and state == "down" and showUserGui == true	then
		local x,y  = guiGetPosition(g_customization1g["hex_color"], false)
		local w, h = guiGetSize(g_customization1g["hex_color"], false)
		if sx >= x and sx <= x+w and sy >= y and sy <= y+h then else guiBringToFront ( shopBox ) end
	end
end
addEventHandler ( "onClientClick", getRootElement(), checkIfNotClickedOnEdit )