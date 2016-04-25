--[[
Project: vitaCore
File: carfade-client.lua
Author(s):	Sebihunter
]]--

function blockCarfade(toggle)
	gBlockCarfade = toggle
end

function alpha ()
	if gBlockCarfade == true or getElementData(getLocalPlayer(), "gBlockCarfade") == true then return end
	for k,v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
		if getElementData(v, "isDMVeh") == true or getElementData(v, "isRAVeh") == true or getElementData(v, "isDDVeh") == true or getElementData(v, "isSHVeh") == true then
			if getVehicleOccupant ( v ) == false then
				setElementDimension(v, 0)
			end
		end
	end
	for k, v in ipairs (getElementsByType ( "player",getRootElement() )) do
		if v ~= getLocalPlayer() then
			if getElementData(getLocalPlayer(), "ghostmod") == true then
				colideWithPlayer(v, false)
			else
				setElementAlpha(v, 255)
				if isPlayerAlive(v) then
					colideWithPlayer(v, true)
				else
					colideWithPlayer(v, false)
				end
			end
		end
	end
	if isElement ( getPedOccupiedVehicle ( getLocalPlayer() ) ) ~= false then
		setElementAlpha ( getPedOccupiedVehicle ( getLocalPlayer() ), 255 )
		setElementAlpha ( getLocalPlayer(), 255 )
		
		for k,v in pairs(getElementsByType("vehicle",getRootElement(), true)) do
			if getElementData(v, "isMapSHVehicle") == true or getElementData(v, "isMapDMVehicle") == true or getElementData(v, "isMapDDVehicle") == true or getElementData(v, "isMapRAVehicle") == true then
				setElementCollidableWith ( v,  getPedOccupiedVehicle ( getLocalPlayer() ), false )
				setElementCollidableWith ( getPedOccupiedVehicle ( getLocalPlayer() ), v, false )
			end
		end

		
		for k, v in ipairs (getElementsByType ( "player")) do
			if v ~= getLocalPlayer() and getPlayerGameMode(v) == getPlayerGameMode(getLocalPlayer()) then
				if getElementData( getLocalPlayer(), "ghostmod" ) == true then
					if  isElement ( getPedOccupiedVehicle ( v ) ) ~= false then
						local x2, y2, z2 = getElementPosition ( v )
						local x1, y1, z1 = getElementPosition ( getLocalPlayer() )
						distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )						
						if isPlayerAlive(v) == false then	
							setElementAlpha (  v, 0 ) 
							setElementAlpha (  getPedOccupiedVehicle(v), 0 )
							setElementDimension(getPedOccupiedVehicle(v), 0)
							setElementDimension(v, 0)					
						else
							if showPlayerCarfade == 0  or getElementData(getLocalPlayer(), "state") == "dead" then
								setElementAlpha (  v, 255 ) 
								setElementAlpha (  getPedOccupiedVehicle(v), 255 )
								setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
								setElementDimension(v, getElementDimension(getLocalPlayer()))
							elseif showPlayerCarfade == 1 and getElementData(getLocalPlayer(), "state") ~= "dead" then
								if distance*13.5 >= 255 then
									setElementAlpha ( getPedOccupiedVehicle ( v ), 255 )
									setElementAlpha ( v, 255 )
									setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
									setElementDimension(v, getElementDimension(getLocalPlayer()))
								elseif distance*13.5 <= 104 then
									setElementAlpha ( getPedOccupiedVehicle ( v ), 104 )
									setElementAlpha ( v, 104 )
									setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
									setElementDimension(v, getElementDimension(getLocalPlayer()))
								else
									setElementAlpha ( getPedOccupiedVehicle ( v ), distance*13.5 )
									setElementAlpha (  v, distance*13.5 )
									setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
									setElementDimension(v, getElementDimension(getLocalPlayer()))
								end
							elseif showPlayerCarfade == 2 and getElementData(getLocalPlayer(), "state") ~= "dead" then
								if distance*13.5 >= 255 then
									setElementAlpha ( getPedOccupiedVehicle ( v ), 255 )
									setElementAlpha ( v, 255 )
									setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
									setElementDimension(v, getElementDimension(getLocalPlayer()))
								else                                        
									setElementAlpha ( getPedOccupiedVehicle ( v ), distance*13.5 )
									setElementAlpha (  v, distance*13.5 )
									setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
									setElementDimension(v, getElementDimension(getLocalPlayer()))
								end				
							elseif showPlayerCarfade == 3 and getElementData(getLocalPlayer(), "state") ~= "dead" then
								setElementAlpha (  v, 0 ) 
								setElementAlpha (  getPedOccupiedVehicle(v), 0 )
								setElementDimension(getPedOccupiedVehicle(v), 0)
								setElementDimension(v, 0)
							end
						end
					else
						setElementDimension(v, 0)
					end
				else
					if isPlayerAlive(v) then
						if getPedOccupiedVehicle(v) then 		
							setElementAlpha ( getPedOccupiedVehicle ( v ), 255 )
							setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
						end
						setElementAlpha ( v, 255 )
						setElementDimension(v, getElementDimension(getLocalPlayer()))
					else
						if getPedOccupiedVehicle(v) then 		
							setElementAlpha ( getPedOccupiedVehicle ( v ), 0 )
							setElementDimension(getPedOccupiedVehicle(v), 0)
						end
						setElementAlpha ( v, 0 )
						setElementDimension(v, 0)					
					end
				end
			end
		end
		else for k, v in ipairs (getElementsByType ( "player")) do
			if v ~= getLocalPlayer() then
				if isPlayerAlive(v) == true then
					if isElement ( getPedOccupiedVehicle ( v ) ) ~= false then
						setElementDimension(getPedOccupiedVehicle(v), getElementDimension(getLocalPlayer()))
						setElementAlpha ( getPedOccupiedVehicle ( v ), 255 )
					end
					setElementDimension(v, getElementDimension(getLocalPlayer()))
					setElementAlpha ( v, 255 )
				else
					setElementDimension(v, 0)
					setElementAlpha(v, 0 )
				end
			end
		end
	end
end
setTimer( alpha, 100, 0 )

function colideWithPlayer(player, toggle)
	for k, v in ipairs (getElementsByType ( "player",getRootElement(), true )) do
		if v ~= player then
			local veh1 = getPedOccupiedVehicle(player)
			local veh2 = getPedOccupiedVehicle(v)
			setElementCollidableWith ( v, player, toggle )
			setElementCollidableWith ( player, v, toggle )
			if veh1 then
				setElementCollidableWith ( veh1, v, toggle )
				setElementCollidableWith ( v, veh1, toggle )
				if veh2 then
					setElementCollidableWith ( veh1, veh2, toggle )
					setElementCollidableWith ( veh2, veh1, toggle )
					setElementCollidableWith ( veh2, player, toggle )
					setElementCollidableWith ( player, veh2, toggle )					
				end
			end
		end
	end
end