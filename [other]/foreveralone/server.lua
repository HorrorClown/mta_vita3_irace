function foreveraloneCMD(player)
	for i,v in pairs(getElementsByType("player")) do
		if getElementData(v, "gameMode") == getElementData(player, "gameMode") then
			triggerClientEvent(v, "foreveraloneClient",getRootElement())
		end
	end
end
addCommandHandler("alone", foreveraloneCMD)