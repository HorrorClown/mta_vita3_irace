--[[
Project: Vita3
File: game-button-client.lua
Author(s):	Sebihunter
]]--

local active = false
local root = getRootElement()

local button_yes
local button_no

function ButtonStart()
	local side = math.random(0,1)
	
	if side == 1 then
		button_yes = guiCreateButton ( screenWidth/2+screenWidth/4, math.random(0,screenHeight-300), 200, 200, "Click Me", false )
		button_no = guiCreateButton ( screenWidth/2-screenWidth/4, math.random(0,screenHeight-300), 200, 200, "Don't Click", false )
	else
		button_yes = guiCreateButton ( screenWidth/2-screenWidth/4, math.random(0,screenHeight-300), 200, 200, "Click Me", false )
		button_no = guiCreateButton ( screenWidth/2+screenWidth/4, math.random(0,screenHeight-300), 200, 200, "Don't Click", false )	
	end
	
	 addEventHandler ( "onClientGUIClick", button_yes, function()
		local randomnum = math.random(1,3)
		playSound("./files/audio/ware/local_exo_won"..tostring(randomnum)..".wav")
		setElementData(getLocalPlayer(), "wareWon", true)		
		ButtonEnd()
	 end, false )
	 
	 addEventHandler ( "onClientGUIClick", button_no, function()
		local randomnum = math.random(1,3)
		playSound("./files/audio/ware/local_lose"..tostring(randomnum)..".wav")	
		ButtonEnd()
	 end, false )
	 
	 showCursor ( true )
end

function ButtonEnd()
	if isElement(button_yes) then
		if showUserGui == false then
			showCursor ( false )
		end
		destroyElement(button_yes)
		destroyElement(button_no)
	end
end

function ButtonCheck()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then
		removeEventHandler("onClientRender", root, ButtonCheck)
	end
	if getPedOccupiedVehicle(getLocalPlayer()) then
		local x, y, z = getElementVelocity(getPedOccupiedVehicle(getLocalPlayer()))
			if x == 0 and y == 0 and z == 0 then
			local randomnum = math.random(1,3)
			playSound("./files/sound/local_exo_won"..tostring(randomnum)..".wav")
			removeEventHandler("onClientRender", root, ButtonCheck)
			active = false
			setElementData(getLocalPlayer(), "wareWon", true)
		end	
	end
end