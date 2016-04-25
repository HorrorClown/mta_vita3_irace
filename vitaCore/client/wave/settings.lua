--[[
Project: vitaCore - vitaWave
File: settings.lua
Author(s):	Sebihunter
]]--

showDeadAlive = 1
waterShader = true
roadShader = true
carpaintShader = true
showPlayerCarfade = 2
showAllTheMemes = true
useVitaRadar = true
showChatIcons = true
isStopSound = false
showMapInfo = true
tachoEnabled = true

tireSmoke = false
tireShader = dxCreateShader ( "files/shader/texreplace.fx" )

function initSettings()		
	local xmlRoot = xmlLoadFile("vita_settings.xml")
	if xmlRoot then
	
		local curnode = xmlFindChild(xmlRoot, "showOptionalDeadAlive", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			showDeadAlive = 0
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "showOptionalDeadAlive")
			xmlNodeSetValue(curnode, "1")
		end
		
		curnode = xmlFindChild(xmlRoot, "waterShader", 0)
		value = xmlNodeGetValue(curnode)
		if value == "0" then
			waterShader = false
			triggerEvent("waterShaderStart", getRootElement())
		end		
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "waterShader")
			xmlNodeSetValue(curnode, "1")
		end
		
		curnode = xmlFindChild(xmlRoot, "roadShader", 0)
		value = xmlNodeGetValue(curnode)
		if value == "0" then
			roadShader = false
			triggerEvent("switchRoadshine3", getRootElement())
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "roadShader")
			xmlNodeSetValue(curnode, "1")
		end
		
		curnode = xmlFindChild(xmlRoot, "carpaintShader", 0)
		value = xmlNodeGetValue(curnode)
		if value == "0" then
			carpaintShader = false
			triggerEvent("carShaderStart", getRootElement())
		end		
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "carpaintShader")
			xmlNodeSetValue(curnode, "1")
		end
		
		curnode = xmlFindChild(xmlRoot, "stopSounds", 0)
		value = xmlNodeGetValue(curnode)
		if value == "1" then
			isStopSound = true
			for k, v in ipairs(getElementsByType("sound")) do
				stopSound ( v )
			end
		end	
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "stopSounds")
			xmlNodeSetValue(curnode, "0")
		end
		
		curnode = xmlFindChild(xmlRoot, "showPlayerCarfade", 0)
		value = xmlNodeGetValue(curnode)
		if value == "0" then
			showPlayerCarfade = 0
		end	
		if value == "1" then
			showPlayerCarfade = 1
		end			
		if value == "2" then
			showPlayerCarfade = 2
		end			
		if value == "3" then
			showPlayerCarfade = 3
		end				
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "showPlayerCarfade")
			xmlNodeSetValue(curnode, "2")
		end
		
		local curnode = xmlFindChild(xmlRoot, "showAllTheMemes", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			showAllTheMemes = false
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "showAllTheMemes")
			xmlNodeSetValue(curnode, "1")
		end
		
		local curnode = xmlFindChild(xmlRoot, "useVitaRadar", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			useVitaRadar = false
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "useVitaRadar")
			xmlNodeSetValue(curnode, "1")
		end
		
		local curnode = xmlFindChild(xmlRoot, "showChatIcons", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			showChatIcons = false
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "showChatIcons")
			xmlNodeSetValue(curnode, "1")
		end		
		
		local curnode = xmlFindChild(xmlRoot, "useWinsound", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "useWinsound", tonumber(value))
		else
			setElementData(getLocalPlayer(), "useWinsound", 0)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "useWinsound")
			xmlNodeSetValue(curnode, "0")
			setElementData(getLocalPlayer(), "useWinsound", 0)
		end	
		
		local curnode = xmlFindChild(xmlRoot, "playerMeme", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "playerMeme", tonumber(value))
		else
			setElementData(getLocalPlayer(), "playerMeme", 0)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "playerMeme")
			xmlNodeSetValue(curnode, "0")
			setElementData(getLocalPlayer(), "playerMeme", 0)
		end		

		local curnode = xmlFindChild(xmlRoot, "customStatus", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			if string.len(removeColorCoding(value)) <= 15 then
				setElementData(getLocalPlayer(), "customStatus", tostring(value))
			else
				setElementData(getLocalPlayer(), "customStatus", "none")
			end
		else
			setElementData(getLocalPlayer(), "customStatus", "none")
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "customStatus")
			xmlNodeSetValue(curnode, "none")
			setElementData(getLocalPlayer(), "customStatus", "none")
		end				
		
		local curnode = xmlFindChild(xmlRoot, "customWintext", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "customWintext", tostring(value))
		else
			setElementData(getLocalPlayer(), "customWintext", "none")
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "customWintext")
			xmlNodeSetValue(curnode, "none")
			setElementData(getLocalPlayer(), "customWintext", "none")
		end		
		
		local curnode = xmlFindChild(xmlRoot, "toggleWinsounds", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "toggleWinsounds", tonumber(value))
		else
			setElementData(getLocalPlayer(), "toggleWinsounds", 1)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "toggleWinsounds")
			xmlNodeSetValue(curnode, "1")
			setElementData(getLocalPlayer(), "toggleWinsounds", 1)
		end		
		
		local curnode = xmlFindChild(xmlRoot, "toggleHorns", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "toggleHorns", tonumber(value))
		else
			setElementData(getLocalPlayer(), "toggleHorns", 1)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "toggleHorns")
			xmlNodeSetValue(curnode, "1")
			setElementData(getLocalPlayer(), "toggleHorns", 1)
		end		

		local curnode = xmlFindChild(xmlRoot, "mapCamera", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			setElementData(getLocalPlayer(), "mapCamera", false)
		else
			setElementData(getLocalPlayer(), "mapCamera", true)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "mapCamera")
			xmlNodeSetValue(curnode, "1")
			setElementData(getLocalPlayer(), "mapCamera", true)
		end		
		local curnode = xmlFindChild(xmlRoot, "mapInfo", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			showMapInfo = false
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "mapInfo")
			xmlNodeSetValue(curnode, "1")
		end		
		local curnode = xmlFindChild(xmlRoot, "tachoEnabled", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "0" then
			tachoEnabled = false
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "tachoEnabled")
			xmlNodeSetValue(curnode, "1")
		end	

		local curnode = xmlFindChild(xmlRoot, "language", 0)
		local value = xmlNodeGetValue(curnode)
		if value then
			setElementData(getLocalPlayer(), "language", tonumber(value))
		else
			setElementData(getLocalPlayer(), "language", 1)
		end	
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "language")
			xmlNodeSetValue(curnode, "1")
		end			
		
		local curnode = xmlFindChild(xmlRoot, "tireSmoke", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "1" then
			tireSmoke = true
		else
			local smoke = dxCreateTexture("files/shader/zaa.png")
			dxSetShaderValue(tireShader,"gTexture",smoke)
			engineApplyShaderToWorldTexture(tireShader,"collisionsmoke")			
			tireSmoke = false
		end	
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "tireSmoke")
			xmlNodeSetValue(curnode, "1")
			tireSmoke = true
		end	
		local curnode = xmlFindChild(xmlRoot, "disableMusic", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "1" then
			setElementData(getLocalPlayer(), "disableMusic", true)
		else
			setElementData(getLocalPlayer(), "disableMusic", false)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "disableMusic")
			xmlNodeSetValue(curnode, "0")
		end		
		
		local hasDisco = false
		local curnode = xmlFindChild(xmlRoot, "discoColor", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "1" then
			hasDisco = true
			setElementData(getLocalPlayer(), "discoColor", true)
			setElementData(g_donatorgui["toggle_discocolor"], "text", "Disco Color: On")
		else
			setElementData(getLocalPlayer(), "discoColor", false)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "discoColor")
			xmlNodeSetValue(curnode, "0")
		end		
		local curnode = xmlFindChild(xmlRoot, "rainbowColor", 0)
		local value = xmlNodeGetValue(curnode)
		if value == "1" and hasDisco == false then
			setElementData(getLocalPlayer(), "rainbowColor", true)
			setElementData(g_donatorgui["toggle_rainbowcolor"], "text", "Rainbow Color: On")
		else
			setElementData(getLocalPlayer(), "rainbowColor", false)
		end
		if not curnode then
			curnode = xmlCreateChild(xmlRoot, "rainbowColor")
			xmlNodeSetValue(curnode, "0")
		end				
	else
		xmlRoot = xmlCreateFile("vita_settings.xml", "settings")
		local curnode = xmlCreateChild(xmlRoot, "showOptionalDeadAlive")
		xmlNodeSetValue(curnode, "1")
		curnode = xmlCreateChild(xmlRoot, "waterShader")
		xmlNodeSetValue(curnode, "1")
		curnode = xmlCreateChild(xmlRoot, "roadShader")
		xmlNodeSetValue(curnode, "1")			
		curnode = xmlCreateChild(xmlRoot, "carpaintShader")
		xmlNodeSetValue(curnode, "1")	
		curnode = xmlCreateChild(xmlRoot, "stopSounds")
		xmlNodeSetValue(curnode, "0")
		curnode = xmlCreateChild(xmlRoot, "showPlayerCarfade")
		xmlNodeSetValue(curnode, "1")	
		curnode = xmlCreateChild(xmlRoot, "showAllTheMemes")
		xmlNodeSetValue(curnode, "1")	
		curnode = xmlCreateChild(xmlRoot, "useVitaRadar")
		xmlNodeSetValue(curnode, "1")		
		curnode = xmlCreateChild(xmlRoot, "showChatIcons")
		xmlNodeSetValue(curnode, "1")
		curnode = xmlCreateChild(xmlRoot, "useWinsound")
		xmlNodeSetValue(curnode, "0")		
		curnode = xmlCreateChild(xmlRoot, "playerMeme")
		xmlNodeSetValue(curnode, "0")		
		curnode = xmlCreateChild(xmlRoot, "customStatus")
		xmlNodeSetValue(curnode, "none")		
		curnode = xmlCreateChild(xmlRoot, "customWintext")
		xmlNodeSetValue(curnode, "none")
		curnode = xmlCreateChild(xmlRoot, "toggleWinsounds")
		xmlNodeSetValue(curnode, "1")			
		curnode = xmlCreateChild(xmlRoot, "toggleHorns")
		xmlNodeSetValue(curnode, "1")				
		curnode = xmlCreateChild(xmlRoot, "mapCamera")
		xmlNodeSetValue(curnode, "1")			
		curnode = xmlCreateChild(xmlRoot, "mapInfo")
		xmlNodeSetValue(curnode, "1")		
		curnode = xmlCreateChild(xmlRoot, "tachoEnabled")
		xmlNodeSetValue(curnode, "1")		
		curnode = xmlCreateChild(xmlRoot, "language")
		xmlNodeSetValue(curnode, "1")			
		curnode = xmlCreateChild(xmlRoot, "tireSmoke")
		xmlNodeSetValue(curnode, "1")			
		curnode = xmlCreateChild(xmlRoot, "disableMusic")
		xmlNodeSetValue(curnode, "0")		
		curnode = xmlCreateChild(xmlRoot, "discoColor")
		xmlNodeSetValue(curnode, "0")				
		curnode = xmlCreateChild(xmlRoot, "rainbowColor")
		xmlNodeSetValue(curnode, "0")			
	end
	
	xmlSaveFile(xmlRoot)
	xmlUnloadFile(xmlRoot)
