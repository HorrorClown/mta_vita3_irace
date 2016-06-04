Core = inherit(Object)

function Core:constructor()
    -- Small hack to get the global core immediately
    core = self

    -- Instantiate the localPlayer instance right now
    enew(localPlayer, LocalPlayer)

    self.m_Config = ConfigXML:new("config.xml")

    setAmbientSoundEnabled( "gunfire", false )
end

function Core:destructor()

end

function Core:get(...)
    return self.m_Config:get(...)
end

function Core:set(...)
    return self.m_Config:set(...)
end