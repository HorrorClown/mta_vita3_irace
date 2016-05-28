--[[
Project: vitaCore
File: notify-client.lua
Author(s):	Sebihunter
]]--
local screenWidth, screenHeight = guiGetScreenSize()
local movingSpace = 0
gNotifications = {}

function addNotification(id, r, g, b, text)
	local number = 1
	for i = 1, #gNotifications+1 do
		if gNotifications[number] then
			number = number +1
		else
			gNotifications[number] = {}
			gNotifications[number].alpha = 0
			gNotifications[number].id = id
			gNotifications[number].r = r
			gNotifications[number].g = g
			gNotifications[number].b = b
			gNotifications[number].text = text
			gNotifications[number].starttick = getTickCount ()
			playSound("files/audio/notify.mp3")
			if isEventHandlerAdded( "onClientRender", getRootElement(), renderNotifications ) == false then
				addEventHandler("onClientRender", getRootElement(), renderNotifications, true, "low-2")
			end				
			outputConsole("Notification: "..text)
			break
		end
	end
end
addEvent("addNotification", true)
addEventHandler("addNotification", getRootElement(), addNotification)


function renderNotifications()
	if #gNotifications == 0 then removeEventHandler("onClientRender", getRootElement(), renderNotifications) end
	if movingSpace > 0 then movingSpace = movingSpace-5 end
	local startMoving = movingSpace
	for i,v in pairs(gNotifications) do
		iDraw = i-1
		if (getTickCount() - v.starttick) <= 8000 then
			if v.alpha < 255 then
				v.alpha = v.alpha+15
			end
			
			
			local width = dxGetTextWidth ( v.text, 1, "default-bold", true)
			local doubleLined = split(v.text, "\n") 
			if doubleLined[2] ~= nil then
				local lineOne = dxGetTextWidth ( doubleLined[1], 1, "default-bold", true)
				local lineTwo = dxGetTextWidth ( doubleLined[2], 1, "default-bold", true)
				if lineOne > lineTwo then width = lineOne else width = lineTwo end
			end
			
		
			dxDrawImage(screenWidth-width-64,10+60*iDraw+movingSpace, width+64,49, "files/notification.png",0,0,0, tocolor(v.r, v.g, v.b, v.alpha), true)
			dxDrawImage(screenWidth-width-54,10+8+60*iDraw+movingSpace, 32,32, "files/notify"..v.id..".png",0,0,0, tocolor(255,255,255,v.alpha), true)
			
			if doubleLined[2] ~= nil then
				dxDrawText ( doubleLined[1], screenWidth-width-14, 10+16+60*iDraw-6+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
				dxDrawText ( doubleLined[2], screenWidth-width-14, 10+16+60*iDraw+7+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
			else
				dxDrawText ( v.text, screenWidth-width-14, 10+16+60*iDraw+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true, true)
			end
		else
			if v.alpha > 0 then
				v.alpha = v.alpha-15
				local width = dxGetTextWidth ( v.text, 1, "default-bold")
				
				local doubleLined = split(v.text, "\n") 
				if doubleLined[2] ~= nil then
					local lineOne = dxGetTextWidth ( doubleLined[1], 1, "default-bold")
					local lineTwo = dxGetTextWidth ( doubleLined[2], 1, "default-bold")
					if lineOne > lineTwo then width = lineOne else width = lineTwo end
				end	
	
				dxDrawImage(screenWidth-width-64,10+60*iDraw+movingSpace, width+64,49, "files/notification.png",0,0,0, tocolor(v.r, v.g, v.b, v.alpha), true)
				dxDrawImage(screenWidth-width-54,10+8+60*iDraw+movingSpace, 32,32, "files/notify"..v.id..".png",0,0,0, tocolor(255,255,255,v.alpha), true)
				
				if doubleLined[2] ~= nil then
					dxDrawText ( doubleLined[1], screenWidth-width-14, 10+16+60*iDraw-6+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
					dxDrawText ( doubleLined[2], screenWidth-width-14, 10+16+60*iDraw+7+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
				else
					dxDrawText ( v.text, screenWidth-width-14, 10+16+60*iDraw+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
				end					
			else
				table.remove (gNotifications, i)
				movingSpace = movingSpace+60
				
				--Draw the one with this id again (otherwise its not drawn as the notification after this notification has now the same id as the one before)
				v = gNotifications[i]
				if v then
					v.alpha = v.alpha-15
					local width = dxGetTextWidth ( v.text, 1, "default-bold")
					
					local doubleLined = split(v.text, "\n") 
					if doubleLined[2] ~= nil then
						local lineOne = dxGetTextWidth ( doubleLined[1], 1, "default-bold")
						local lineTwo = dxGetTextWidth ( doubleLined[2], 1, "default-bold")
						if lineOne > lineTwo then width = lineOne else width = lineTwo end
					end	
		
					dxDrawImage(screenWidth-width-64,10+60*iDraw+movingSpace, width+64,49, "files/notification.png",0,0,0, tocolor(v.r, v.g, v.b, v.alpha), true)
					dxDrawImage(screenWidth-width-54,10+8+60*iDraw+movingSpace, 32,32, "files/notify"..v.id..".png",0,0,0, tocolor(255,255,255,v.alpha), true)
					
					if doubleLined[2] ~= nil then
						dxDrawText ( doubleLined[1], screenWidth-width-14, 10+16+60*iDraw-6+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
						dxDrawText ( doubleLined[2], screenWidth-width-14, 10+16+60*iDraw+7+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
					else
						dxDrawText ( v.text, screenWidth-width-14, 10+16+60*iDraw+movingSpace, screenWidth, screenHeight, tocolor ( 255, 255, 255, v.alpha ), 1, "default-bold", "left", "top", false, false, true )	
					end
				end
				
			end
		end
	end
end