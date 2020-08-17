--
-- PewX
-- Using: IntelliJ IDEA 2020 Ultimate
-- Date: 17.08.2020 - Time: 21:43
-- pewx.de // irace-mta.de
--
Timings = inherit(Singleton)

addRemoteEvents{"initTimings"}

function Timings:constructor()
    self.m_Hits = {}
    self.m_Map = ""

    self.fn_initTimings = bind(self.initTimings, self)
    addEventHandler("initTimings", localPlayer, self.fn_initTimings)
end

function Timings:initTimings(map)
    self.m_Map = map
    if not self.m_Hits[map] then
        self.m_Hits[map] = {}
        outputChatBox("init timings: " .. map)
        return
    end

    outputChatBox("loaded timings: " .. map)
end

function Timings:hitPickup(id, timePassed)
    local map = self.m_Map

    if not self.m_Hits[map][id] then
        self.m_Hits[map][id] = timePassed
    else
        local lastTimeHit = self.m_Hits[map][id]
        local diff = timePassed - lastTimeHit

        if diff < 0 then
            self.m_Hits[map][id] = timePassed
        end

        if isTimer(self.m_timer) then return end
        self.m_timer = setTimer(
            function(diff)
                outputChatBox(("%s%ss"):format((diff < 0 and "-" or "+"), msToTimeStr(math.abs(diff), false, true)))
            end, 100, 1, diff
        )
    end
end

function Timings:getTimings()
    return self.m_Hits[self.m_Map]
end