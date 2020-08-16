local foreveraloneTick = 0
local foreveralonePart = 0
local sx,sy = guiGetScreenSize ()

addEvent("foreveraloneClient", true)
addEventHandler ("foreveraloneClient",getRootElement(),
	function ()
		foreveraloneTick = getTickCount ()
		foreveralonePart = 1
		
		local sound = playSound ("foreveralone.mp3")
		addEventHandler ("onClientRender",getRootElement(),renderforeveralone)
	end
)

function renderforeveralone ()
	if foreveralonePart == 1 then
		local cTick = getTickCount ()
		local delay = cTick-foreveraloneTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx,sy,0,
			sx-255,sy-261,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,255,261,"foreveralone.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			foreveraloneTick = cTick
			foreveralonePart = 2
		end
	elseif foreveralonePart == 2 then
		local ix = sx-255
		local iy = sy-261
		dxDrawImage (ix,iy,255,261,"foreveralone.png",0,0,0,tocolor(255,255,255),true)
		if foreveraloneTick+5500<getTickCount() then
			foreveraloneTick = getTickCount()
			foreveralonePart = 3
		end
	elseif foreveralonePart == 3 then
		local cTick = getTickCount ()
		local delay = cTick-foreveraloneTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx-255,sy-261,0,
			sx,sy,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,255,261,"foreveralone.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			foreveraloneTick = 0
			foreveralonePart = 0
			removeEventHandler ("onClientRender",getRootElement(),renderforeveralone)
		end
	end
end