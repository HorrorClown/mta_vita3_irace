local wabelwackTick = 0
local wabelwackPart = 0
local sx,sy = guiGetScreenSize ()
local anus = 1
local anusTimer = false

function changeAnus()
	if anus == 1 then anus = 2 else anus = 1 end
end

addEvent("wabelwackClient", true)
addEventHandler ("wabelwackClient",getRootElement(),
	function ()
		wabelwackTick = getTickCount ()
		wabelwackPart = 1
		
		if getElementData(getLocalPlayer(), "country") == "DE" or getElementData(getLocalPlayer(), "country") == "AT" or getElementData(getLocalPlayer(), "country") == "CH" then
			local sound = playSound ("wabelwack-ger.wav")
		else
			local sound = playSound ("wabelwack-eng.mp3")
		end
		addEventHandler ("onClientRender",getRootElement(),renderwabelwack)
		if isTimer(anusTimer) then killTimer(anusTimer) end
		
		anusTimer = setTimer(changeAnus, 500, 0)
	end
)

function renderwabelwack ()
	if wabelwackPart == 1 then
		local cTick = getTickCount ()
		local delay = cTick-wabelwackTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx-64,sy,0,
			sx-150,sy-128,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,128,128,"wabelwack.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			wabelwackTick = cTick
			wabelwackPart = 2
		end
	elseif wabelwackPart == 2 then
		local ix = sx-150
		local iy = sy-128
		if anus == 1 then
			dxDrawImage (ix,iy,128,128,"wabelwack.png",0,0,0,tocolor(255,255,255),true)
		else
			dxDrawImage (ix,iy,128,128,"wabelwack-2.png",0,0,0,tocolor(255,255,255),true)
		end
		if wabelwackTick+6000<getTickCount() then
			wabelwackTick = getTickCount()
			wabelwackPart = 3
		end
	elseif wabelwackPart == 3 then
		local cTick = getTickCount ()
		local delay = cTick-wabelwackTick
		local progress = delay/200
		local ix,iy = interpolateBetween (
			sx-150,sy-128,0,
			sx-64,sy,0,
			progress,"Linear"
		)
		dxDrawImage (ix,iy,128,128,"wabelwack.png",0,0,0,tocolor(255,255,255),true)
		if progress >= 1 then
			wabelwackTick = 0
			wabelwackPart = 0
			removeEventHandler ("onClientRender",getRootElement(),renderwabelwack)
			if isTimer(anusTimer) then killTimer(anusTimer) end
		end
	end
end