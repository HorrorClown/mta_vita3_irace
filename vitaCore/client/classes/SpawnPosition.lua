--
-- PewX
-- Using: IntelliJ IDEA 2020 Ultimate
-- Date: 16.08.2020 - Time: 23:19
-- pewx.de // irace-mta.de
--
SpawnPosition = inherit(Singleton)

addRemoteEvents{"updateSpawnPositions"}

function SpawnPosition:constructor()
    self.m_Enabled = false
    self.m_Index = 0

    self.fn_SpawnPositions = bind(self.updateSpawnPositions, self)
    self.fn_OnClientMouseWheel = bind(self.mouseWheel, self)
    addEventHandler("updateSpawnPositions", localPlayer, self.fn_SpawnPositions)
    addEventHandler("onClientKey", root, self.fn_OnClientMouseWheel)
end

function SpawnPosition:updateSpawnPositions(positions, spawnId)
    if not positions then
        self.m_Enabled = false
        return
    end

    self.m_SpawnPositions = positions
    self.m_Index = spawnId
    self.m_Enabled = true
end

function SpawnPosition:mouseWheel(button)
    if not self.m_Enabled  then return end
    if button ~= "mouse_wheel_up" and button ~= "mouse_wheel_down" then return end
    if not localPlayer.vehicle then return end
    if localPlayer:getData("state") ~= "not ready" and localPlayer:getData("state") ~= "ready" then return end

    local int = button == "mouse_wheel_up" and 1 or -1

    self.m_Index = self.m_Index + int
    if self.m_Index < 1 then self.m_Index = #self.m_SpawnPositions end
    if self.m_Index > #self.m_SpawnPositions then self.m_Index = 1 end

    local spawn = self.m_SpawnPositions[self.m_Index]
    localPlayer.vehicle:setPosition(spawn.posX, spawn.posY, spawn.posZ)
    localPlayer.vehicle:setRotation(spawn.rotX, spawn.rotY, spawn.rotZ)
    setCameraTarget(localPlayer)
    playSound("files/audio/swosh.mp3")
end