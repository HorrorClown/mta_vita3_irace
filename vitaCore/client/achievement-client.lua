--[[
Project: vitaCore
File: achievement-client.lua
Author(s):	Sebihunter
]]--

gAchievementNotifications = {}

tArchivements = {}
isAchievementShowing = false

function receiveArchivementsFromServer(table)
	tArchivements = table
end
addEvent("receiveArchivementsFromServer", true)
addEventHandler("receiveArchivementsFromServer", resourceRoot, receiveArchivementsFromServer)

function addAchievementNotification(title, description)
	local number = 0
	--for i = 1,10 do
	for i = 0, #gAchievementNotifications+1 do
		if gAchievementNotifications[number] then
			number = number +1
		else
			gAchievementNotifications[number] = {}
			gAchievementNotifications[number].valid = "waiting"
			gAchievementNotifications[number].alpha = 0
			gAchievementNotifications[number].title = title
			gAchievementNotifications[number].description = description
			if isEventHandlerAdded( "onClientRender", getRootElement(), renderAchievements ) == false then
				addEventHandler("onClientRender", getRootElement(), renderAchievements, true, "low-2")
			end
			break
		end
	end
end
addEvent("addAchievementNotification", true)
addEventHandler("addAchievementNotification", getRootElement(), addAchievementNotification)

function deleteAchievementNotification(notNum)
	gAchievementNotifications[notNum].valid = false
end 

function renderAchievements()
	
	local isShowing = false
	for i,v in pairs(gAchievementNotifications) do
		if v.valid == true then
			isShowing = true
			if v.alpha < 255 then
				v.alpha = v.alpha+5
			end
			local _, posY, _ = interpolateBetween ( 0, screenHeight, 0, 
                                       0,  screenHeight-400, 0, 
                                       v.alpha/255, "OutBack" )
									   
				dxDrawImage(screenWidth/2-256, posY,512,512,"files/achv.png",0,0,0, tocolor(255,255,255,255), true)
				dxDrawText ( v.title, screenWidth/2-256 , posY+250,screenWidth/2+256,screenHeight, tocolor ( 255, 255, 255, 255*0.8 ), 1, "default", "center", "top", false, false, true )
				dxDrawText ( v.description, screenWidth/2-256 , posY+265,screenWidth/2+256,screenHeight, tocolor ( 255, 255, 255, 255*0.6 ), 1, "arial", "center", "top", false, false, true )	
		elseif v.valid == false then
			isShowing = true
			if v.alpha > 0 then
				v.alpha = v.alpha-15
				
				--local _, posY, _ = interpolateBetween ( 0, screenHeight, 0, 
                --                       0,  screenHeight-400, 0, 
                --                       v.alpha/255, "OutQuad" )
				local posY = screenHeight-400				   
				dxDrawImage(screenWidth/2-256, posY,512,512,"files/achv.png",0,0,0, tocolor(255,255,255,v.alpha), true)
				dxDrawText ( v.title, screenWidth/2-256 , posY+250,screenWidth/2+256,screenHeight, tocolor ( 255, 255, 255, v.alpha*0.8 ), 1, "default", "center", "top", false, false, true )
				dxDrawText ( v.description, screenWidth/2-256 , posY+265,screenWidth/2+256,screenHeight, tocolor ( 255, 255, 255, v.alpha*0.6 ), 1, "arial", "center", "top", false, false, true )								
			else
				gAchievementNotifications[i] = nil
				if #gAchievementNotifications == 0 then
					removeEventHandler("onClientRender", getRootElement(), renderAchievements)
				end
			end
		end
	end
	
	if isShowing == false then
		for i,v in pairs(gAchievementNotifications) do
			if v.valid == "waiting" then
				v.valid = true
				setTimer(deleteAchievementNotification, 8000, 1, i)
				playSound("files/audio/achievement.mp3")
				break
			end
		end
	end
end