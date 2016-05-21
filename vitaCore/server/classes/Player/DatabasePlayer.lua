DatabasePlayer = inherit(Object)

function DatabasePlayer:load()
    local userData = sql:asyncQueryFetchSingle("SELECT * FROM players WHERE ID = ?", self.m_ID)

    local donatorstring = userData.donatordate
    setElementData(self, "donatordate", donatorstring)

    if tonumber(userData.isDonator) == 1 then
        local removeDonator = false
        local donatorDate = split ( donatorstring, 46 )
        if type(donatorDate) == "table" and donatorDate[1] and donatorDate[2] and donatorDate[3] then
            local todayDate = getRealTime()
            if ( tonumber(donatorDate[3]) < todayDate.year+1900 ) or ( tonumber(donatorDate[2]) < todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 ) or ( tonumber(donatorDate[2]) <= todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 and tonumber(donatorDate[1]) < todayDate.monthday ) then
                removeDonator = true
                setElementData(self, "isDonator", false)
                self:triggerEvent("addNotification", 2, 155, 77, 77, "Your donation has expired.")
            end
        end

        if not removeDonator then
            setElementData(self, "isDonator", true)
        end
    else
        setElementData(self, "isDonator", false)
    end

    if userData.level == "Admin" then
        setPlayerTeam(self, adminTeam)
        --aclGroupAddObject(aclGetGroup("Admin"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))

        for _, ePlayer in pairs(getElementsByType"player") do
            addPlayerArchivement(ePlayer, 38)
        end
    elseif userData.level == "GlobalModerator" then
        setPlayerTeam(self, globalTeam)
        --aclGroupAddObject(aclGetGroup("SuperModerator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Moderator" then
        setPlayerTeam(self, moderatorTeam)
        --aclGroupAddObject(aclGetGroup("Moderator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "SeniorMember" then
        setPlayerTeam(self, seniorTeam)
        --aclGroupAddObject(aclGetGroup("SeniorMember"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Member" then
        setPlayerTeam(self, memberTeam)
        --aclGroupAddObject(aclGetGroup("Member"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Recruit" then
        setPlayerTeam(self, recruitTeam)
        --aclGroupAddObject(aclGetGroup("Recruit"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    else
        setElementData(self, "Level", "User")
    end

    if getPlayerTeam(self) == false and getElementData(self, "isDonator") == true then
        setPlayerTeam(self, donatorTeam)
    end

    local color = fromJSON(userData.vehcolor)
    local lightcolor = fromJSON(userData.lightcolor)
    setElementData(self, "r1", color["r1"])
    setElementData(self, "r2", color["r2"])
    setElementData(self, "g1", color["g1"])
    setElementData(self, "g2", color["g2"])
    setElementData(self, "b1", color["b1"])
    setElementData(self, "b2", color["b2"])
    setElementData(self, "rl", lightcolor["rl"])
    setElementData(self, "gl", lightcolor["gl"])
    setElementData(self, "bl", lightcolor["bl"])

    setElementData(self, "accName", username)
    setElementData(self, "winningCounter", 0)
    setElementData(self, "hunterReachedCounter", 0)
    setElementData(self, "Userid", tonumber(userData.ID))
    setElementData(self, "AccountName", userData.accountname)
    setElementData(self, "Level", userData.level)
    setElementData(self, "MemeActivated", tonumber(userData.memeActivated))
    setElementData(self, "Skin",  tonumber(userData.skin))
    setElementData(self, "Points", tonumber(userData.points))
    setElementData(self, "Rank", tonumber(userData.rank))
    setElementData(self, "Money", tonumber(userData.money))
    setElementData(self, "WonMaps", tonumber(userData.wonmaps))
    setElementData(self, "PlayedMaps", tonumber(userData.playedmaps))
    setElementData(self, "DDMaps", tonumber(userData.ddmaps))
    setElementData(self, "DMMaps", tonumber(userData.dmmaps))
    setElementData(self, "SHMaps", tonumber(userData.shmaps))
    setElementData(self, "RAMaps", tonumber(userData.ramaps))
    setElementData(self, "DDWon", tonumber(userData.ddwon))
    setElementData(self, "DMWon", tonumber(userData.dmwon))
    setElementData(self, "SHWon", tonumber(userData.shwon))
    setElementData(self, "RAWon", tonumber(userData.rawon))
    setElementData(self, "shooterkills", tonumber(userData.shooterkills))
    setElementData(self, "ddkills", tonumber(userData.ddkills))
    setElementData(self, "betCounter", tonumber(userData.betcounter))
    setElementData(self, "playedTimeCounter", tonumber(userData.playertimecounter))
    setElementData(self, "TimeOnServer", tonumber(userData.timeonserver) or 0)
    setElementData(self, "Backlights", tonumber(userData.backlights))
    setElementData(self, "JoinTime", getTimestamp())
    setElementData(self, "KM", tonumber(userData.km))
    setElementData(self, "WinningStreak", tonumber(userData.winningstreak))
    setElementData(self, "Rank", tonumber(userData.rank))
    setElementData(self, "Archivements", fromJSON(userData.archivements))
    setElementData(self, "isRandomSoundturnedON", 0)
    setElementData(self, "Bet", false)
    setElementData(self, "FPSaction", false)
    setElementData(self, "Pingaction", false)
    setElementData(self, "AFK", false)
    setElementData(self, "ghostmod", false)
    setElementData(self, "isLoggedIn", true)
    setElementData(self, "country", getPlayerCountry(client))
    setElementData(self, "usedHorn", tonumber(userData.usedHorn))

    if userData.wheels and tonumber(userData.wheels) ~= 0 then
        setElementData(self, "Wheels", tonumber(userData.wheels))
    end

    local toptimeCount = getPlayerToptimeCount(self, "DM")
    setElementData(self, "TopTimes", toptimeCount)
    setElementData(self, "TopTimeCounter", toptimeCount)

    toptimeCount = getPlayerToptimeCount(self, "RACE")
    setElementData(self, "TopTimesRA", toptimeCount)

    syncArchivmentTableForPlayer(self)

    g_playerstat[self] = {}
    g_playerstat[self]["TimeTimer"] = setTimer(
        function(player)
            if getElementData(player, "TimeOnServer") then
                setElementData(player, "TimeOnServer", getElementData(player, "TimeOnServer")+1)
            end
        end, 1000, 0, self)

    self:triggerEvent("addNotification", 2, 50, 200, 50, "Successfully logged in")
    self:triggerEvent("hideLogin")
    sendModesToClient(self)
    addPlayerArchivement(self, 1)

    local accElement = createElement("lockedAcc")
    setElementData(accElement, "name", username)
    setElementData(accElement, "player", self)

    local accElements = getElementsByType("userAccount")
    for _, accElement in ipairs(accElements) do
        if getElementData(accElement, "AccountName") == getElementData(self, "AccountName") then
            callClientFunction(getRootElement(), "updatePlayerRanks")
            setElementData(accElement, "PlayerName", _getPlayerName(self))
            setElementData(accElement, "Level", getElementData(self, "Level"))
            setElementData(self, "accElement", accElement)
        end
    end
end

function DatabasePlayer:save()
    if getElementData(self, "isLoggedIn") == true then

        local accid = getElementData(self, "Userid")
        local atable = getElementData(self, "Archivements")
        local archivements_save = toJSON(atable)

        local color = {}
        color["r1"] = getElementData(self, "r1")
        color["g1"] = getElementData(self, "g1")
        color["b1"] = getElementData(self, "b1")
        color["r2"] = getElementData(self, "r2")
        color["g2"] = getElementData(self, "g2")
        color["b2"] = getElementData(self, "b2")
        local mysqlColor = toJSON(color)

        local lightcolor = {}
        lightcolor["rl"] = getElementData(self, "rl")
        lightcolor["gl"] = getElementData(self, "gl")
        lightcolor["bl"] = getElementData(self, "bl")
        local mysqlLightcolor = toJSON(lightcolor)


        if g_playerstat and g_playerstat[self] then
            if isTimer(g_playerstat[self]["TimeTimer"])then
                killTimer(g_playerstat[self]["TimeTimer"])
            end
            g_playerstat[self] = nil
        end

        local isDonator = 0
        if getElementData(self, "isDonator") == true then
            isDonator = 1
        end

        local time = getRealTime()
        local LastActivity = tostring(time.monthday)..":"..tostring(time.month+1)..":"..tostring(time.year+1900).."/"..tostring(time.hour)..":"..tostring(time.minute)

        sql:queryExec("UPDATE players SET accountname = ?, level = ?, skin = ?, points = ?, rank = ?, money = ?, wonmaps = ?, playedmaps = ?, ddmaps = ?, dmmaps = ?, shmaps = ?, ramaps = ?, ddwon = ?, dmwon = ?, shwon = ?, rawon = ?, betcounter = ?, playedtimecounter = ?, lastactivity = NOW(), vehcolor = ?, lightcolor = ?, timeonserver = ?, toptimes = ?, toptimesra = ?, km = ?, winningstreak = ?, memeActivated = ?, ddWinrate = ?, dmWinrate = ?, shWinrate = ?, raWinrate = ?, playerName = ?, isDonator = ?, usedHorn = ?, wheels = ?, shooterkills = ?, ddkills = ?, donatordate = ?, backlights = ?, archivements = ? WHERE id = ?",
            self:getData("AccountName"), self:getData("Level"), self:getData("Skin"), self:getData("Points"), self:getData("Rank"), self:getData("Money"), self:getData("WonMaps"), self:getData("PlayedMaps"), self:getData("DDMaps"), self:getData("DMMaps"), self:getData("SHMaps"), self:getData("RAMaps"), self:getData("DDWon"), self:getData("DMWon"), self:getData("SHWon"), self:getData("RAWon"), self:getData("betCounter"), self:getData("playedTimeCounter"), mysqlColor, mysqlLightcolor, self:getData("TimeOnServer"), self:getData("TopTimes"), self:getData("TopTimesRA"), self:getData("KM"), self:getData("WinningStreak"), self:getData("memeActivated"), math.round(self:getData("DDWon")/self:getData("DDMaps")*100,2), math.round(self:getData("DMWon")/self:getData("DMMaps")*100,2), math.round(self:getData("SHWon")/self:getData("SHMaps")*100,2), math.round(self:getData("RAWon")/self:getData("RAMaps")*100,2), self.name, isDonator, self:getData("usedHorn"), self:getData("Wheels"), self:getData("shooterkills"),	self:getData("ddkills"), self:getData("donatordate"), self:getData("Backlights"), archivements_save, accid)


        local lockedAccs = getElementsByType ( "lockedAcc" )
        for theKey,lockedAcc in ipairs(lockedAccs) do
            if getElementData(lockedAcc, "name") == getElementData(self, "accName") then
                destroyElement(lockedAcc)
            end
        end

        setElementData(self, "accName", nil)
    end
end

-- Short getters TODO
function DatabasePlayer:getID()         return self.m_ID        end
function DatabasePlayer:isLoggedIn()    return self.m_ID ~= nil  end