end

function updateSettings(setting, value)
	local xmlRoot = xmlLoadFile("vita_settings.xml")
	if xmlRoot then
		local curnode = xmlFindChild(xmlRoot, tostring(setting), 0)
		xmlNodeSetValue(curnode, tostring(value))	
	end
	xmlSaveFile(xmlRoot)
	xmlUnloadFile(xmlRoot)
end

function switchDeadAlive ( button )
	if button == "left" then
		if showDeadAlive == 0 then
			updateSettings("showOptionalDeadAlive", "1")
			showDeadAlive = 1
			addNotification(2, 153, 102, 150, "Dead/Alive counter turned on.")
		else
			updateSettings("showOptionalDeadAlive", "0")
			showDeadAlive = 0
			addNotification(2, 153, 102, 150, "Dead/Alive counter turned off.")
		end
	end
end

function toggleTireSmoke ( button)
	if button == "left" then
		if tireSmoke == true then
			local smoke = dxCreateTexture("files/shader/zaa.png")
			dxSetShaderValue(tireShader,"gTexture",smoke)
			engineApplyShaderToWorldTexture(tireShader,"collisionsmoke")	
			addNotification(2, 153, 102, 150, "Tire somke turned off.")
			tireSmoke = false
			updateSettings("tireSmoke", "0")
		else
			engineRemoveShaderFromWorldTexture(tireShader,"collisionsmoke")
			addNotification(2, 153, 102, 150, "Tire somke turned on.")
			updateSettings("tireSmoke", "1")
			tireSmoke = true
		end
	end
