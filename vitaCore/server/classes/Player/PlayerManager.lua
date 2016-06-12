PlayerManager = inherit(Singleton)
--addRemoteEvents{"playerReady"}


function PlayerManager:constructor()
    self.m_ReadyPlayers = {}

    -- Register events
    addEventHandler("onPlayerConnect", root, bind(self.playerConnect, self))
    addEventHandler("onPlayerJoin", root, bind(self.playerJoin, self))
    addEventHandler("onPlayerQuit", root, bind(self.playerQuit, self))
    addEventHandler("playerReady", root, bind(self.playerReady, self))
end

function PlayerManager:destructor()
    for _, v in pairs(getElementsByType"player") do
        v:delete()
    end
end

-----------------------------------------
--------       Event zone       --------- --Todo
-----------------------------------------

function PlayerManager:playerConnect(name, ip, username, serial)
    --Player Class, check if serial is banned.
end

function PlayerManager:playerJoin()

end

function PlayerManager:playerQuit()

end

function PlayerManager:playerReady()
    table.insert(self.m_ReadyPlayers, client)
end