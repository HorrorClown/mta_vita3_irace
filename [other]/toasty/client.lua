local toastyTick = 0
local toastyPart = 0
local sx,sy = guiGetScreenSize ()

addEvent("toastyClient", true)
addEventHandler ("toastyClient",getRootElement(),
	function ()
		toastyTick = getTickCount ()
		toastyPart = 1
		local sound = playSound ("toasty.mp3")
		addEventHandler ("onClientRender",getRootElement(),renderToasty)
	end
)

function renderToasty ()
	if toastyPart == 1 then
		local cTick = getTickCount ()
		local delay = cTick-toastyTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx-64,sy,0,
			sx-150,sy-128,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,128,128,"toasty.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			toastyTick = cTick
			toastyPart = 2
		end
	elseif toastyPart == 2 then
		local ix = sx-150
		local iy = sy-128
		dxDrawImage (ix,iy,128,128,"toasty.png",0,0,0,tocolor(255,255,255),true)
		if toastyTick+1800<getTickCount() then
			toastyTick = getTickCount()
			toastyPart = 3
		end
	elseif toastyPart == 3 then
		local cTick = getTickCount ()
		local delay = cTick-toastyTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx-150,sy-128,0,
			sx-64,sy,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,128,128,"toasty.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			toastyTick = 0
			toastyPart = 0
			removeEventHandler ("onClientRender",getRootElement(),renderToasty)
		end
	end
end