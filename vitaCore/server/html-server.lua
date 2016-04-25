--[[
Project: vitaCore
File: html-server.lua
Author(s):	Sebihunter
]]--

function htmlIsPlayerLoggedIn(accountname)
	if accountname then
		for i,v in ipairs(getElementsByType("player")) do
			if getElementData(v, "AccountName") == accountname then
				if getElementData(v, "isLoggedIn") == true then
					return true
				end
			end
		end
	end
	return false
end

function htmlGiveDonator(accountname, donatordate, money)
	if accountname and donatordate and money then
		for i,v in ipairs(getElementsByType("player")) do
			if getElementData(v, "AccountName") == accountname then
				if getElementData(v, "isLoggedIn") == true then
					setElementData(v, "donatordate", donatordate)
					setElementData(v, "isDonator", true)
					setElementData(v, "Money", getElementData(v, "Money")+money)
					return true
				end
			end
		end
	end
	return false
end