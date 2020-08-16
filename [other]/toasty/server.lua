function toastyCMD(player)
	for i,v in pairs(getElementsByType("player")) do
		if getElementData(v, "gameMode") == getElementData(player, "gameMode") then
			triggerClientEvent(v, "toastyClient",getRootElement())
		end
	end
end
addCommandHandler("toasty", toastyCMD)