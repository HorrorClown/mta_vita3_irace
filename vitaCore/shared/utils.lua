function table.size(tab)
    local i = 0
    for _ in pairs(tab) do
        i = i + 1
    end
    return i
end

function table.find(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.findAll(tab, value)
    local result = {}
    for k, v in pairs(tab) do
        if v == value then
            table.insert(result, k)
        end
    end
    return result
end

function toboolean(num)
    return num ~= 0 and num ~= "0"
end

function addRemoteEvents(eventList)
    for k, v in ipairs(eventList) do
        addEvent(v, true)
    end
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end