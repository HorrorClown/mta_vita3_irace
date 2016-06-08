--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 06.06.2016 - Time: 23:44
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
AntiBounce = inherit(Singleton)

function AntiBounce:constructor()
    self.m_Enabled = core:get("AntiBounce", "enabled", true)
    self.m_PreventBounceUpdateDelay = false
    self.m_Colliding = false
    self.m_BouncePrevented = 0
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
	removeCommandHandler("ab", self.fn_Toggle)
    removeEventHandler("onClientPreRender", root, self.fn_PreRender)
end

function AntiBounce:toggleAntiBounce()
    self.m_Enabled = not self.m_Enabled
    core:set("AntiBounce", "enabled", self.m_Enabled)
    addNotification(2, 0, 200, 0, ("AntiBounce %s"):format(self.m_Enabled and "enabled" or "disabled"))

    if self.m_Enabled then
        addEventHandler("onClientPreRender", root, self.fn_PreRender)
    else
        removeEventHandler("onClientPreRender", root, self.fn_PreRender)
    end
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
        self:preventBounce(vehicle, normalX, normalY, normalZ)
        self.m_Colliding = true
    elseif not normalX then
        self.m_Colliding = false
    end

    if self.m_PreventBounceUpdateDelay then
        vehicle:setTurnVelocity(0, 0, 0)
        self.m_PreventBounceUpdateDelay = false
    end
end

function AntiBounce:preventBounce(vehicle, normalX, normalY, normalZ)
    local matrix = getElementMatrix(vehicle)
    local positionRight = getMatrixRight(matrix)
    local positionLeft = getMatrixLeft(matrix)
    local positionDown = getMatrixDown(matrix)
    local normVec = {-normalX, -normalY, -normalZ }

    local vx, vy, vz = getElementVelocity(vehicle)
    local velVec = {vx, vy, vz}
    normalizeVector(velVec)

    local angleNormVel = getAngle(normVec, velVec)

    local angleRight = getAngle(positionRight, normVec)
    local angleLeft = getAngle(positionLeft, normVec)
    local angleDown = getAngle(positionDown, normVec)

    local tx, ty, tz = math.abs(self.m_TurnDiffX), math.abs(self.m_TurnDiffY), math.abs(self.m_TurnDiffZ)
    if(angleRight > 75 and angleLeft > 75 and angleDown < 75 and (ty > 0.03 or tz > 0.03) and angleNormVel < 75)then
        self.m_BouncePrevented = self.m_BouncePrevented + 1
        self.m_PreventBounceUpdateDelay = true
        vehicle:setTurnVelocity(0, 0, 0)
    end
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

function getMatrixRight(m)
    return {m[1][1], m[1][2], m[1][3]}
end

function getMatrixLeft(m)
    return {-m[1][1], -m[1][2], -m[1][3]}
end

function getMatrixDown(m)
    return {-m[3][1], -m[3][2], -m[3][3]}
end

function getVectorDotProduct(vec, vec2)
    return vec[1]*vec2[1] + vec[2]*vec2[2] + vec[3]*vec2[3]
end

function getVectorLength(vec)
    return math.sqrt(vec[1]*vec[1] + vec[2]*vec[2] + vec[3]*vec[3])
end

function normalizeVector(vec)
    local length = getVectorLength(vec)
    vec[1] = vec[1] / length
    vec[2] = vec[2] / length
    vec[3] = vec[3] / length
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end


function getAngle(vec, vec2)
    return math.deg(math.acos(getVectorDotProduct(vec, vec2) / (getVectorLength(vec) * getVectorLength(vec2))))
end