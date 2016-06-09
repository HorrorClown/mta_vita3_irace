--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 09.06.2016 - Time: 00:06
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
Migration = inherit(Singleton)
addRemoteEvents{"requestMigration", "startMigration"}

function Migration:constructor()
    self.fn_MigrationRequest = bind(self.requestMigration, self)
    self.fn_MigrationStart = bind(self.startMigration, self)

    addEventHandler("requestMigration", resourceRoot, self.fn_MigrationRequest)
    addEventHandler("startMigration", resourceRoot, self.fn_MigrationStart)
end

function Migration:destructor()

end

function Migration:requestMigration(username, password)
    if not client:getMigrationState() or client:getMigrationState() == 1 then
        client:triggerEvent("migrationLoginFailed", "Account already migrated", false)
        return
    end

    if not getAccount(username) then
        client:triggerEvent("migrationLoginFailed", "Can't find your account", true)
        return
    end

    if not getAccount(username, password or false) then
        client:triggerEvent("migrationLoginFailed", "Invalid password!", true)
        return
    end

    local datas = {}
    local account = getAccount(username)

    datas.playtime = account:getData("playtime")
    datas.jointimes = account:getData("jointimes")
    datas.DMPlayed = account:getData("dmsplayed")
    datas.DDPlayed = account:getData("ddsplayed")
    datas.DMWon = account:getData("dmswon")
    datas.DDWon = account:getData("ddswon")

    client:triggerEvent("migrationLoginSuccess", datas)
end

function Migration:startMigration(username, password, doMigrate)
    if not client:getMigrationState() or client:getMigrationState() == 1 then
        client:triggerEvent("migrationLoginFailed", "Account already migrated", false)
        return
    end


    if not getAccount(username, password or false) then
        client:triggerEvent("migrationLoginFailed", "Internal error. Please contanct an Admin", false)
        return
    end

    local account = getAccount(username)

    if doMigrate.playtime then
        local oldPlaytime = client:getData("TimeOnServer")
        local newPlaytime =  oldPlaytime + account:getData("playtime")*60
        --client:setData("TimeOnServer", newPlaytime)
        outputChatBox(("Migrate playtime - Old: %s | New: %s"):format(oldPlaytime, newPlaytime))
    end

    if doMigrate.jointimes then
        local oldJointimes = client:getData("jointimes")
        local newJointimes =  oldJointimes + account:getData("jointimes")
        --client:setData("jointimes", newJointimes)
        outputChatBox(("Migrate jointimes - New: %s"):format(newJointimes))
    end

    if doMigrate.money then
        local oldMoney = client:getData("Money")
        local newMoney = oldMoney + 300000
        --client:setData("Money", newMoney)
        outputChatBox(("Migrate money - New: %s"):format(newMoney))
    end

    if doMigrate.dmstats then
        local oldDMPlayed = client:getData("DMMaps")
        local oldDMWon = client:getData("DMWon")
        local newDMPlayed = oldDMPlayed + account:getData("dmsplayed")
        local newDMWon = oldDMWon + account:getData("dmswon")
        --client:setData("DMMaps", newDMPlayed)
        --client:setData("DMWon", newDMWon)
        outputChatBox(("Migrate DMPlayed - New: %s"):format(newDMPlayed))
        outputChatBox(("Migrate DMWon - New: %s"):format(newDMWon))
    end

    if doMigrate.ddstats then
        local oldDDPlayed = client:getData("DDMaps")
        local oldDDWon = client:getData("DDWon")
        local newDDPlayed = oldDDPlayed + account:getData("ddsplayed")
        local newDDWon = oldDDWon + account:getData("ddswon")
        --client:setData("DDMaps", newDMPlayed)
        --client:setData("DDWon", newDMWon)
        outputChatBox(("Migrate DDPlayed - New: %s"):format(newDDPlayed))
        outputChatBox(("Migrate DDWon - New: %s"):format(newDDWon))
    end

    --Todo set migrated to 1.
    --Todo set accountdata to migrated (check account bevor migrate)
end