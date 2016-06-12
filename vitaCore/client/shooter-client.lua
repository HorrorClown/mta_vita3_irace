--[[
Project: vitaCore
File: shooter-client.lua
Author(s):	Sebihunter
]]--


function vitaJumping()      
	if getElementData(getLocalPlayer(), "vitaJumpingAllowed") ~= true then return end
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (isVehicleOnGround( vehicle ) == true) then          
		local sx,sy,sz = getElementVelocity ( vehicle )
        setElementVelocity( vehicle ,sx, sy, sz+0.25 )
	end
end
bindKey("lshift", "down", vitaJumping)
bindKey("mouse2", "down", vitaJumping)


local shootingAllowed = true
function vitaShoot()
	if getElementData(getLocalPlayer(), "vitaShootingAllowed") ~= true or shootingAllowed == false then return end
	if isPlayerAlive(getLocalPlayer()) then
		shootingAllowed = false
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		local x,y,z = getElementPosition(theVehicle)
		local rX,rY,rZ = getElementRotation(theVehicle)
		local x = x+4*math.cos(math.rad(rZ+90))
		local y = y+4*math.sin(math.rad(rZ+90))
		createProjectile(theVehicle, 19, x, y, z, 1.0, nil)
		setTimer(function() shootingAllowed = true end, 3000, 1)
	end
end

for keyName, state in pairs(getBoundKeys("fire")) do
	bindKey(keyName, "down", vitaShoot)
end

function clientExplosion(x,y,z,theType)
	if isPlayerAlive(getLocalPlayer()) then
		local x1, y1, z1 = getElementPosition(getLocalPlayer())
		if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 10 then
			if not source or not isElement(source) or getElementType(source) == "object" then return end
			if getElementType(source) == "vehicle" and getVehicleController(source) then source = getVehicleController(source) end
			if source == getLocalPlayer() then return end
			setElementData(getLocalPlayer(), "lastCol",source)
			if lastColTimer and isTimer(lastColTimer) then killTimer(lastColTimer) end
			lastColTimer = setTimer(function()
				setElementData(getLocalPlayer(), "lastCol", false)
			end, 10000, 1)
		end
	end
end
addEventHandler("onClientExplosion",getRootElement(),clientExplosion)