end

function toggleWatershader ( button )
	if button == "left" then
		triggerEvent("waterShaderStart", getRootElement())
		if waterShader == true then
			updateSettings("waterShader", "0")
			waterShader = false
			addNotification(2, 153, 102, 150, "Water shader turned off.")
		else
			updateSettings("waterShader", "1")
			waterShader = true
			addNotification(2, 153, 102, 150, "Water shader turned on.")
		end
	end
end

function toggleRoadshine ( button )
	if button == "left" then
		triggerEvent("switchRoadshine3", getRootElement())
		if roadShader == true then
			updateSettings("roadShader", "0")
			roadShader = false
			addNotification(2, 153, 102, 150, "Roadshine shader turned off.")
		else
			updateSettings("roadShader", "1")
			roadShader = true
			addNotification(2, 153, 102, 150, "Roadshine shader turned on.")
		end
	end
end

function toggleCarpaint ( button )
	if button == "left" then
		triggerEvent("carShaderStart", getRootElement())
		if carpaintShader == true then
			updateSettings("carpaintShader", "0")
			carpaintShader = false
			addNotification(2, 153, 102, 150, "Carpaint shader turned off.")
		else
			updateSettings("carpaintShader", "1")
			carpaintShader = true
			addNotification(2, 153, 102, 150, "Carpaint shader turned on.")
		end
	end
