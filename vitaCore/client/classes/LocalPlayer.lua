LocalPlayer = {}
addRemoteEvents{"retrieveInfo"}

function LocalPlayer:constructor()
    self.m_LoggedIn = false

    addEventHandler("retrieveInfo", root, bind(self.Event_retrieveInfo, self))
end

function LocalPlayer:desturctor()
end

function LocalPlayer:isLoggedIn()
    return self.m_LoggedIn
end

function LocalPlayer:getID()    return self.m_ID    end

function LocalPlayer:Event_retrieveInfo(info)
    self.m_LoggedIn = true
    self.m_ID = info.ID
    self.m_Accountname = info.Accountname
    self.m_Migrated = info.Migrated

    outputChatBox(tostring(self.m_Migrated))
    if self.m_Migrated == 0 then
        addNotification(2, 220, 50, 0, "Migration available!\nType /migrate")
        self.fn_Migrate = function() MigratorGUI:new() end
        addCommandHandler("migrate", self.fn_Migrate)
    end
end