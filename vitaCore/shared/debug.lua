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