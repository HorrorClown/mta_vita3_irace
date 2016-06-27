--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 24.06.2016 - Time: 20:56
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local gamemodeDim = 2   --DD
local functions = {}
local serverScritps = {}

-- These functions will disabled and return false for security reasons
local restrictedFunction = {
    ["createResource"] = true,
    ["createElement"] = true,
    ["createTeam"] = true,
    ["createRadarArea"] = true,
}

-- These functions will not overridden to push a text into the console (is used for dev) // function whitelist
local valid = {
    ["outputChatBox"] = true,
    ["outputDebugString"] = true,
    ["addEvent"] = true,
    ["addEventHandler"] = true,
    ["triggerClientEvent"] = true,
    ["isTimer"] = true,
    ["setTimer"] = true,
    ["killTimer"] = true,
    ["getRootElement"] = true,
    ["getResourceRootElement"] = true,
    ["getThisResource"] = true,
    ["isElement"] = true,
    ["destroyElement"] = true,
    ["getElementsByType"] = true,
    ["getElementDimension"] = true,
    ["setElementDimension"] = true,
    ["getElementType"] = true,
    ["getPedOccupiedVehicle"] = true,
    ["setElementModel"] = true,
    ["getElementModel"] = true,
    ["fixVehicle"] = true,
    ["setElementCollisionsEnabled"] = true,
    ["getPlayerName"] = true,
    ["getVehicleName"] = true,
    ["isPedInVehicle"] = true,
    ["getElementData"] = true,
    ["setElementData"] = true,
    ["getElementVelocity"] = true,
    ["setElementVelocity"] = true,
    ["getElementPosition"] = true,
    ["setElementPosition"] = true,
    ["getElementRotation"] = true,
    ["setElementRotation"] = true,
    ["setElementFrozen"] = true,
    ["setVehicleTurnVelocity"] = true,
    ["getVehicleTurnVelocity"] = true,
    ["getVehicleController"] = true,
    ["getVehicleOccupant"] = true,
    ["getVehicleOccupants"] = true,
    ["setVehicleHandling"] = true,
    ["attachElements"] = true,
    ["setElementAlpha"] = true,
    ["setObjectScale"] = true,
    ["moveObject"] = true,
    ["createExplosion"] = true,

    -- defaults
    ["pairs"] = true,
    ["ipairs"] = true,
    ["tonumber"] = true,
    ["tostring"] = true,
    ["assert"] = true,
    ["error"] = true,
    ["type"] = true,
    ["unpack"] = true,
    ["setmetatable"] = true,
    ["getmetatable"] = true,
    ["rawget"] = true,
    ["getTickCount"] = true,
    ["interpolateBetween"] = true,
    ["getDistanceBetweenPoints3D"] = true,
}

-- These functions will be overridden to change the dimension to the specific gamemode
local creatorFunction = {
    ["createColTube"] = true,
    ["createColCircle"] = true,
    ["createColPolygon"] = true,
    ["createColRectangle"] = true,
    ["createColCuboid"] = true,
    ["createColSphere"] = true,
    ["createPed"] = true,
    ["createVehicle"] = true,
    ["createBlipAttachedTo"] = true,
    ["createMarker"] = true,
    ["createObject"] = true,
    ["createRadarArea"] = true,
    ["createBlip"] = true,
    ["createWater"] = true,
    ["createPickup"] = true,
}

local elementFunctions = {
    [""] = true,
}

for k, v in pairs(_G) do
    if type(v) == "function" and not valid[k] then
        table.insert(functions, k)
    end
end

for _, v in pairs(functions) do
    if creatorFunction[v] then
        _G[("_%s"):format(v)] = _G[v] --Todo: set the function pointer local

        _G[v] =
            function(...)
                local element = _G[("_%s"):format(v)](...)
                setElementDimension(element, gamemodeDim)
                return element
            end
    else
        if not restrictedFunction[v] then
            _G[("_%s"):format(v)] = _G[v]

            _G[v] =
                function(...)
                    outputDebugString(("DD: Invalid function called: '%s'"):format(v))
                    --return _G[("_%s"):format(v)](...)
                    return false
                end
        else
            _G[v] = function() return false end
        end
    end
