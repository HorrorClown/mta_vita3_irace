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
    self.m_ID = info.ID
    self.m_Accountname = info.Accountname
    self.m_LoggedIn = true
end