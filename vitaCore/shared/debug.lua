function getDebugInfo(stack)
    local source = debug.getinfo(stack or 2).source
    local filePath
    if source:find("\\") then
        filePath = split(source, '\\')
    else
        filePath = split(source, '/')
    end
    local className = filePath[#filePath]:gsub(".lua", "")
    if not className then className = "UNKOWN" end
    return className, tostring(debug.getinfo(stack or 2).name), tostring(debug.getinfo(stack or 2).currentline)
end

function outputDebug(errmsg)
    if DEBUG then
        local className, methodName, currentline = getDebugInfo(3)
        outputDebugString(("%s [%s:%s (%s)] %s"):format(SERVER and "SERVER" or "CLIENT", className, methodName, currentline, tostring(errmsg)), 3)
    end
end

local runStringSavedVars = {}
local function prepareRunStringVars(runPlayer)
    runStringSavedVars.me = me
    runStringSavedVars.my = my
    runStringSavedVars.player = player
    runStringSavedVars.cprint = cprint
    runStringSavedVars.pastebin = pastebin
    runStringSavedVars.hastebin = hastebin

    me = runPlayer
    my = runPlayer
    player = function(target)
        return getPlayerFromPartialName(target)
    end
    cprint = function(var)
        outputConsole(inspect(var), runPlayer)
    end
    pastebin = function(id)
        if id and type(id) == "string" then
            fetchRemote("https://pastebin.com/raw/"..id, {},
                function(response, responseInfo)
                    if responseInfo.success == true then
                        loadstring(response)()
                        outputChatBox("Pastebin "..id.." successfully loaded!", runPlayer, 0, 255, 0)
                        outputDebugString("Pastebin "..id.." successfully loaded by "..runPlayer:getName().."!", 0, 0, 255, 0)
                    else
                        outputChatBox("Pastebin "..id.." failed to loaded! (Error: "..responseInfo.statusCode..")", runPlayer, 255, 0, 0)
                        outputDebugString("Pastebin "..id.."  failed to load by "..runPlayer:getName().."! (Error: "..responseInfo.statusCode..")", 0, 0, 255, 0)
                    end
                end
            )
        else
            outputChatBox("Invalid Pastebin Id!", runPlayer, 255, 0, 0)
        end
    end
    hastebin = function(id)
        if id and type(id) == "string" then
            fetchRemote("https://hastebin.com/raw/"..id, {},
                function(response, responseInfo)
                    if responseInfo.success == true then
                        loadstring(response)()
                        outputChatBox("Hastebin "..id.." successfully loaded!", runPlayer, 0, 255, 0)
                        outputDebugString("Hastebin "..id.." successfully loaded by "..runPlayer:getName().."!", 0, 0, 255, 0)
                    else
                        outputChatBox("Hastebin "..id.." failed to loaded! (Error: "..responseInfo.statusCode..")", runPlayer, 255, 0, 0)
                        outputDebugString("Hastebin "..id.."  failed to load by "..runPlayer:getName().."! (Error: "..responseInfo.statusCode..")", 0, 0, 255, 0)
                    end
                end
            )
        else
            outputChatBox("Invalid Hastebin Id!", runPlayer, 255, 0, 0)
        end
    end
end

local function restoreRunStringVars()
    me = runStringSavedVars.me
    my = runStringSavedVars.my
    cprint = runStringSavedVars.cprint
    player = runStringSavedVars.player
    pastebin = runStringSavedVars.pastebin
    hastebin = runStringSavedVars.hastebin

    runStringSavedVars = {}
end

-- Hacked in from runcode
function runString(commandstring, source, suppress)
    local sourceName, output, outputPlayer
    if getPlayerName(source) ~= "Console" then
        sourceName = getPlayerName(source)
        output = function (msg)
            if not suppress then
                if SERVER then
                    outputChatBox(msg, source, 255, 51, 51)
                    --Admin:getSingleton():sendMessage(msg, 255, 51, 51, ADMIN_RANK_PERMISSION["seeRunString"])
                else
                    outputChatBox(msg, 255, 51, 51)
                end
            end
        end
        outputPlayer = source
    else
        sourceName = "Console"
        output = function (msg)
            --Admin:getSingleton():sendMessage(msg, 255, 51, 51, ADMIN_RANK_PERMISSION["seeRunString"])
        end
        outputPlayer = nil

    end
    output(sourceName.." executed command: "..commandstring, outputPlayer)
    local notReturned
    --First we test with return
    prepareRunStringVars(outputPlayer)
    local commandFunction,errorMsg = loadstring("return "..commandstring)
    if errorMsg then
        --It failed.  Lets try without "return"
        notReturned = true
        commandFunction, errorMsg = loadstring(commandstring)
    end
    if errorMsg then
        --It still failed.  Print the error message and stop the function
        output("Error: "..errorMsg, outputPlayer)
        return
    end
    --Finally, lets execute our function
    results = { pcall(commandFunction) }
    if not results[1] then
        --It failed.
        output("Error: "..results[2], outputPlayer)
        return
    end

    if not notReturned then
        local resultsString = ""
        local first = true
        for i = 2, #results do
            if first then
                first = false
            else
                resultsString = resultsString..", "
            end
            if type(results[i]) ~= "table" then
                resultsString = resultsString..inspect(results[i])
            else
                resultsString = resultsString..tostring(results[i])
            end
        end
        if resultsString ~= "" then
            output("Command results: "..resultsString, outputPlayer)
        end
        return resultsString
    elseif not errorMsg then
        output("Command executed!", outputPlayer)
        return
    end

    restoreRunStringVars()
end

--[[
if SERVER then
    local _xmlLoadFile = xmlLoadFile
    local _xmlUnloadFile = xmlUnloadFile

    local xmlFiles = {}
    function xmlLoadFile(filePath, readOnly)
        local xml = _xmlLoadFile(filePath, readOnly)
        xmlFiles[xml] = filePath
        return xml
    end

    function xmlUnloadFile(xml)
        xmlFiles[xml] = nil
        return _xmlUnloadFile(xml)
    end

    addCommandHandler("xml", function(player)
        for k, v in pairs(xmlFiles) do
            outputConsole(v)
        end
    end)
end
]]