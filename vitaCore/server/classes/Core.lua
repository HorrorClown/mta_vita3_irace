Core = inherit(Object)

function Core:constructor()
    outputServerLog("Initializing Core...")

    -- Small hack to get the global core immediately
    core = self

    sql = MySQL:new(MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PW, MYSQL_DB)
    --board = MySQL:new(MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PW, MYSQL_DB)
    sql:setPrefix("ir") --sync

    self:loadAccountElements()

    -- Instantiate classes (Create objects)
    PlayerManager:new()
end

function Core:destructor()
    delete(PlayerManager:getSingleton())

    delete(sql)
end

function Core:loadAccountElements()
    -- Todo: Needs improvements in further versions
    local result = sql:queryFetch("SELECT * FROM players ORDER BY id ASC")
    if result then
        for _, row in pairs(result) do
            local accElement = createElement("userAccount")
            setElementData(accElement, "AccountName", row.accountname)
            setElementData(accElement, "Points", tonumber(row.points))
            setElementData(accElement, "PlayerName", row.playerName)
            setElementData(accElement, "Level", row.level)
        end
    else
        critical_error("Failed to load accoutn elements")
    end
end