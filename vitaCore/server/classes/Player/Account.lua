Account = inherit(Object)

function Account.login(player, username, password)
    if (not username or not password) and not pwhash then return false end

    local userData = sql:queryFetchSingle("SELECT * FROM players WHERE accountname = ?", username)
    if not userData then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        return false
    end

    if md5(password) ~= userData.password then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        return false
    end

    local donatorstring = userData.donatordate
    setElementData(player, "donatordate", donatorstring)

    if tonumber(userData.isDonator) == 1 then
        local removeDonator = false
        local donatorDate = split ( donatorstring, 46 )
        if type(donatorDate) == "table" and donatorDate[1] and donatorDate[2] and donatorDate[3] then
            local todayDate = getRealTime()
            if ( tonumber(donatorDate[3]) < todayDate.year+1900 ) or ( tonumber(donatorDate[2]) < todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 ) or ( tonumber(donatorDate[2]) <= todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 and tonumber(donatorDate[1]) < todayDate.monthday ) then
                removeDonator = true
                setElementData(player, "isDonator", false)
                player:triggerEvent("addNotification", 2, 155, 77, 77, "Your donation has expired.")
            end
        end

        if not removeDonator then
            setElementData(player, "isDonator", true)
        end
    else
        setElementData(player, "isDonator", false)
    end

    if userData.level == "Admin" then
        setPlayerTeam(player, adminTeam)
        --aclGroupAddObject(aclGetGroup("Admin"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))

        for _, ePlayer in pairs(getElementsByType"player") do
            addPlayerArchivement(ePlayer, 38)
        end
    elseif userData.level == "GlobalModerator" then
        setPlayerTeam(player, globalTeam)
        --aclGroupAddObject(aclGetGroup("SuperModerator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Moderator" then
        setPlayerTeam(player, moderatorTeam)
        --aclGroupAddObject(aclGetGroup("Moderator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "SeniorMember" then
        setPlayerTeam(player, seniorTeam)
        --aclGroupAddObject(aclGetGroup("SeniorMember"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Member" then
        setPlayerTeam(player, memberTeam)
        --aclGroupAddObject(aclGetGroup("Member"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    elseif userData.level == "Recruit" then
        setPlayerTeam(player, recruitTeam)
        --aclGroupAddObject(aclGetGroup("Recruit"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
    else
        setElementData(player, "Level", "User")
    end

    if getPlayerTeam(player) == false and getElementData(player, "isDonator") == true then
        setPlayerTeam(player, donatorTeam)
    end

    local color = fromJSON(userData.vehcolor)
    local lightcolor = fromJSON(userData.lightcolor)
    setElementData(player, "r1", color["r1"])
    setElementData(player, "r2", color["r2"])
    setElementData(player, "g1", color["g1"])
    setElementData(player, "g2", color["g2"])
    setElementData(player, "b1", color["b1"])
    setElementData(player, "b2", color["b2"])
    setElementData(player, "rl", lightcolor["rl"])
    setElementData(player, "gl", lightcolor["gl"])
    setElementData(player, "bl", lightcolor["bl"])

    setElementData(player, "accName", username)
    setElementData(player, "winningCounter", 0)
    setElementData(player, "hunterReachedCounter", 0)
    setElementData(player, "Userid", tonumber(userData.ID))
    setElementData(player, "AccountName", userData.accountname)
    setElementData(player, "Level", userData.level)
    setElementData(player, "MemeActivated", tonumber(userData.memeActivated))
    setElementData(player, "Skin",  tonumber(userData.skin))
    setElementData(player, "Points", tonumber(userData.points))
    setElementData(player, "Rank", tonumber(userData.rank))
    setElementData(player, "Money", tonumber(userData.money))
    setElementData(player, "WonMaps", tonumber(userData.wonmaps))
    setElementData(player, "PlayedMaps", tonumber(userData.playedmaps))
    setElementData(player, "DDMaps", tonumber(userData.ddmaps))
    setElementData(player, "DMMaps", tonumber(userData.dmmaps))
    setElementData(player, "SHMaps", tonumber(userData.shmaps))
    setElementData(player, "RAMaps", tonumber(userData.ramaps))
    setElementData(player, "DDWon", tonumber(userData.ddwon))
    setElementData(player, "DMWon", tonumber(userData.dmwon))
    setElementData(player, "SHWon", tonumber(userData.shwon))
    setElementData(player, "RAWon", tonumber(userData.rawon))
    setElementData(player, "shooterkills", tonumber(userData.shooterkills))
    setElementData(player, "ddkills", tonumber(userData.ddkills))
    setElementData(player, "betCounter", tonumber(userData.betcounter))
    setElementData(player, "playedTimeCounter", tonumber(userData.playertimecounter))
    setElementData(player, "TimeOnServer", tonumber(userData.timeonserver) or 0)
    setElementData(player, "Backlights", tonumber(userData.backlights))
    setElementData(player, "JoinTime", getTimestamp())
    setElementData(player, "KM", tonumber(userData.km))
    setElementData(player, "WinningStreak", tonumber(userData.winningstreak))
    setElementData(player, "Rank", tonumber(userData.rank))
    setElementData(player, "Archivements", fromJSON(userData.archivements))
    setElementData(player, "isRandomSoundturnedON", 0)
    setElementData(player, "Bet", false)
    setElementData(player, "FPSaction", false)
    setElementData(player, "Pingaction", false)
    setElementData(player, "AFK", false)
    setElementData(player, "ghostmod", false)
    setElementData(player, "isLoggedIn", true)
    setElementData(player, "country", getPlayerCountry(client))
    setElementData(player, "usedHorn", tonumber(userData.usedHorn))

    if userData.wheels and tonumber(userData.wheels) ~= 0 then
       setElementData(player, "Wheels", tonumber(userData.wheels))
    end

    local toptimeCount = getPlayerToptimeCount(player, "%[DM%]")
    setElementData(player, "TopTimes", toptimeCount)
    setElementData(player, "TopTimeCounter", toptimeCount)

    toptimeCount = getPlayerToptimeCount(player, "%[RACE%]")
    setElementData(player, "TopTimesRA", toptimeCount)

    syncArchivmentTableForPlayer(player)

    g_playerstat[player] = {}
    g_playerstat[player]["TimeTimer"] = setTimer(
        function(player)
        if getElementData(player, "TimeOnServer") then
            setElementData(player, "TimeOnServer", getElementData(player, "TimeOnServer")+1)
        end
        end, 1000, 0, player)

    player:triggerEvent("addNotification", 2, 50, 200, 50, "Successfully logged in")
    player:triggerEvent("hideLogin")
    sendModesToClient(player)
    addPlayerArchivement(player, 1)

    local accElement = createElement("lockedAcc")
    setElementData(accElement, "name", username)
    setElementData(accElement, "player", player)

    local accElements = getElementsByType("userAccount")
    for _, accElement in ipairs(accElements) do
        if getElementData(accElement, "AccountName") == getElementData(player, "AccountName") then
            callClientFunction(getRootElement(), "updatePlayerRanks")
            setElementData(accElement, "PlayerName", _getPlayerName(player))
            setElementData(accElement, "Level", getElementData(player, "Level"))
            setElementData(player, "accElement", accElement)
        end
    end
end
addEvent("loginPlayer", true)
addEventHandler("loginPlayer", getRootElement(), function(...) Account.login(client, ...) end)

-- Todo: Made register available or not? Forum etc...
function Account.register(player, username, password, email)
    if not username or not password then return false end

    -- Some sanity checks on the username and password
    -- Require at least 1 letter and a length of 3
    if not username:match("[a-zA-Z]") or #username < 3 then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username")
        return false
    end

    if #password < 5 then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Password must have at least 5 characters")
        return false
    end

    -- Validate email
    if not email:match("^[%w._-]+@%w+%.%w+$") or #email > 50 then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid E-Mail")
        return false
    end

   --Todo: Check if someone uses this username already
end