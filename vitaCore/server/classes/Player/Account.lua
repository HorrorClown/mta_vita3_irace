Account = inherit(Object)

function Account.login(player, username, password, pwhash)
    if (not username or not password) and not pwhash then return false end

    board:queryFetchSingle(Async.waitFor(self), ("SELECT userID, ingameID, username, password, banned, banReason, avatarID, disableAvatar FROM ??_user WHERE %s = ?"):format(username:find("@") and "email" or "username"), board:getPrefix(), username)
    local boardResult = Async.wait()
    if not boardResult or not boardResult.userID then
        player:triggerEvent("loginfailed", "Invalid username or password")
        return false
    end

    if not pwhash then
        local salt = string.sub(boardResult.password, 1, 29)
        pwhash = WBBC.getDoubleSaltedHash(password, salt)
		--WBBC:debugOutput({dbHash = boardResult.password, salt = salt, pwHash = pwhash})
    end

    if pwhash ~= boardResult.password then
        player:triggerEvent("loginfailed", "Invalid username or password")
        return false
    end

    if boardResult.banned == 1 then
        player:triggerEvent("loginfailed", "This Account has been banned.\nReason: " .. tostring(boardResult.banReason))
        return false
    end

    if boardResult.ingameID == 0 then
        local serialCheck = sql:queryFetchSingle("SELECT ID FROM ??_account WHERE LastSerial = ?", sql:getPrefix(), player.serial)
        if serialCheck then
            player:triggerEvent("loginfailed", "Invalid account for this serial")
            return false
        end

        local result, _, ID = sql:queryFetch("INSERT INTO ??_account (ForumID, AccountName, DisplayName, LastSerial, LastLogin) VALUES (?, ?, ?, ?, NOW())", sql:getPrefix(),
            boardResult.userID, boardResult.username, player.name, player.serial)

        if not result or not ID then
            player:triggerEvent("addNotification", 1, 200, 50, 50, "Internal error while creating account")
            return false
        end

        boardResult.ingameID = ID
        sql:queryExec("INSERT INTO ??_player (ID, archivements) VALUES (?, ?)", sql:getPrefix(), ID, toJSON({}))
        board:queryExec("UPDATE ??_user SET ingameID = ? WHERE userID = ?", board:getPrefix(), ID, boardResult.userID)

        local accElement = createElement("userAccount")
        setElementData(accElement, "AccountName", boardResult.username)
        setElementData(accElement, "PlayerName", player.name)
        setElementData(accElement, "Points", 0)
        setElementData(accElement, "Level", "User")
    end

    if Player.getFromID(boardResult.ingameID) then
        player:triggerEvent("loginfailed", "This account is already in use")
        return false
    end

    sql:queryExec("UPDATE ??_account SET LastSerial = ?, LastLogin = NOW() WHERE ID = ?", sql:getPrefix(), player.serial, boardResult.ingameID)

    if boardResult.disableAvatar == 0 then
       local result = board:queryFetchSingle("SELECT fileHash FROM ??_user_avatar WHERE avatarID = ?", board:getPrefix(), boardResult.avatarID)
        if result and result.fileHash then
            boardResult.avatarFileHash = result.fileHash
        end
    end

    player:triggerEvent("loginsuccess", pwhash, boardResult.avatarFileHash, boardResult.avatarID)
    player.ms_Account = Account:new(boardResult.ingameID, boardResult.userID, boardResult.username, player)
    Player.Map[boardResult.ingameID] = player
end
addEvent("accountlogin", true)
addEventHandler("accountlogin", getRootElement(), function(...) Async.create(Account.login)(client, ...) end)

function Account:constructor(id, forumID, accountname, player)
    self.m_ID = id
    self.m_ForumID = forumID
    self.m_Accountname = accountname
    self.m_Player = player

    player.m_ID = self.m_ID
    player.m_ForumID = self.m_ForumID
    player.m_Accountname = self.m_Accountname

    player:getMigrationState()
    player:load()
    player:triggerEvent("retrieveInfo", {ID = id, Accountname = accountname, Migrated = player.m_Migrated})
end

function Account.getNameFromID(id)
    local player = Player.getFromID(id)
    if player and isElement(player) then
        return player:getName()
    end

    local row = sql:queryFetchSingle("SELECT DisplayName FROM ??_account WHERE ID = ?", sql:getPrefix(), id)
    return row and row.DisplayName
end