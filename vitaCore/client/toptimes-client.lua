--[[
Project: vitaCore
File: toptimes_client.lua
Author(s):	Sebihunter
]]--

local showToptimes = false
local toptimeX = 435
local toptimeTimer = false
local toptimeTable = false

function getNameFromAccountName(accountname)
	for i,v in pairs(getElementsByType ( "userAccount" )) do
		if getElementData(v, "AccountName") == accountname then
			return getElementData(v, "PlayerName")
		end
	end
	return accountname
end

function toptimeRender()
	if showToptimes == true or showToptimes == "closing" then
		if showToptimes == true and toptimeX > 0 then
			toptimeX = toptimeX-15
		end
		if showToptimes == "closing" and toptimeX <= 435 then
			toptimeX = toptimeX+15
		elseif showToptimes == "closing" and toptimeX >= 435 then
			showToptimes = false
		end
		if toptimeTable == false then showToptimes = false return false end
		dxDrawImage(screenWidth-436+toptimeX, screenHeight/3, 512,256, "files/vitaToptimes.png",0,0,0,tocolor(255,255,255,255))
		dxDrawLine(screenWidth-352+toptimeX, screenHeight/3+45, screenWidth, screenHeight/3+45, tocolor(255,255,255,50))
		dxDrawText ( "Rank",screenWidth-345+toptimeX, screenHeight/3+50, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 0.8)
		dxDrawText ( "Time",screenWidth-310+toptimeX, screenHeight/3+50, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 0.8)
		dxDrawText ( "Player",screenWidth-230+toptimeX, screenHeight/3+50, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 0.8)
		local isInToptime = false
		for i = 1, 12, 1 do
			if toptimeTable[i] then
				if toptimeTable[i].accountname == getElementData(getLocalPlayer(), "AccountName") then
					isInToptime = true
					dxDrawText ( i..".",screenWidth-345+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
					dxDrawText ( tostring(msToTimeStr(toptimeTable[i].time)),screenWidth-305+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
					dxDrawText ( tostring(_getPlayerName(getLocalPlayer())),screenWidth-225+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left", "top",false,false,false,true)				
				else
					dxDrawText ( i..".",screenWidth-345+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left")
					dxDrawText ( tostring(msToTimeStr(toptimeTable[i].time)),screenWidth-305+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left")
					dxDrawText ( toptimeTable[i].name,screenWidth-225+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left", "top",false,false,false,true)
				end
			else
				dxDrawText ( i..".",screenWidth-345+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left")
				dxDrawText ( "-",screenWidth-305+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left")
				dxDrawText ( "-",screenWidth-225+toptimeX, screenHeight/3+50+13*i, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left")			
			end
		end
		
		if isInToptime == false and toptimeTable then
			local hasToptime = false
			if #toptimeTable > 12 then
				for i = 13,#toptimeTable, 1 do
					if toptimeTable[i].name == getElementData(getLocalPlayer(), "AccountName") then
						hasToptime = true
						dxDrawText ( i..".",screenWidth-345+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
						dxDrawText ( tostring(msToTimeStr(toptimeTable[i].time)),screenWidth-305+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
						dxDrawText ( getPlayerName(getLocalPlayer()),screenWidth-225+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
					end
				end
			end
			
			if hasToptime == false then
				dxDrawText ( "-",screenWidth-345+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
				dxDrawText ( "-",screenWidth-305+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,200,255), 1, "default-bold", "left")
				dxDrawText ( _getPlayerName(getLocalPlayer()),screenWidth-225+toptimeX, screenHeight/3+50+13*13, screenWidth, screenHeight/3+80, tocolor(255,255,255,255), 1, "default-bold", "left", "top",false,false,false,true)			
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), toptimeRender, false, "low+1")

bindKey ( "F5", "down", function(key, keyState)
	if toptimeTable == false then return false end
	if showToptimes == true then
		showToptimes = "closing"
		playSound("files/audio/swosh.mp3")
		if isTimer(toptimeTimer) then
			killTimer(toptimeTimer)
		end
	elseif showToptimes == false then
		playSound("files/audio/swosh.mp3")
		showToptimes = true
		toptimeX = 435
		toptimeTimer = setTimer(function() 
			showToptimes = "closing"
			playSound("files/audio/swosh.mp3")			
		end, 10000, 1)
	end
end )

function forceToptimesOpen()
	if showToptimes ~= true then
		playSound("files/audio/swosh.mp3")
		showToptimes = true
		toptimeX = 435
		toptimeTimer = setTimer(function() 
			showToptimes = "closing"
			playSound("files/audio/swosh.mp3")			
		end, 5000, 1)
	end
end

function setToptimeTable(ttable)
	toptimeTable = ttable
	if toptimeTable == false then return end
	for i = 1, 12, 1 do
		if toptimeTable[i] then
			toptimeTable[i].accountname = toptimeTable[i].name
			toptimeTable[i].name =  tostring(getNameFromAccountName(toptimeTable[i].name))
		end
	end
end