--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 19.05.2016 - Time: 22:22
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
Player = {}
registerElementClass("player", Player)

function Player:triggerEvent(ev, ...)
    triggerClientEvent(self, ev, self, ...)
end