end

function toggleCarfadeMode ( button )
	if button == "left" then
		if showPlayerCarfade == 0 then
			updateSettings("showPlayerCarfade", "1")
			showPlayerCarfade = 1
			addNotification(2, 153, 102, 150, "Carfade: classic mode.")
		elseif showPlayerCarfade == 1 then
			updateSettings("showPlayerCarfade", "2")
			showPlayerCarfade = 2
			addNotification(2, 153, 102, 150, "Carfade: extended mode.")
		elseif showPlayerCarfade == 2 then
			updateSettings("showPlayerCarfade", "3")
			showPlayerCarfade = 3
			addNotification(2, 153, 102, 150, "Carfade: hide all.")		
		else
			updateSettings("showPlayerCarfade", "0")
			showPlayerCarfade = 0
			addNotification(2, 153, 102, 150, "Cafade: turned off.")
		end
	end
end

function toggleCarfadeModeKey()
	toggleCarfadeMode ( "left" )
end

bindKey("F2", "down", toggleCarfadeModeKey)

function toggleMemes ( button )
	if button == "left" then
		if showAllTheMemes == true then
			showAllTheMemes = false
			updateSettings("showAllTheMemes", "0")
			addNotification(2, 153, 102, 150, "Memes turned off.")
		else
			showAllTheMemes = true
			updateSettings("showAllTheMemes", "1")
			addNotification(2, 153, 102, 150, "Memes turned on.")
		end
	end
end

function toggleVitaRadar ( button )
	if button == "left" then
		if useVitaRadar == true then
			useVitaRadar = false
			updateSettings("useVitaRadar", "0")
			addNotification(2, 153, 102, 150, "Custom radar turned off.")
		else
			useVitaRadar = true
			updateSettings("useVitaRadar", "1")
			addNotification(2, 153, 102, 150, "Curstom Radar turned on.")
		end
	end
