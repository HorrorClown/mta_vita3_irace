Account = inherit(Object)

function Account.login(player, username, password, pwhash)
    if (not username or not password) and not pwhash then return false end

    board:queryFetchSingle(Async.waitFor(self), ("SELECT userID, ingameID, username, password FROM ??_user WHERE %s = ?"):format(username:find("@") and "email" or "username"), board:getPrefix(), username)
    local boardResult = Async.wait()
    if not boardResult or not boardResult.userID then
        --player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        player:triggerEvent("loginfailed", "Invalid username or password")
        return false
    end

    if not pwhash then
        local salt = string.sub(boardResult.password, 1, 29)
        pwhash = WBBC.getDoubleSaltedHash(password, salt)
    end

    if pwhash ~= boardResult.password then
        --player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        player:triggerEvent("loginfailed", "Invalid username or password")
        return false
    end

    if boardResult.ingameID == 0 then
        -- We have to create a ingame database account

        local result, _, ID = sql:queryFetch("INSERT INTO ??_account (ForumID, AccountName, DisplayName, LastSerial, LastLogin) VALUES (?, ?, ?, ?, NOW())", sql:getPrefix(),
            boardResult.userID, boardResult.username, player.name, player.serial)

        if not result or not ID then
            player:triggerEvent("addNotification", 1, 200, 50, 50, "Internal error while creating account")
            return false
        end

        boardResult.ingameID = ID
        sql:queryExec("INSERT INTO ??_player (ID, archivements) VALUES (?, ?)", sql:getPrefix(), ID, toJSON({}))
        board:queryExec("UPDATE ??_user SET ingameID = ? WHERE userID = ?", board:getPrefix(), ID, boardResult.userID)
    end

    if Player.getFromID(boardResult.ingameID) then
        player:triggerEvent("loginfailed", "This account is already in use")
        return false
    end

    sql:queryExec("UPDATE ??_account SET LastSerial = ?, LastLogin = NOW() WHERE ID = ?", sql:getPrefix(), player.serial, boardResult.ingameID)

    player:triggerEvent("loginsuccess", pwhash)
    player.ms_Account = Account:new(boardResult.ingameID, boardResult.username, player)
    Player.Map[boardResult.ingameID] = player
end
addEvent("accountlogin", true)
addEventHandler("accountlogin", getRootElement(), function(...) Async.create(Account.login)(client, ...) end)

function Account.register()

end

function Account:constructor(id, accountname, player)
    self.m_ID = id
    self.m_Accountname = accountname
    self.m_Player = player
    player.m_ID = self.m_ID
    player.m_Accountname = self.m_Accountname

    player:load()
    player:triggerEvent("retrieveInfo", {ID = id, Accountname = accountname})
end

function Account.getNameFromId(id)
    local player = Player.getFromID(id)
    if player and isElement(player) then
        return player:getName()
    end

    local row = sql:queryFetchSingle("SELECT DisplayName FROM ??_account WHERE ID = ?", sql:getPrefix(), id)
    return row and row.DisplayName
end