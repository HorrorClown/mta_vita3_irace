--[[
Project: vitaCore
File: notify-client.lua
Author(s):	Sebihunter
]]--



local screenWidth, screenHeight = guiGetScreenSize()
local movingSpace = 0
gKillmessages = {}


function addKillmessage(killed, killer, reason)
	local number = 1
	for i = 1, #gKillmessages+1 do
		if gKillmessages[number] then
			number = number +1
		else
			gKillmessages[number] = {}
			gKillmessages[number].alpha = 0
			gKillmessages[number].killed = _getPlayerName(killed)
			gKillmessages[number].killer = killer and _getPlayerName(killer) or false
			gKillmessages[number].reason = reason
			gKillmessages[number].starttick = getTickCount ()
			if isEventHandlerAdded( "onClientRender", getRootElement(), renderKillmessages ) == false then
				addEventHandler("onClientRender", getRootElement(), renderKillmessages, true, "low-2")
			end	
			if killer == getLocalPlayer() then
				playSound("files/audio/renegade_boink.wav")
			end
			break
		end
	end
end
addEvent("addKillmessage", true)
addEventHandler("addKillmessage", getRootElement(), addKillmessage)


function renderKillmessages()
	if getElementData(getLocalPlayer(), "gameMode") == 0 then gKillmessages = {} end
	if #gKillmessages == 0 then removeEventHandler("onClientRender", getRootElement(), renderKillmessages) end
	for i,v in pairs(gKillmessages) do
		iDraw = i-1
		if (getTickCount() - v.starttick) <= 8000 then
			if v.alpha+30 < 255 then
				v.alpha = v.alpha+30
			else
				v.alpha = 255
			end
			
			if v.killer then
				local reasonstring = ""
				if v.reason then
					reasonstring = " ("..v.reason..")"
				end
				dxDrawShadowedText ( v.killed.."#FFFFFF was killed by "..v.killer.."#FFFFFF"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )	
			else
				local reasonstring = ""
				if v.reason then
					reasonstring = " ("..v.reason..")"
				end
				dxDrawShadowedText ( v.killed.."#FFFFFF died"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )				
			end	
		else
			if v.alpha > 0 then
				v.alpha = v.alpha-15
				if v.killer then
					local reasonstring = ""
					if v.reason then
						reasonstring = " ("..v.reason..")"
					end
					dxDrawShadowedText ( v.killed.."#FFFFFF was killed by "..v.killer.."#FFFFFF"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )	
				else
					local reasonstring = ""
					if v.reason then
						reasonstring = " ("..v.reason..")"
					end
					dxDrawShadowedText ( v.killed.."#FFFFFF died"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )				
				end				
			else
				table.remove (gKillmessages, i)
				
				v = gKillmessages[i]
				if v then
					if v.killer then
						local reasonstring = ""
						if v.reason then
							reasonstring = " ("..v.reason..")"
						end
						dxDrawShadowedText ( v.killed.."#FFFFFF was killed by "..v.killer.."#FFFFFF"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )	
					else
						local reasonstring = ""
						if v.reason then
							reasonstring = " ("..v.reason..")"
						end
						dxDrawShadowedText ( v.killed.."#FFFFFF died"..reasonstring, 0, screenHeight/2-#gKillmessages*13/2+13*iDraw, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, v.alpha ), tocolor ( 0, 0, 0, v.alpha ), 1, "default-bold", "right", "top", false, false, true, true )				
					end	
				end	
			end
		end
	end
end