--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 20.06.2016 - Time: 19:54
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
Sounds = inherit(Singleton)
--addRemoteEvents{"playWinsound", "onMapSoundReceive", "onMapSoundStop"}
addRemoteEvents{"playWinsound"}

function Sounds:constructor()
    --self.fn_MapMusicReceive = bind(self.mapMusicReceive, self)
    --self.fn_MapMusicStop = bind(self.mapMusicStop, self)

    self.fn_RemoteSoundStarted = bind(self.remoteSoundStarted, self)
    self.fn_PlayWinsound = bind(self.playWinsound, self)
    addEventHandler("playWinsound", localPlayer, self.fn_PlayWinsound)
end

function Sounds:destructor()

end

function Sounds:playWinsound(winsound)
    if localPlayer:getData("toggleWinsounds") == 1 then return end
    if self.m_Sound then return end

    if not string.find(winsound, "http") then
        winsound = ("files/winsounds/%s.mp3"):format(winsound)
        self.m_Sound = _playSound(winsound)
        if self.m_Sound then
            local length = self.m_Sound:getLength()
            self:handleMapMusic(length)
        end
    else
        addEventHandler("onClientSoundStream", root, self.fn_RemoteSoundStarted)
        self.m_Sound = _playSound(winsound)
        if not self.m_Sound then removeEventHandler("onClientSoundStream", root, self.fn_RemoteSoundStarted) end
    end
end

function Sounds:remoteSoundStarted(success, length)
    if source ~= self.m_Sound then return end
    removeEventHandler("onClientSoundStream", root, self.fn_RemoteSoundStarted)
    if success then
        self:handleMapMusic(length)
    end
end

function Sounds:handleMapMusic(length)
    gWinsound = self.m_Sound -- workaround aslong mapsound isn't handle by this class

    if isElement(gVitaMapMusic) then
        gVitaMapMusic:setPaused(true)
    end

    setTimer(
        function()
            if isElement(gVitaMapMusic) then
                gVitaMapMusic:setPaused(false)
                self.m_Sound = nil
                gWinsound = nil
            end
        end, (length+0.5)*1000, 1
    )
end