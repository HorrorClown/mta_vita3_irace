Account = inherit(Object)

function Account.login(player, username, password)
    if (not username or not password) and not pwhash then return false end

    local userAccount = sql:queryFetchSingle("SELECT ID, password, accountname FROM players WHERE accountname = ?", username)
    if not userAccount and not userAccount.ID then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        return false
    end

    if md5(password) ~= userAccount.password then
        player:triggerEvent("addNotification", 1, 200, 50, 50, "Invalid username or password")
        return false
    end

    player.m_Account = Account:new(userAccount.ID, userAccount.accountname, player)
end
addEvent("loginPlayer", true)
addEventHandler("loginPlayer", getRootElement(), function(...) Account.login(client, ...) end)

-- Todo: Use forum account.
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

function Account:constructor(id, username, player)
    self.m_ID = id
    self.m_Username = username
    self.m_Player = player
    player.m_ID = self.m_ID

    player:load()
end