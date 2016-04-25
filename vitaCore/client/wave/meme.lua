--[[
Project: vitaCore - vitaWave
File: meme.lua
Author(s):	Sebihunter
]]--


memeNames = {
	[0] = { name = "None" },	
	[1] = { name = "Suspicious" },	
	[2] = { name = "Angry" },
	[3] = { name = "Kidding?" },
	[4] = { name = "Crying" },
	[5] = { name = "Happy" },
	[6] = { name = "Bad Pokerface" },
	[7] = { name = "Baby" },
	[8] = { name = "Hmm..." },
	[9] = { name = "Satisfied" },
	[10] = { name = "Bored" },
	[11] = { name = "Cereal" },
	[12] = { name = "Bored" },
	[13] = { name = "Bad tempered" },
	[14] = { name = "Normal" },
	[15] = { name = "Normal (female)" },
	[16] = { name = "Satan" },
	[17] = { name = "Uber Troll" },
	[18] = { name = "Satisfied" },
	[19] = { name = "Forever Alone" },
	[20] = { name = "Forever Alone" },
	[21] = { name = "Forever Alone" },
	[22] = { name = "Proud" },
	[23] = { name = "Angry Pig" },
	[24] = { name = "Determined (female)" },
	[25] = { name = "Gay" },
	[26] = { name = "Anonymous" },
	[27] = { name = "Dumb" },
	[28] = { name = "Girl" },
	[29] = { name = "Staring" },
	[30] = { name = "Staring (female)" },
	[31] = { name = "Fucked Up" },
	[32] = { name = "Dad" },
	[33] = { name = "Me Gusta" },
	[34] = { name = "Not Bad" },
	[35] = { name = "No!" },
	[36] = { name = "Cereal Dad" },
	[37] = { name = "Neutral" },
	[38] = { name = "Pedobear" },
	[39] = { name = "Sweet Jesus" },
	[40] = { name = "Sad Troll" },
	[41] = { name = "Trollface" },
	[42] = { name = "Cute" },
	[43] = { name = "Crying Blood" },
	[44] = { name = "Awesome" },
	[45] = { name = "My Little Pony" },
	[46] = { name = "Y U NO?" },
	[47] = { name = "FUUUUUU" },
	[48] = { name = "Bitch please!" },
	[49] = { name = "LOOOOOOOOOL" },
	[50] = { name = "Poker Face" },
	[51] = { name = "Dafuq" },
	[52] = { name = "Dat Face Soldier" }
}

function clickOnMeme(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( g_memegui["memelist"] )
		if row and dxGridListGetItemData (g_memegui["memelist"], row) then
			setMeme("meme", dxGridListGetItemData(g_memegui["memelist"], row))
		end
	end
end

function activateMeme ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(),"Rank") >= 30 then
			if getPlayerMoney() >= 300000 then
				setElementData(getLocalPlayer(), "memeActivated", 1)
				setPlayerMoney( getPlayerMoney() - 300000 )
				addNotification(2, 0, 200, 0, "Meme script successfully unlocked.")
			else
				addNotification(1, 200, 50, 50, "Not enough money.")
			end
		else
			addNotification(1, 200, 50, 50, "You must be atleast level 30 to buy this.")
		end
	end
end

function setMeme(commandName, number)
	number = math.floor(tonumber(number))
	if number >= 0 and number < 53 then
		if getElementData(getLocalPlayer(),"memeActivated") == 1 or getElementData(getLocalPlayer(),"isDonator") == true then
			setElementData(getLocalPlayer(), "playerMeme", number)
			updateSettings("playerMeme", tostring(number))
			addNotification(2, 0, 200, 0, "New meme set.")
		end
	end
end
addCommandHandler ( "meme", setMeme )

g_memegui = {}
g_memegui["activate"] = dxCreateButton(screenWidth/2-100,screenHeight/2+50,200,50,"Unlock",false)
addEventHandler ( "onClientDXClick", g_memegui["activate"], activateMeme, false )

g_memegui["memelist"] = dxCreateGridList(screenWidth/2-392,screenHeight/2-215,250,400)
g_memegui["setmeme"] = dxCreateButton(screenWidth/2-392,screenHeight/2+190,250,24,"Set Meme",false)
addEventHandler ( "onClientDXClick", g_memegui["setmeme"], clickOnMeme, false )

for num = 0, #memeNames do
	local row = dxGridListAddRow ( g_memegui["memelist"],  memeNames[num]["name"].." ("..num..")",  tostring(num))
end	

for i, v in pairs(g_memegui) do
	dxSetVisible(v, false)
end

function waveDrawMeme()
	if getElementData(getLocalPlayer(), "memeActivated") == 1 or getElementData(getLocalPlayer(), "isDonator") == true then
		dxSetVisible(g_memegui["setmeme"], true)
		dxSetVisible(g_memegui["memelist"], true)
		dxDrawShadowedText("Available Memes",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("In order to use a Meme just click on it's\nname in the list and press the button.\n\nYou can also use /meme [ID]\nto choose your meme while driving.\n\nIf you can't find the meme you're\nlooking for please contact us so we\ncan add it for you.",screenWidth/2-137,screenHeight/2-215, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		
		
		local row = dxGridListGetSelectedItem ( g_memegui["memelist"] )
		if row and dxGridListGetItemData (g_memegui["memelist"], row) and fileExists ("files/meme/"..dxGridListGetItemData (g_memegui["memelist"], row)..".png" ) then
			dxDrawShadowedText("Meme Preview",screenWidth/2-137,screenHeight/2-60, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
			dxDrawImage ( screenWidth/2-137,screenHeight/2-35, 105,110, "files/meme/"..dxGridListGetItemData (g_memegui["memelist"], row)..".png", 0,0,0,tocolor(255,255,255,255*waveAlpha*waveMenuAlpha) )
		end
	else
		dxSetVisible(g_memegui["activate"], true)
		dxDrawShadowedText("Welcome to the VitaRace Meme system!\n\nIn order to gain access to our meme features you must be atlaest level 30\nand have 300.000 Vero.\nDonators get instant access to all the meme functions!\n\n\nIf you are ready to unleash the power press the 'Unlock' button.\n\n\n",0,0, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "center", "center", false, false, false, true)
	end
end