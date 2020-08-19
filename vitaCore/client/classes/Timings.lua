--
-- PewX
-- Using: IntelliJ IDEA 2020 Ultimate
-- Date: 17.08.2020 - Time: 21:43
-- pewx.de // irace-mta.de
--
Timings = inherit(Singleton)
Timings.fileString = "@:vitaCore/files/timings/%s.json"

Timings.WIDTH = 80
Timings.HEIGHT = 20
Timings.COLOR = {
    BEST = {hex = "#7769c8", rgb = tocolor(170, 10, 210)},
    PERSONAL = {hex = "#6eb446", rgb = tocolor(55, 215, 50)},
    SLOWER = {hex = "#dcbe46", rgb = tocolor(255, 200, 0)}
}

addRemoteEvents{"initTimings"}

function Timings:constructor()
    self.m_renderTarget = DxRenderTarget(Timings.WIDTH, Timings.HEIGHT)
    self.m_localTimings = {}
    self.m_Map = ""

    self.fn_initTimings = bind(self.initTimings, self)
    self.fn_render = bind(self.render, self)
    addEventHandler("initTimings", localPlayer, self.fn_initTimings)
    addEventHandler("onClientRender", root, self.fn_render)
end

function Timings:initTimings(map, globalTimings)
    self.m_Map = map
    self.m_Finished = false

    if globalTimings then
        self.m_globalTimings = table.setIndexToInteger(globalTimings)
    end

    if File.exists(Timings.fileString:format(md5(self.m_Map))) then
        local file = File.open(Timings.fileString:format(md5(self.m_Map)), true)
        local data = file:read(file.size)
        file:close()

        if data then
            local json = fromJSON(data)
            if json then
            self.m_localTimings = table.setIndexToInteger(json)
            end
        end

        return
    end

    self.m_localTimings = {}
end

function Timings:saveTimings()
    local file = File.new(Timings.fileString:format(md5(self.m_Map)))
    file:write(toJSON(self.m_localTimings))
    file:close()
end

function Timings:getTimings()
    return self.m_localTimings
end

function Timings:hitPickup(id, timePassed)
    if self.m_Finished then return end
    if id == "Hunter" then self.m_Finished = true end

    local change = false
    local globalDiff = false
    local localDiff = false

    if self.m_globalTimings and self.m_globalTimings[id] then
        globalDiff = timePassed - self.m_globalTimings[id]
    end

    if not self.m_localTimings[id] then
        self.m_localTimings[id] = timePassed
        change = true
    else
        localDiff = timePassed - self.m_localTimings[id]

        if localDiff < 0 then
            self.m_localTimings[id] = timePassed
            change = true
        end
    end

    if globalDiff and globalDiff < 0 then
        self:renderInfo(globalDiff, Timings.COLOR.BEST)
    elseif localDiff and localDiff < 0 then
        self:renderInfo(localDiff, Timings.COLOR.PERSONAL)
    elseif globalDiff and globalDiff > 0 then
        self:renderInfo(globalDiff, Timings.COLOR.SLOWER)
    elseif localDiff and localDiff > 0 then
        self:renderInfo(localDiff, Timings.COLOR.SLOWER)
    end

    if change then
        self:saveTimings()
    end
end

function Timings:renderInfo(diff, color)
    --outputChatBox((":Timings: %s%s%ss"):format(color.hex, (diff < 0 and "-" or "+"), msToTimeStr(math.abs(diff), false, true)), 255, 255, 255, true)

    self.m_renderTarget:setAsTarget(true)
    dxDrawRectangle(0, 0, Timings.WIDTH, Timings.HEIGHT, tocolor(0, 0, 0))
    dxDrawRectangle(1, 1, Timings.WIDTH - 2, Timings.HEIGHT - 2, color.rgb)
    dxDrawText(("%s%s"):format((diff < 0 and "-" or "+"), msToTimeStr(math.abs(diff), false, true)), 0, 0, Timings.WIDTH, Timings.HEIGHT, tocolor(255, 255, 255), 1, "default-bold", "center", "center", true, false, false, false, true)
    dxSetRenderTarget()

    self.m_LastInfo = getTickCount()
end

function Timings:render()
    if self.m_renderTarget and self.m_LastInfo and getTickCount() - self.m_LastInfo < 5000 then
        dxDrawImage(screenWidth/2 - Timings.WIDTH/2, 50, Timings.WIDTH, Timings.HEIGHT, self.m_renderTarget)
    end
end