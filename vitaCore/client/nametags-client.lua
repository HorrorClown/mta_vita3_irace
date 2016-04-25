nametag = {}
local nametags = {}
local g_screenX,g_screenY = guiGetScreenSize()
local bHideNametags = false

local NAMETAG_SCALE = 0.3 --Overall adjustment of the nametag, use this to resize but constrain proportions
local NAMETAG_ALPHA_DISTANCE = 50 --Distance to start fading out
local NAMETAG_DISTANCE = 120 --Distance until we're gone
local NAMETAG_ALPHA = 120 --The overall alpha level of the nametag
--The following arent actual pixel measurements, they're just proportional constraints
local NAMETAG_TEXT_BAR_SPACE = 2
local NAMETAG_WIDTH = 50
local NAMETAG_HEIGHT = 5
local NAMETAG_TEXTSIZE = 0.5
local NAMETAG_OUTLINE_THICKNESS = 1.2
--
local NAMETAG_ALPHA_DIFF = NAMETAG_DISTANCE - NAMETAG_ALPHA_DISTANCE
NAMETAG_SCALE = 1/NAMETAG_SCALE * 800 / g_screenY 

-- Ensure the name tag doesn't get too big
local maxScaleCurve = { {0, 0}, {3, 3}, {13, 5} }
-- Ensure the text doesn't get too small/unreadable
local textScaleCurve = { {0, 0.8}, {0.8, 1.2}, {99, 99} }
-- Make the text a bit brighter and fade more gradually
local textAlphaCurve = { {0, 0}, {25, 100}, {120, 190}, {255, 190} }

function nametag.create ( player )
	nametags[player] = true
end

function nametag.destroy ( player )
	nametags[player] = nil
end