end

function toggleVitaWinsound ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(), "toggleWinsounds") == 1 then
			setElementData(getLocalPlayer(), "toggleWinsounds", 0)
			updateSettings("toggleWinsounds", "0")
			addNotification(2, 153, 102, 150, "Winsounds turned off.")
		else
			setElementData(getLocalPlayer(), "toggleWinsounds", 1)
			updateSettings("toggleWinsounds", "1")
			addNotification(2, 153, 102, 150, "Winsounds turned on.")
		end
	end
end

function toggleMapCamera ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(), "mapCamera") == true then
			setElementData(getLocalPlayer(), "mapCamera", false)
			updateSettings("mapCamera", "0")
			addNotification(2, 153, 102, 150, "Mapstart camera turned off.")
		else
			setElementData(getLocalPlayer(), "mapCamera", true)
			updateSettings("mapCamera", "1")
			addNotification(2, 153, 102, 150, "Mapstart camera turned on.")
		end
	end
end

function toggleVitaHorn ( button )
	if button == "left" then
		if getElementData(getLocalPlayer(), "toggleHorns") == 1 then
			setElementData(getLocalPlayer(), "toggleHorns", 0)
			updateSettings("toggleHorns", "0")
			addNotification(2, 153, 102, 150, "Horns turned off.")
		else
			setElementData(getLocalPlayer(), "toggleHorns", 1)
			updateSettings("toggleHorns", "1")
			addNotification(2, 153, 102, 150, "Horns turned on.")
		end
	end
end

function toggleVitaChaticons ( button )
	if button == "left" then
		if showChatIcons == true then
			showChatIcons = false
			updateSettings("showChatIcons", "0")
			addNotification(2, 153, 102, 150, "Chaticons turned off.")
		else
			showChatIcons = true
			updateSettings("showChatIcons", "1")
			addNotification(2, 153, 102, 150, "Chaticons turned on.")
		end
	end
end

function toggleVitaMapinfo ( button )
	if button == "left" then
		if showMapInfo == true then
			showMapInfo = false
			updateSettings("mapInfo", "0")
			addNotification(2, 153, 102, 150, "Map information turned off.")
		else
			showMapInfo = true
			updateSettings("mapInfo", "1")
			addNotification(2, 153, 102, 150, "Map information turned on.")
		end
	end
end

function toggleVitaTacho ( button )
	if button == "left" then
		if tachoEnabled == true then
			tachoEnabled = false
			updateSettings("tachoEnabled", "0")
			addNotification(2, 153, 102, 150, "Speedometer enabled.")
		else
			tachoEnabled = true
			updateSettings("tachoEnabled", "1")
			addNotification(2, 153, 102, 150, "Speedometer disabled.")
		end
	end
end

function stopsounds (player, commandname )
	if isStopSound == false then
		addNotification(3, 200, 150, 100, "Sounds disabled.")
		isStopSound = true
		updateSettings("stopSounds", "1")
		for k, v in ipairs(getElementsByType("sound")) do
			stopSound ( v )
		end
	else
		isStopSound = false
		updateSettings("stopSounds", "0")
		addNotification(3, 200, 150, 100, "Sounds enabled.")
	end
end
addCommandHandler ( "stopsound", stopsounds )

function toggleVitaMusic ( button )
	if button == "left" or button == "m" then
		if getElementData(getLocalPlayer(), "disableMusic") == true then
			setElementData(getLocalPlayer(), "disableMusic", false)
			updateSettings("disableMusic", "0")
			addNotification(2, 153, 102, 150, "Mapmusic enabled.")
			if isElement(gVitaMapMusic) then setSoundPaused(gVitaMapMusic, false) end
		else
			setElementData(getLocalPlayer(), "disableMusic", true)
			updateSettings("disableMusic", "1")
			addNotification(2, 153, 102, 150, "Mapmusic disabled.")
			if isElement(gVitaMapMusic) then setSoundPaused(gVitaMapMusic, true) end
		end
	end
end

