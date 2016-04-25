--[[
Project: vitaCore
File: langselect-client.lua
Author(s):	Sebihunter
]]--

function setTheLanguage(button)
	if button == "left" then
		local row = dxGridListGetSelectedItem ( langList )
		if dxGridListGetItemData (langList, row) then
			addNotification(2, 153, 102, 150, "Language set to "..gSupportedLanguages[dxGridListGetItemData (langList, row)]..".")
			setElementData(getLocalPlayer(), "language", dxGridListGetItemData (langList, row))
			updateSettings("language", tostring(dxGridListGetItemData (langList, row)))
			hideLangSelect()
			showSelection()
		end
	end
end

langList = dxCreateGridList(screenWidth/2-392,screenHeight/2-215,120,340)
langSet = dxCreateButton(screenWidth/2-262,screenHeight/2+101,139,24,"Select Language",false)
addEventHandler ( "onClientDXClick", langSet, setTheLanguage, false ) 
dxSetVisible(langList, false)
dxSetVisible(langSet, false)	

for i,v in ipairs(gSupportedLanguages) do
	dxGridListAddRow ( langList, v, i)
end

function showLangSelect()
	vitaBackgroundToggle(true)
	addEventHandler("onClientRender", getRootElement(), renderLangSelect, false, "low")
	dxSetVisible(langList, true)
	dxSetVisible(langSet, true)
	showChat(false)
	showCursor(true)
end

function renderLangSelect()
	dxDrawImageSection ( 0,0, screenWidth, screenHeight, 0, 0, screenWidth, screenHeight, "files/wave/bg1.png",  0,0, 0, tocolor(255,255,255,175), false )
	dxDrawImage(-30,-30,256,256, "files/vitaonline_symbol.png",0,0,0, tocolor(255,255,255,255))
	
	dxDrawShadowedText("Language Selection",200,10, screenWidth, 50, tocolor(255,255,255,255),tocolor(0,0,0,255), 1,ms_bold, "left", "top", false, false, false, true)
	dxDrawShadowedText("Chat Language",screenWidth/2-392,screenHeight/2-240, screenWidth, screenHeight, tocolor(214,219,145,255),tocolor(0,0,0,255), 1, ms_bold_12 , "left", "top", false, false, false, true)
	dxDrawShadowedText("These languages are available for the language chat.\nIn order to select the language click on it in the list and press the 'Select Language' button.\nIf you want to disable the language chat select 'None'.\n\nPlease note that this screen will always show after login\nif you select 'None' as language.",screenWidth/2-262,screenHeight/2-215, screenWidth, screenHeight, tocolor(255,255,255,255),tocolor(0,0,0,255), 1,"default-bold", "left", "top", false, false, false, true)

	dxDrawShadowedText("Vita3 Setup",screenWidth/2+212, screenHeight/2+200, screenWidth/2+212+180, screenHeight/2+200+9, tocolor(255,255,255,255),tocolor(0,0,0,255), 1,"default-bold", "right", "bottom", false, false, false, true)
end

function hideLangSelect()
	dxSetVisible(langList, false)
	dxSetVisible(langSet, false)	
	showCursor(false)
	showChat(true)
	vitaBackgroundToggle(false)
	removeEventHandler("onClientRender", getRootElement(), renderLangSelect)
end