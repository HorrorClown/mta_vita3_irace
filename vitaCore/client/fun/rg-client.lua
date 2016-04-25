--[[
Project: Vita Ware
File: rg-client.lua
Author(s):	Sebihunter
]]--

function RGClient(toggle)
	if toggle == true then
		addEventHandler ( "onClientRender", root, RGRender )
		rgGame = true
	else
		removeEventHandler ( "onClientRender", root, RGRender )
		rgGame = false
	end
end

function RGRender ()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then return end
	if getElementData(getLocalPlayer(), "rgText") then
		dxDrawText ( getElementData(getLocalPlayer(), "rgText"), 0+1, screenHeight - 200 + 1, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "rgText"), 0, screenHeight - 200, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 2, "default-bold", "center" ) 		
	end
	dxDrawImage ( screenWidth-256, screenHeight-128, 256, 128,"files/vita_rg.png" )
	dxDrawImageSection ( screenWidth-256+160.5, screenHeight-22, 69*getElementHealth ( getLocalPlayer() )/100, 10, 0, 0, 69*getElementHealth ( getLocalPlayer() )/100, 10, "files/vitaprogress.png", 0, 0, 0, tocolor(255,0,0,255))			
end