--playSound("http://staff.mp3streams.net/apresski")
playSound("http://iloveradio.de/listen5.pls")

local screenWidth,screenHeight = guiGetScreenSize()  -- Get screen resolution.
showChat ( false )

local starting = false
local round = 0

local currentTime = false

function msToTimeStr(ms)
	if not ms then
		return ''
	end
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	return minutes .. ':' .. seconds .. ':' .. centiseconds
end


function receiveCurrentTime( timeTable )
	if currentTime then return false end
    currentTime = {}
	currentTime.second = 60-timeTable.second
	currentTime.minute = 60-timeTable.minute
	currentTime.hour = 19-timeTable.hour
	
	if timeTable.hour >= 20 then
		starting = true
	end
	setTimer(function()
		if starting == true then return end
		if currentTime.hour == 0 and currentTime.minute == 0 and currentTime.second == 0 then
			starting = true
		elseif currentTime.second == 0 and currentTime.minute == 0 and currentTime.hour ~= 0 then
			currentTime.second = 59
			currentTime.minute = 59
			currentTime.hour = currentTime.hour-1
		elseif
			currentTime.second == 0 and currentTime.minute ~= 0 then
			currentTime.second = 59
			currentTime.minute = currentTime.minute - 1
		else
			currentTime.second = currentTime.second-1
		end	
	end, 1000, 0)
end
addEvent( "receiveCurrentTime", true )
addEventHandler( "receiveCurrentTime", getRootElement(), receiveCurrentTime )

addEventHandler("onClientRender", getRootElement(), function()

	dxDrawImageSection ( 0, 0, screenWidth, screenHeight, 0, 0, screenWidth, screenHeight, "bg1.png" )
	dxDrawImage ( screenWidth/2-256, screenHeight/2-256-150, 512, 512, "vitaonline_symbol.png")
	
	if starting == true then
		round = round+5
		if round == 360 then round = 0 end
		dxDrawRectangle ( screenWidth/2-200, screenHeight/2+20, 400, 50, tocolor(0,0,0,150) )
		dxDrawImage ( screenWidth/2-200, screenHeight/2+20, 50,50, "loading.png", round)
		dxDrawText ( "Vita3 is starting any second", screenWidth/2-142, screenHeight/2+20,screenWidth,screenHeight, tocolor(255,255,255,255), 2, "default-bold" )
		dxDrawText ( "please stand by...", screenWidth/2-142, screenHeight/2+25+20,screenWidth,screenHeight, tocolor(255,255,255,255), 1.5, "default-bold" )
	else
		dxDrawRectangle ( screenWidth/2-200, screenHeight/2+20, 400, 50, tocolor(0,0,0,150) )
		if currentTime then
			local d_hour
			if currentTime.hour < 10 then d_hour = "0"..tostring(currentTime.hour) else d_hour = tostring(currentTime.hour) end
			local d_minute
			if currentTime.minute < 10 then d_minute = "0"..tostring(currentTime.minute) else d_minute = tostring(currentTime.minute) end
			local d_second
			if currentTime.second < 10 then d_second = "0"..tostring(currentTime.second) else d_second = tostring(currentTime.second) end		
			
			dxDrawText ( d_hour..":"..d_minute..":"..d_second, 0, screenHeight/2+15,screenWidth,screenHeight, tocolor(255,255,255,255), 4, "default-bold", "center" )
		else
			dxDrawText ( "00:00:000", 0, screenHeight/2+15,screenWidth,screenHeight, tocolor(255,255,255,255), 4, "default-bold", "center" )
		end
	end
end)

triggerServerEvent ( "playerHere", getLocalPlayer()) 