end

addEvent("startServerMapScript")
local _addEventHandler = addEventHandler
function addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
    if eventName == "onResourceStart" then eventName = "startServerMapScript" end
    return _addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
end

local _isElement = isElement
function isElement(theValue)
    if _isElement(theValue) then
        if getElementDimension(theValue) == gamemodeDim then
            return true
        end
    end
    return false
end

local _getElementsByType = getElementsByType
function getElementsByType(theType, startat)
    local cache = {}
    for _, v in pairs(_getElementsByType(theType, startat)) do
       if isElement(v) then
           table.insert(cache, v)
       end
    end
    return cache
end

local _destroyElement = destroyElement
function destroyElement(elementToDestroy)
    if isElement(elementToDestroy) then
        return _destroyElement(elementToDestroy)
    end
    return false
end

local _getPedOccupiedVehicle = getPedOccupiedVehicle
function getPedOccupiedVehicle(thePed)
    if isElement(thePed) then
        return _getPedOccupiedVehicle(thePed)
    end
    return false
end

local _setElementModel = setElementModel
function setElementModel(theElement, model)
    if isElement(theElement) then
        return _setElementModel(theElement, model)
    end
    return false
end

local _setElementAlpha = setElementAlpha
function setElementAlpha(theElement, ...)
    if isElement(theElement) then
        return _setElementAlpha(theElement, ...)
    end
end

local _fixVehicle = fixVehicle
function fixVehicle(theVehicle)
    if isElement(theVehicle) then
        return _fixVehicle(theVehicle)
    end
    return false
end

local _setElementData = setElementData
function setElementData(theElement, key, value)
    if isElement(theElement) then
        return _setElementData(theElement, key, value, false)
    end
    return false
end

local _setElementPosition = setElementPosition
function setElementPosition(theElement, ...)
    if isElement(theElement) then
       return _setElementPosition(theElement, ...)
    end
    return false
end

local _setVehicleHandling = setVehicleHandling
function setVehicleHandling(theVehicle, ...)
    if isElement(theVehicle) then
        return _setVehicleHandling(theVehicle, ...)
    end
    return false
end

local _outputChatBox = outputChatBox
function outputChatBox(text, visibleTo, ...)
    if getElementType(visibleTo) == "player" and isElement(visibleTo) then
        return _outputChatBox(text, visibleTo, ...)
    else
        for _, player in pairs(getElementsByType("player")) do
            _outputChatBox(text, player, ...)
        end
    end
end

local _createExplosion = createExplosion
function createExplosion(x, y, z, theType, creator)
    creator = getElementsByType("player")[math.random(1, #getElementsByType("player"))]
    return _createExplosion(x, y, z, theType, creator)
end

function startDD()
    local metaXML = _xmlLoadFile("meta2.xml")
    if not metaXML then return false end

    local files = _xmlNodeGetChildren(metaXML)
    for k, v in ipairs(files) do
       if _xmlNodeGetName(v) == "file" then
           if _xmlNodeGetAttribute(v, "type") == "server" then
                local fileName = _xmlNodeGetAttribute(v, "src")
                table.insert(serverScritps, fileName)
           end
       end
    end
    _xmlUnloadFile(metaXML)

    outputDebugString("DD: Load server scripts: " .. #serverScritps)

    for _, v in ipairs(serverScritps) do
        local scriptFile = _fileOpen(v)
        local scriptContent = _fileRead(scriptFile, _fileGetSize(scriptFile))
        _fileClose(scriptFile)

        local exec, error = _loadstring(scriptContent)
        if exec then
            local bool, error = _pcall(exec)
            if not bool then outputDebugString(("DD: pcall: %s; %s"):format(tostring(bool), tostring(error))) end
        else
            outputDebugString(("DD: loadstring: %s; %s"):format(tostring(exec), tostring(error)))
        end
    end

    _triggerEvent("startServerMapScript", resourceRoot)
end
addEvent("serverStartScriptDD")
addEventHandler("serverStartScriptDD", root, startDD)
