--[[
Project: vitaCore
File: dm-respawn.lua
Author(s):	Sebihunter
]]--

gDeathmatchRespawns = {}
function savePlayerPositionsDM ()
	for k, vehicle in ipairs(getElementsByType("vehicle")) do
		if getVehicleOccupant ( vehicle ) then
			ply = getVehicleOccupant ( vehicle )
			if getPlayerGameMode(ply) == gGamemodeDM and (getElementData(ply, "state") == "alive" or getElementData(ply, "state") == "replaying") then
				if tostring(gDeathmatchRespawns[ply]) == "nil" then
					gDeathmatchRespawns[ply] = {}
					gDeathmatchRespawns[ply]["G_counter"] = 0
				end
				gDeathmatchRespawns[ply]["G_counter"] = gDeathmatchRespawns[ply]["G_counter"] + 1
				local Counter = gDeathmatchRespawns[ply]["G_counter"]
				gDeathmatchRespawns[ply][Counter] = {}
				local x, y, z = getElementPosition( vehicle )
				gDeathmatchRespawns[ply][Counter]["X"] = x
				gDeathmatchRespawns[ply][Counter]["Y"] = y
				gDeathmatchRespawns[ply][Counter]["Z"] = z
				gDeathmatchRespawns[ply][Counter]["Model"] = getElementModel ( vehicle )
				local rx, ry, rz = getElementRotation ( vehicle )
				gDeathmatchRespawns[ply][Counter]["RX"] = rx
				gDeathmatchRespawns[ply][Counter]["RY"] = ry
				gDeathmatchRespawns[ply][Counter]["RZ"] = rz
				local vx, vy, vz = getElementVelocity ( vehicle )
				gDeathmatchRespawns[ply][Counter]["VX"] = vx
				gDeathmatchRespawns[ply][Counter]["VY"] = vy
				gDeathmatchRespawns[ply][Counter]["VZ"] = vz
				local tx, ty, tz = getVehicleTurnVelocity ( vehicle )
				gDeathmatchRespawns[ply][Counter]["TX"] = tx
				gDeathmatchRespawns[ply][Counter]["TY"] = ty
				gDeathmatchRespawns[ply][Counter]["TZ"] = tz
				
				local nitro	getVehicleUpgradeOnSlot ( vehicle, 8 )
				if nitro ~= false and nitro ~= 0 then
					gDeathmatchRespawns[ply][Counter]["NOS"] = true
				else
					gDeathmatchRespawns[ply][Counter]["NOS"] = false
				end
				
			else
				if getElementData(ply, "state") ~= "dead" and getElementData(ply, "state") ~= "spawning" then
					gDeathmatchRespawns[ply] = nil
				end
			end
		end
	end
end 	
setTimer(savePlayerPositionsDM, 10000, 0)

function respawnPlayerDM(player, key, keyState, start)
	if getElementData(player, "ghostmod") == false then return end
	if getElementData(player, "state")  ~= "dead" and getElementData(player, "state")  ~= "spawning" then return end
	if gIsDMRunning ~= true then return end
	if start == true then
		callClientFunction ( player, "spectateEnd", true )
		local spawn = 1
		gDeathmatchRespawns[player] = nil
		setCameraTarget ( player )
		spawnPlayer(player, gSpawnPositionsDM[spawn].posX, gSpawnPositionsDM[spawn].posY, gSpawnPositionsDM[spawn].posZ)
		setElementDimension(player, gGamemodeDM)
		local veh = createVehicle(gSpawnPositionsDM[spawn].vehicle, gSpawnPositionsDM[spawn].posX, gSpawnPositionsDM[spawn].posY, gSpawnPositionsDM[spawn].posZ, gSpawnPositionsDM[spawn].rotX, gSpawnPositionsDM[spawn].rotY, gSpawnPositionsDM[spawn].rotZ, "Vita")
		setElementDimension(veh, gGamemodeDM)
		setElementFrozen(veh, true)
		setVehicleDamageProof ( veh, true )
		warpPedIntoVehicle(player, veh)
		setElementData(veh, "isDMVeh", true)
		setElementData(player, "raceVeh", veh)
		setElementData(player, "state", "spawning")
		setElementAlpha(player, 255)
		setElementFrozen(player, true)
		addPlayerArchivement(player, 41)
		setTimer(function(player)
			setElementFrozen(getPedOccupiedVehicle(player), false)
			setElementData(player, "state", "replaying")
			setVehicleDamageProof ( getPedOccupiedVehicle(player), false )
		end, 3000,1,player)
	else
		if tostring(gDeathmatchRespawns[player]) == "nil" then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "No respawn data found.") return end
		local Counter = gDeathmatchRespawns[player]["G_counter"]
		if Counter < 1 then  triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "No respawn data found.") return end
		callClientFunction ( player, "spectateEnd", true )
		gDeathmatchRespawns[player]["G_counter"] = gDeathmatchRespawns[player]["G_counter"]-1
		setCameraTarget ( player )
		spawnPlayer(player, gDeathmatchRespawns[player][Counter]["X"], gDeathmatchRespawns[player][Counter]["Y"], gDeathmatchRespawns[player][Counter]["Z"])
		setElementDimension(player, gGamemodeDM)
		local veh = createVehicle(gDeathmatchRespawns[player][Counter]["Model"], gDeathmatchRespawns[player][Counter]["X"], gDeathmatchRespawns[player][Counter]["Y"], gDeathmatchRespawns[player][Counter]["Z"],  gDeathmatchRespawns[player][Counter]["RX"], gDeathmatchRespawns[player][Counter]["RY"], gDeathmatchRespawns[player][Counter]["RZ"], "Vita")
		setElementDimension(veh, gGamemodeDM)
		setElementFrozen(veh, true)
		warpPedIntoVehicle(player, veh)
		setElementData(veh, "isDMVeh", true)
		setVehicleDamageProof ( veh, true )
		setElementData(player, "raceVeh", veh)
		setElementAlpha(player, 255)
		setElementData(player, "state", "spawning")
		addPlayerArchivement(player, 41)

		if gDeathmatchRespawns[player][Counter]["NOS"] == true then
			addVehicleUpgrade ( veh, 1010 )
		end		
		
		setElementFrozen(player, true)
		setTimer(function(player, vx, vy, vz, tx,ty,tz)
			local veh = getPedOccupiedVehicle(player)
			if isElement(veh) then
				setElementFrozen(veh, false)
				setElementVelocity(veh, vx,vy,vz)
				setVehicleTurnVelocity(veh, tx,ty,tz)
				setVehicleDamageProof ( veh, false )
				setElementData(player, "state", "replaying")
			end
		end, 3000,1,player, gDeathmatchRespawns[player][Counter]["VX"], gDeathmatchRespawns[player][Counter]["VY"], gDeathmatchRespawns[player][Counter]["VZ"], gDeathmatchRespawns[player][Counter]["TX"], gDeathmatchRespawns[player][Counter]["TY"], gDeathmatchRespawns[player][Counter]["TZ"])	
	end
end