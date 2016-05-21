Player = {}
inherit(DatabasePlayer, Player)
registerElementClass("player", Player)

function Player:constructor()
    outputServerLog("Class: Player -> constructor")
end

function Player:destructor()
    self:addArchivement(37)
    self:save()

    if getPlayerGameMode(self) == 0 then return true end
    callServerFunction(gRaceModes[getPlayerGameMode(self)].quitfunc, self)
end

function Player:triggerEvent(ev, ...)
    triggerClientEvent(self, ev, self, ...)
end

function Player:addArchivement(ID)
    addPlayerArchivement(self, ID)
end