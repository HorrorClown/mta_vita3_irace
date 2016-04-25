function wabelwackCMD(player)
	for i,v in pairs(getElementsByType("player")) do
		if getElementData(v, "gameMode") == getElementData(player, "gameMode") then
			triggerClientEvent(v, "wabelwackClient",getRootElement())
		end
	end
end
addCommandHandler("wabelwack", wabelwackCMD)