--[[
Project: Vita Ware
File: su-client.lua
Author(s):	Sebihunter
]]--

sumoGame = false
local sumoTextureFiles = {}
local sumoTexturesModels = {}
function SUClient(toggle, suTextures)
	if toggle == true then
		addEventHandler ( "onClientRender", root, SURender )
		sumoGame = true
		gBlockCarfade = true
		sumoTextureFiles = {}
	
		if suTextures then
			for i,v in ipairs(suTextures) do
				sumoTextureFiles[#sumoTextureFiles+1] = engineLoadTXD ( v[2] )
				engineImportTXD  ( sumoTextureFiles[#sumoTextureFiles], v[1] )
				if v[3] then
					sumoTexturesModels[#sumoTexturesModels+1] = engineLoadDFF ( v[3] )
					engineReplaceModel ( sumoTexturesModels[#sumoTexturesModels], v[1] )
				end
			end
		end
		
		for i,v in ipairs(getGamemodePlayers(4)) do
			setElementDimension(v, 4)
			if getPedOccupiedVehicle(v) then setElementDimension(getPedOccupiedVehicle(v),4) end
		end
	else
		removeEventHandler ( "onClientRender", root, SURender )
		sumoGame = false
		gBlockCarfade = false
		for i,v in ipairs(sumoTextureFiles) do
			destroyElement(v)
		end		
		for i,v in ipairs(sumoTexturesModels) do
			destroyElement(v)
		end				
		if suTextures then
			for i,v in ipairs(suTextures) do
				if v then
					engineRestoreModel ( v[1] )
				end
			end
		end
	end
end

function SURender ()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then return end
	if getElementData(getLocalPlayer(), "suText") then
		dxDrawText ( getElementData(getLocalPlayer(), "suText"), 0+1, screenHeight - 200 + 1, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "suText"), 0, screenHeight - 200, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 2, "default-bold", "center" ) 		
	end
	
	if getElementData(getLocalPlayer(), "suTimerTime") then
		dxDrawText ( getElementData(getLocalPlayer(), "suTimerTime").."/180", 0+1, 18, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 3, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "suTimerTime").."/180", 0, 17, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 3, "default-bold", "center" ) 	
	end
	if getElementData(getLocalPlayer(), "suTimeLeft") then
		dxDrawText ( "Time left: "..msToTimeStr(getElementData(getLocalPlayer(), "suTimeLeft") > 0 and getElementData(getLocalPlayer(), "suTimeLeft") or 0, true), 0+1, 56, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "default-bold", "center" ) 
		dxDrawText ( "Time left: "..msToTimeStr(getElementData(getLocalPlayer(), "suTimeLeft") > 0 and getElementData(getLocalPlayer(), "suTimeLeft") or 0, true), 0, 55, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 1, "default-bold", "center" ) 	
	end	
end

function SUCollision(toggle,veh)
	if toggle == true then
		for i,v in ipairs(getElementsByType("vehicle")) do
			if v~= veh and getElementDimension(v) == 4 and getElementAlpha(v) == 255 then
				setElementCollidableWith ( v, veh,true)
				setElementCollidableWith ( veh, v,true )
			end
		end		
	else
		for i,v in ipairs(getElementsByType("vehicle")) do
			if v~= veh and getElementDimension(v) == 4 then
				setElementCollidableWith ( v, veh,false )
				setElementCollidableWith ( veh, v,false )
			end
		end	
	end
end