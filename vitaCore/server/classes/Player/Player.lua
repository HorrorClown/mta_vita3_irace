Player = {}
inherit(DatabasePlayer, Player)
registerElementClass("player", Player)
Player.Map = {}

function Player:constructor()
    outputServerLog("Class: Player -> constructor")
end

function Player:virtual_constructor()
    self.m_ID = -1
end

function Player:destructor()
    self:addArchivement(37)
    self:save()

    if self.m_ID > 0 then
        Player.Map[self.m_ID] = nil
    end

    if getPlayerGameMode(self) == 0 then return true end
    callServerFunction(gRaceModes[getPlayerGameMode(self)].quitfunc, self)
end

function Player:triggerEvent(ev, ...)
    triggerClientEvent(self, ev, self, ...)
end

function Player:addArchivement(id)
    addPlayerArchivement(self, id)
end

function Player.getFromID(id)
    return Player.Map[id]
end