addEventHandler ( "onClientRender", getRootElement(),
	function()
		-- Hideous quick fix --
		for i,player in pairs(getElementsByType("player",getRootElement(), true)) do
			if player ~= getLocalPlayer() then
				if not nametags[player] then
					nametag.create ( player )
				end
			end
		end
		if bHideNametags or (getElementData(getLocalPlayer(), "gameMode") == 4 and sumoGame == false) or getElementData(getLocalPlayer(), "gameMoed") == 6 then
			return
		end
		local x,y,z = getCameraMatrix()
		for player in pairs(nametags) do 
			while true do
				if not isPedInVehicle(player) or not isPlayerAlive(player) then break end
				local vehicle = getPedOccupiedVehicle(player)
				local px,py,pz = getElementPosition ( vehicle )
				local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
				if pdistance <= NAMETAG_DISTANCE then
					--Check if replaying -> Do not show nametag
					if getElementDimension(player) ~= getElementDimension(getLocalPlayer()) then return end
					if getPlayerGameMode(player) ~= getPlayerGameMode(getLocalPlayer()) then return end
					--Get screenposition
					local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
					if not sx or not sy then break end
					--Calculate our components
					local scale = 1/(NAMETAG_SCALE * (pdistance / NAMETAG_DISTANCE))
					local alpha = ((pdistance - NAMETAG_ALPHA_DISTANCE) / NAMETAG_ALPHA_DIFF)
					alpha = (alpha < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
					scale = math.evalCurve(maxScaleCurve,scale)
					local textscale = math.evalCurve(textScaleCurve,scale)
					local textalpha = math.evalCurve(textAlphaCurve,alpha)
					local outlineThickness = NAMETAG_OUTLINE_THICKNESS*(scale)
					--Draw our text
					local r,g,b = 255,255,255
					local team = getPlayerTeam(player)
					if team then
						r,g,b = getTeamColor(team)
					end
					local offset = (scale) * NAMETAG_TEXT_BAR_SPACE/2
					local offset2 = (scale) * NAMETAG_TEXT_BAR_SPACE*5
					local playerAlpha = 1.0
					if getPedOccupiedVehicle(player) and showPlayerCarfade ~= 1 then
						playerAlpha = getElementAlpha(getPedOccupiedVehicle(player))/255
					end
					if sumoGame == true and getElementData(player, "suTimerTime") then
						local sy2 
						if getElementData(player, "isDonator") then
							_,sy2 = getScreenFromWorldPosition ( px, py, pz+1.40, 0.06 )
						else
							_,sy2 = getScreenFromWorldPosition ( px, py, pz+1.25, 0.06 )
						end
						if sy2 then
							local sr,sg,sb = 0,255,0
							if getElementData(player, "suTimerTime") > 120 then
								sr,sg,sb = 255,0,0
							elseif getElementData(player, "suTimerTime") > 60 then
								sr,sg,sb = 255,255,0
							end						
							dxDrawText ( tostring(getElementData(player, "suTimerTime")), sx+1, sy2 - offset+1, sx, sy2 - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )				
							dxDrawText ( tostring(getElementData(player, "suTimerTime")), sx-1, sy2 - offset-1, sx, sy2 - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )
							dxDrawText ( tostring(getElementData(player, "suTimerTime")), sx+1, sy2 - offset-1, sx, sy2 - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )		
							dxDrawText ( tostring(getElementData(player, "suTimerTime")), sx-1, sy2 - offset+1, sx, sy2 - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )	
							dxDrawColorText ( tostring(getElementData(player, "suTimerTime")), sx, sy2 - offset, sx, sy2 - offset, tocolor(sr,sg,sb,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", textalpha*playerAlpha)	
						end
					end
					if getElementData(player, "isDonator") == true then
						if getElementData(player, "customStatus") == "none" then
							dxDrawText ( "-Donator-", sx+1, sy - offset2+1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )				
							dxDrawText ( "-Donator-", sx-1, sy - offset2-1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )
							dxDrawText ( "-Donator-", sx+1, sy - offset2-1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )		
							dxDrawText ( "-Donator-", sx-1, sy - offset2+1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )	
							dxDrawColorText ( "-Donator-", sx, sy - offset2, sx, sy - offset2, tocolor(194,103,255,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", textalpha*playerAlpha )
						else
							local status = getElementData(player, "customStatus")
							dxDrawText ( removeColorCoding(status), sx+1, sy - offset2+1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )				
							dxDrawText ( removeColorCoding(status), sx-1, sy - offset2-1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )
							dxDrawText ( removeColorCoding(status), sx+1, sy - offset2-1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )		
							dxDrawText ( removeColorCoding(status), sx-1, sy - offset2+1, sx, sy - offset2, tocolor(0,0,0,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )	
							dxDrawColorText ( status, sx, sy - offset2, sx, sy - offset2, tocolor(194,103,255,textalpha*playerAlpha), textscale*0.8*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", textalpha*playerAlpha )
						
						end
					end
					dxDrawText ( getPlayerName(player), sx+1, sy - offset+1, sx, sy - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )				
					dxDrawText ( getPlayerName(player), sx-1, sy - offset-1, sx, sy - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )
					dxDrawText ( getPlayerName(player), sx+1, sy - offset-1, sx, sy - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )		
					dxDrawText ( getPlayerName(player), sx-1, sy - offset+1, sx, sy - offset, tocolor(0,0,0,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )	
					dxDrawColorText ( _getPlayerName(player), sx, sy - offset, sx, sy - offset, tocolor(r,g,b,textalpha*playerAlpha), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", textalpha*playerAlpha )
					
					--Only in SHOOTER and DD and SUMO
					if getPlayerGameMode(getLocalPlayer()) == 1 or  getPlayerGameMode(getLocalPlayer()) == 2 or sumoGame == true then
						--We draw three parts to make the healthbar.  First the outline/background
						local drawX = sx - NAMETAG_WIDTH*scale/2
						drawY = sy + offset
						local width,height =  NAMETAG_WIDTH*scale, NAMETAG_HEIGHT*scale
						dxDrawRectangle ( drawX, drawY, width, height, tocolor(0,0,0,alpha*playerAlpha) )
						--Next the inner background 
						local health = getElementHealth(vehicle)
						health = math.max(health - 250, 0)/750
						local p = -510*(health^2)
						local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
						dxDrawRectangle ( 	drawX + outlineThickness, 
											drawY + outlineThickness, 
											width - outlineThickness*2, 
											height - outlineThickness*2, 
											tocolor(r,g,0,0.4*alpha*playerAlpha) 
										)
						--Finally, the actual health
						dxDrawRectangle ( 	drawX + outlineThickness, 
											drawY + outlineThickness, 
											health*(width - outlineThickness*2), 
											height - outlineThickness*2, 
											tocolor(r,g,0,alpha*playerAlpha) 
										)
										
						end
					end
				break
			end
		end
	end
)


---------------THE FOLLOWING IS THE MANAGEMENT OF NAMETAGS-----------------
addEventHandler('onClientResourceStart', getResourceRootElement ( getThisResource() ),
	function()
		for i,player in ipairs(getElementsByType("player")) do
			if player ~= getLocalPlayer() then
				nametag.create ( player )
			end
		end
	end
)

addEventHandler ( "onClientPlayerJoin", getRootElement(),
	function()
		if source == getLocalPlayer() then return end
		nametag.create ( source )
	end
)

addEventHandler ( "onClientPlayerQuit", getRootElement(),
	function()
		nametag.destroy ( source )
	end
)


addEvent ( "onClientScreenFadedOut", true )
addEventHandler ( "onClientScreenFadedOut", getRootElement(),
	function()
		bHideNametags = true
	end
)

addEvent ( "onClientScreenFadedIn", true )
addEventHandler ( "onClientScreenFadedIn", getRootElement(),
	function()
		bHideNametags = false
	end
)
