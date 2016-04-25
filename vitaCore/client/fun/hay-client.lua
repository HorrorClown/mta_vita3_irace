--[[
Project: Vita Ware
File: ware-client.lua
Author(s):	Sebihunter
]]--

local hayTimer
function hayClient(toggle)
	if toggle == true then
		addEventHandler ( "onClientRender", root, hayRender )
		setElementData(getLocalPlayer(), "hayLevel", 0)
		hayTimer = setTimer ( updateHay, 200, 0 )
	else
		removeEventHandler ( "onClientRender", root, hayRender )
		setElementData(getLocalPlayer(), "hayLevel", 0)
		if hayTimer and isTimer(hayTimer) then killTimer(hayTimer) end
	end
end

function updateHay()
	local x,y,z = getElementPosition( getLocalPlayer() )
	local level = math.floor(z  / 3 - 0.5)
	local localPlayerLevel = level
	if (z == 700) then
		setElementData ( getLocalPlayer(), "hayLevel", 0 )
	else
		setElementData ( getLocalPlayer(), "hayLevel", level )
	end
end

function hayRender ()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then return end
	dxDrawImage ( screenWidth-256, screenHeight-128, 256, 128,"files/vita_haystack.png" )
	dxDrawText ( tostring(getElementData(getLocalPlayer(),"hayLevel")),screenWidth-256+160.5, screenHeight-49, screenWidth-256+185.5, screenHeight-31, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
	dxDrawImageSection ( screenWidth-256+160.5, screenHeight-22, 69*getElementHealth ( getLocalPlayer() )/100, 10, 0, 0, 69*getElementHealth ( getLocalPlayer() )/100, 10, "files/vitaprogress.png", 0, 0, 0, tocolor(255,0,0,255))		
end