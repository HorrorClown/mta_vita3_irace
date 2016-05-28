Core = inherit(Object)

function Core:constructor()
    -- Small hack to get the global core immediately
    core = self

    -- Instantiate the localPlayer instance right now
    enew(localPlayer, LocalPlayer)

    setAmbientSoundEnabled( "gunfire", false )
end

function Core:destructor()

end