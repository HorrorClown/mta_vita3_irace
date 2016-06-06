--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 06.06.2016 - Time: 23:44
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local AntiBounce = inherit(Object)

function AntiBounce:constructor()
    self.m_PreventBounceUpdateDelay = false
    self.m_Colliding = false
    self.m_TurnDiffX = 0
    self.m_TurnDiffY = 0
    self.m_TurnDiffZ = 0
    self.m_OldTurnX = 0
    self.m_OldTurnY = 0
    self.m_OldTurnZ = 0

    self.fn_Toggle = bind(self.toggleAntiBounce, self)
    self.fn_PreRender = bind(self.preRender, self)

    addCommandHandler("ab", self.fn_Toggle)
    addEventHandler("onClientPreRender", root, self.fn_PreRender)
end

function AntiBounce:destructor()

end

function AntiBounce:toggleAntiBounce()

end

function AntiBounce:vehicleCollision()


end

function AntiBounce:preRender()
    local vehicle = localPlayer:getOccupiedVehicle()
    if not vehicle then return end

    local tx, ty, tz = AntiBounce.getVehicleTurnVelocity(vehicle)
    self.m_TurnDiffX = tx - self.m_OldTurnX
    self.m_TurnDiffY = ty - self.m_OldTurnY
    self.m_TurnDiffZ = tz - self.m_OldTurnZ

    local normalX, normalY, normalZ = AntiBounce.isVehicleOnGround(vehicle)
    if normalX and not self.m_Colliding then
        AntiBounce.preventBounce(vehicle, normalX, normalY, normalZ)
        self.m_Colliding = true
    elseif not normalX then
        self.m_Colliding = false
    end

    if self.m_PreventBounceUpdateDelay then
        vehicle:setTurnVelocity(0, 0, 0)
        self.m_PreventBounceUpdateDelay = false
    end
end

function AntiBounce.preventBounce(vehicle, normalX, normalY, normalZ)

end

function AntiBounce.isVehicleOnGround(vehicle)
    local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(vehicle)

    minZ = -getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)

    local startX, startY, startZ = getPositionFromElementOffset(vehicle, minX, maxY, 0)
    local endX, endY, endZ = getPositionFromElementOffset(vehicle, minX, maxY, minZ)

    local lfWheelX,lfWheelY,lfWheelZ = getVehicleComponentPosition(localPlayer:getOccupiedVehicle(),"wheel_lf_dummy","world")

    if lfWheelX ~= false then
        startX,startY,startZ = lfWheelX,lfWheelY,lfWheelZ
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ * 0.6)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    else
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    end

    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(startX, startY, startZ, endX, endY, endZ, true, false, false, true, true, true, false, true)

    if(hit)then
        return normalX, normalY, normalZ
    end

    startX, startY, startZ = getPositionFromElementOffset(vehicle, maxX, maxY, 0)
    endX, endY, endZ = getPositionFromElementOffset(vehicle, maxX, maxY, minZ)

    local lfWheelX,lfWheelY,lfWheelZ = getVehicleComponentPosition(localPlayer:getOccupiedVehicle(),"wheel_rf_dummy","world")
    if lfWheelX ~= false then
        startX,startY,startZ = lfWheelX,lfWheelY,lfWheelZ
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ * 0.6)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    else
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    end

    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(startX, startY, startZ, endX, endY, endZ, true, false, false, true, true, true, false, true)
    if(hit)then
        return normalX, normalY, normalZ
    end

    startX, startY, startZ = getPositionFromElementOffset(vehicle, minX, minY, 0)
    endX, endY, endZ = getPositionFromElementOffset(vehicle, minX, minY, minZ)

    local lfWheelX,lfWheelY,lfWheelZ = getVehicleComponentPosition(localPlayer:getOccupiedVehicle(),"wheel_lb_dummy","world")
    if lfWheelX ~= false then
        startX,startY,startZ = lfWheelX,lfWheelY,lfWheelZ
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ * 0.6)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    else
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    end

    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(startX, startY, startZ, endX, endY, endZ, true, false, false, true, true, true, false, true)
    if(hit)then
        return normalX, normalY, normalZ
    end

    startX, startY, startZ = getPositionFromElementOffset(vehicle, maxX, minY, 0)
    endX, endY, endZ = getPositionFromElementOffset(vehicle, maxX, minY, minZ)

    local lfWheelX,lfWheelY,lfWheelZ = getVehicleComponentPosition(localPlayer:getOccupiedVehicle(),"wheel_rb_dummy","world")
    if lfWheelX ~= false then
        startX,startY,startZ = lfWheelX,lfWheelY,lfWheelZ
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ * 0.6)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    else
        local checkPos = Matrix(Vector3(startX,startY,startZ),localPlayer:getOccupiedVehicle():getRotation()):transformPosition(Vector3(0,0,-math.abs(minZ)))
        endX,endY,endZ = checkPos.x,checkPos.y,checkPos.z
    end

    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(startX, startY, startZ, endX, endY, endZ, true, false, false, true, true, true, false, true)
    if(hit)then
        return normalX, normalY, normalZ
    end

    return false
end

function AntiBounce.getVehicleTurnVelocity(vehicle)
    local turnX, turnY, turnZ = getVehicleTurnVelocity(vehicle)
    local m = getElementMatrix(vehicle)
    local tx = turnX * m[1][1] + turnY * m[1][2] + turnZ * m[1][3]
    local ty = turnX * m[2][1] + turnY * m[2][2] + turnZ * m[2][3]
    local tz = turnX * m[3][1] + turnY * m[3][2] + turnZ * m[3][3]
    return tx, ty, tz
end