function toggleVitaLanguage(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( g_settingsgui["tabSettingsLangList"] )
		if dxGridListGetItemData (g_settingsgui["tabSettingsLangList"], row) then
			addNotification(2, 153, 102, 150, "Language set to "..gSupportedLanguages[dxGridListGetItemData (g_settingsgui["tabSettingsLangList"], row)]..".")
			setElementData(getLocalPlayer(), "language", dxGridListGetItemData (g_settingsgui["tabSettingsLangList"], row))
			updateSettings("language", tostring(dxGridListGetItemData (g_settingsgui["tabSettingsLangList"], row)))
		end
	end
end

addEventHandler("onClientSoundStream",getRootElement(), function ( ) 
	if isStopSound == true then
		setSoundVolume ( source, 0 ) 
	end
end )

--Settings GUI
g_settingsgui = {}
settingsBox = guiCreateComboBox ( screenWidth/2+212, screenHeight/2+200, 180, 90, "", false )
guiComboBoxAddItem( settingsBox, "Settings #1" )
guiComboBoxAddItem( settingsBox, "Settings #2" )
guiComboBoxAddItem( settingsBox, "Settings #3" )
guiComboBoxSetSelected ( settingsBox, 0 )
guiSetVisible(settingsBox, false)

g_settingsgui["tabSettingsWater"] = dxCreateButton(screenWidth/2+253,screenHeight/2-239,139,24,"Toggle Watershader",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsWater"], toggleWatershader, false ) 
g_settingsgui["tabSettingsRoadshine"] = dxCreateButton(screenWidth/2+253,screenHeight/2-184,139,24,"Toggle Roadshine",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsRoadshine"], toggleRoadshine, false )
g_settingsgui["tabSettingsCarpaint"] = dxCreateButton(screenWidth/2+253,screenHeight/2-129,139,24,"Toggle Carpaint",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsCarpaint"], toggleCarpaint, false ) 
g_settingsgui["tabSettingsCarfade"] = dxCreateButton(screenWidth/2+253,screenHeight/2-74,139,24,"Toggle Carfade",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsCarfade"], toggleCarfadeMode, false ) 
g_settingsgui["tabSettingsRadar"] = dxCreateButton(screenWidth/2+253,screenHeight/2-19,139,24,"Toggle Radar",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsRadar"], toggleVitaRadar, false ) 
g_settingsgui["tabSettingsWinsound"] = dxCreateButton(screenWidth/2+253,screenHeight/2+36,139,24,"Toggle Winsounds",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsWinsound"], toggleVitaWinsound, false ) 
g_settingsgui["tabSettingsSounds"] = dxCreateButton(screenWidth/2+253,screenHeight/2+91,139,24,"Toggle Sounds",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsSounds"], stopsounds, false ) 
	
g_settingsgui["tabSettingsDeadAlive"] = dxCreateButton(screenWidth/2+253,screenHeight/2-239,139,24,"Toggle Dead/Alive",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsDeadAlive"], switchDeadAlive, false ) 		
g_settingsgui["tabSettingsMemes"] = dxCreateButton(screenWidth/2+253,screenHeight/2-184,139,24,"Toggle Memes",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsMemes"], toggleMemes, false ) 
g_settingsgui["tabSettingsHorns"] = dxCreateButton(screenWidth/2+253,screenHeight/2-129,139,24,"Toggle Horns",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsHorns"], toggleVitaHorn, false ) 
g_settingsgui["tabSettingsCamera"] = dxCreateButton(screenWidth/2+253,screenHeight/2-74,139,24,"Toggle Camera",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsCamera"], toggleMapCamera, false ) 
g_settingsgui["tabSettingsChaticons"] = dxCreateButton(screenWidth/2+253,screenHeight/2-19,139,24,"Toggle Chaticons",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsChaticons"], toggleVitaChaticons, false ) 
g_settingsgui["tabSettingsMapinfo"] = dxCreateButton(screenWidth/2+253,screenHeight/2+36,139,24,"Toggle Mapinfo",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsMapinfo"], toggleVitaMapinfo, false )
g_settingsgui["tabSettingsTacho"] = dxCreateButton(screenWidth/2+253,screenHeight/2+91,139,24,"Toggle Speedometer",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsTacho"], toggleVitaTacho, false ) 

g_settingsgui["tabSettingsLangList"] = dxCreateGridList(screenWidth/2-392,screenHeight/2-215,120,140)
g_settingsgui["tabSettingsLangSet"] = dxCreateButton(screenWidth/2-262,screenHeight/2-99,139,24,"Change Language",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsLangSet"], toggleVitaLanguage, false ) 
g_settingsgui["tabSettingsSmoke"] = dxCreateButton(screenWidth/2+253,screenHeight/2-74,139,24,"Toggle Tire Smoke",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsSmoke"], toggleTireSmoke, false ) 
g_settingsgui["tabSettingsMusic"] = dxCreateButton(screenWidth/2+253,screenHeight/2-19,139,24,"Toggle Mapmusic",false)
addEventHandler ( "onClientDXClick", g_settingsgui["tabSettingsMusic"], toggleVitaMusic, false ) 

for i,v in ipairs(gSupportedLanguages) do
	dxGridListAddRow ( g_settingsgui["tabSettingsLangList"], v, i)
end

for i, v in pairs(g_settingsgui) do
	dxSetVisible(v, false)
end

function waveDrawSettings()
	if guiComboBoxGetSelected ( settingsBox) == -1 then guiComboBoxSetSelected ( settingsBox, 0 ) end
	if guiComboBoxGetSelected ( settingsBox ) == 0 then
		local onOffMessage = "#FF0000off"
		if waterShader == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Watershader",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("By enabling this shader your water will be rendered in a better quality.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxSetVisible(g_settingsgui["tabSettingsWater"], true)
		
		onOffMessage = "#FF0000off"
		if roadShader == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Roadshine",screenWidth/2-392,screenHeight/2-185, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("This shader adds sun reflection to the roads to make them look more realistic.",screenWidth/2-392,screenHeight/2-165, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-150, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		dxSetVisible(g_settingsgui["tabSettingsRoadshine"], true)
			
		onOffMessage = "#FF0000off"
		if carpaintShader == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Carpaint",screenWidth/2-392,screenHeight/2-130, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Reflections are added to give the car paint a better look by enabling this shader.",screenWidth/2-392,screenHeight/2-110, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-95, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsCarpaint"], true)
			
		onOffMessage = "#FF0000off"
		if showPlayerCarfade == 1 then onOffMessage = "#00FF00classic mode" end
		if showPlayerCarfade == 2 then onOffMessage = "#00FF00extended mode" end
		if showPlayerCarfade == 3 then onOffMessage = "#00FF00hide all" end
		dxDrawShadowedText("Carfade",screenWidth/2-392,screenHeight/2-75, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Enabling this function makes other players hidden when they are close to your vehicle.",screenWidth/2-392,screenHeight/2-55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently set to "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-40, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxSetVisible(g_settingsgui["tabSettingsCarfade"], true)
			
		onOffMessage = "#FF0000off"
		if useVitaRadar == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Custom Minimap",screenWidth/2-392,screenHeight/2-20, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("This enables a fancy new minimap instead of the original GTA one.",screenWidth/2-392,screenHeight/2, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsRadar"], true)
		
		onOffMessage = "#FF0000off"
		if getElementData(getLocalPlayer(), "toggleWinsounds") == 1 then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Winsounds",screenWidth/2-392,screenHeight/2+35, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("With this you can chose if you want to hear the winsound of a donator if he wins a map.",screenWidth/2-392,screenHeight/2+55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+70, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsWinsound"], true)

		onOffMessage = "#FF0000off"
		if isStopSound == false then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Scriptsounds",screenWidth/2-392,screenHeight/2+90, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("When this is disabled you will not hear any sounds played by the Vita3 script.",screenWidth/2-392,screenHeight/2+110, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+125, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsSounds"], true)
			
	elseif guiComboBoxGetSelected ( settingsBox ) == 1 then
		
		local onOffMessage = "#FF0000off"
		if showDeadAlive == 1 then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Dead/Alive Counter",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("When turned on this shows information about alive and dead players at the top of the screen.",screenWidth/2-392,screenHeight/2-220, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-205, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxSetVisible(g_settingsgui["tabSettingsDeadAlive"], true)
		
		onOffMessage = "#FF0000off"
		if showAllTheMemes == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Memes",screenWidth/2-392,screenHeight/2-185, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Turning this feature on draws memes instead of a players head if he bought that feature.",screenWidth/2-392,screenHeight/2-165, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-150, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		dxSetVisible(g_settingsgui["tabSettingsMemes"], true)

		onOffMessage = "#FF0000off"
		if getElementData(getLocalPlayer(), "toggleHorns") == 1 then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Horns",screenWidth/2-392,screenHeight/2-130, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Some players bought special horns to annoy others. With this you can turn them on or off.",screenWidth/2-392,screenHeight/2-110, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-95, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		dxSetVisible(g_settingsgui["tabSettingsHorns"], true)
		
		onOffMessage = "#FF0000off"
		if getElementData(getLocalPlayer(), "mapCamera") == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Mapstart camera",screenWidth/2-392,screenHeight/2-75, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("This function toggles whether you see a fancy camera animation at each mapstart or not.",screenWidth/2-392,screenHeight/2-55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-40, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		dxSetVisible(g_settingsgui["tabSettingsCamera"], true)	

		onOffMessage = "#FF0000off"
		if showChatIcons == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Chaticons",screenWidth/2-392,screenHeight/2-20, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("When this is turned on you see a small icon above a player, who has opened his chat.",screenWidth/2-392,screenHeight/2, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsChaticons"], true)
		
		onOffMessage = "#FF0000off"
		if showMapInfo == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Mapinfo",screenWidth/2-392,screenHeight/2+35, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("Want to disable the fancy information displayed at each start of a map? You can with this setting.",screenWidth/2-392,screenHeight/2+55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+70, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsMapinfo"], true)	
	
		onOffMessage = "#FF0000off"
		if tachoEnabled == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Speedometer",screenWidth/2-392,screenHeight/2+90, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("With this func you are able to turn off (or obviously to turn on) your speedometer.",screenWidth/2-392,screenHeight/2+110, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+125, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsTacho"], true)
	
	elseif guiComboBoxGetSelected ( settingsBox ) == 2 then
		dxDrawShadowedText("Chat Language",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("These languages are available for the language chat.\nIn order to change the language click on it in the list and press the 'Change Language' button.\nIf you want to disable the language chat select 'None'.",screenWidth/2-262,screenHeight/2-215, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxSetVisible(g_settingsgui["tabSettingsLangList"], true)
		dxSetVisible(g_settingsgui["tabSettingsLangSet"], true)
		
		onOffMessage = "#FF0000off"
		if tireSmoke == true then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Tire Smoke Effects",screenWidth/2-392,screenHeight/2-75, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("If you encounter performance problems its recommended to turn this off.",screenWidth/2-392,screenHeight/2-55, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2-40, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)		
		dxSetVisible(g_settingsgui["tabSettingsSmoke"], true)		
	
		onOffMessage = "#FF0000off"
		if getElementData(getLocalPlayer(), "disableMusic") == false then onOffMessage = "#00FF00on" end
		dxDrawShadowedText("Mapmusic",screenWidth/2-392,screenHeight/2-20, screenWidth, screenHeight, tocolor(214,219,145,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1, ms_bold_12 , "left", "top", false, false, false, true)
		dxDrawShadowedText("When this is turned on mapmusic will be played when available.",screenWidth/2-392,screenHeight/2, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)	
		dxDrawShadowedText("Currently turned "..onOffMessage.."#FFFFFF.",screenWidth/2-392,screenHeight/2+15, screenWidth, screenHeight, tocolor(255,255,255,255*waveAlpha*waveMenuAlpha),tocolor(0,0,0,255*waveAlpha*waveMenuAlpha), 1,"default-bold", "left", "top", false, false, false, true)
		dxSetVisible(g_settingsgui["tabSettingsMusic"], true)	
	end

	guiSetVisible(settingsBox, true)
end