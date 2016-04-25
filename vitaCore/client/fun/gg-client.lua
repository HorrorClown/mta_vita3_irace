--[[
Project: Vita Ware
File: gg-client.lua
Author(s):	Sebihunter
]]--

function GGClient(toggle)
	if toggle == true then
		addEventHandler ( "onClientRender", root, GGRender )
		gunGame = true
	else
		removeEventHandler ( "onClientRender", root, GGRender )
		gunGame = false
	end
end

function GGRender ()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then return end
	if getElementData(getLocalPlayer(), "ggText") then
		dxDrawText ( getElementData(getLocalPlayer(), "ggText"), 0+1, screenHeight - 200 + 1, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 2, "default-bold", "center" ) 
		dxDrawText ( getElementData(getLocalPlayer(), "ggText"), 0, screenHeight - 200, screenWidth, screenHeight, tocolor ( 214, 219, 145, 255 ), 2, "default-bold", "center" ) 		
	end
	dxDrawImage ( screenWidth-256, screenHeight-128, 256, 128,"files/vita_gg.png" )
	if getWeaponNameFromID (getPedWeapon ( getLocalPlayer() )) ~= "Fist" and getWeaponNameFromID (getPedWeapon ( getLocalPlayer() )) ~= "Knife" then
		dxDrawText ( tostring(getWeaponNameFromID ( getPedWeapon(getLocalPlayer() ))).." ("..tostring(getPedAmmoInClip ( getLocalPlayer() )).."/"..tostring(getPedTotalAmmo ( getLocalPlayer() ))..")",screenWidth-256+160.5, screenHeight-74, screenWidth-256+250.5, screenHeight-56, tocolor(255,255,255,255), 0.8, "default-bold", "center", "center")
	else
		if getWeaponNameFromID (getPedWeapon ( getLocalPlayer() )) ~= "Knife" then
			dxDrawText ( "None",screenWidth-256+160.5, screenHeight-74, screenWidth-256+250.5, screenHeight-56, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
		else
			dxDrawText ( "Knife",screenWidth-256+160.5, screenHeight-74, screenWidth-256+250.5, screenHeight-56, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
		end
	end
	dxDrawText ( tostring(getElementData(getLocalPlayer(),"ggLevel")),screenWidth-256+160.5, screenHeight-49, screenWidth-256+185.5, screenHeight-31, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
	dxDrawImageSection ( screenWidth-256+160.5, screenHeight-22, 69*getElementHealth ( getLocalPlayer() )/100, 10, 0, 0, 69*getElementHealth ( getLocalPlayer() )/100, 10, "files/vitaprogress.png", 0, 0, 0, tocolor(255,0,0,255))			
end