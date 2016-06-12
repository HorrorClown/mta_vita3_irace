Player = {}
inherit(DatabasePlayer, Player)
registerElementClass("player", Player)
Player.Map = {}

function Player:constructor()
    setPedStat(self, 160, 1000)
    setPedStat(self, 229, 1000)
    setPedStat(self, 230, 1000)
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


local rightTable = {["Leader"] = 6, ["CoLeader"] = 5, ["Moderator"] = 4, ["SeniorMember"] = 3, ["Member"] = 2, ["Recruit"] = 1, ["User"] = 0}
function Player:hasRights(level)
    if rightTable[self.m_Level] >= rightTable[level] then
        return true
    end

    return false
end

function Player.getFromID(id)
    return Player.Map[id]
end