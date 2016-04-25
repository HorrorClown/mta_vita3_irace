--[[
Project: vitaCore - vitaWave
File: utils-wave.lua
Author(s): vEnom
			Sebihunter
]]--

--Not sync anything related to the GUI wih other players to prevent exploiting
local _setElementData = setElementData

local function setElementData( element, key, value )
	return _setElementData( element, key, value, false )
end

local dxRootElement = createElement("dxRootElement")
local sx,sy = guiGetScreenSize()
setElementData(dxRootElement,"x",0)
setElementData(dxRootElement,"y",0)
setElementData(dxRootElement,"width",sx)
setElementData(dxRootElement,"height",sy)
local movedElementOffset = {0,0}

function dxGridListSetSelectedItem(item)
for id, element in ipairs (getElementChildren(getElementParent(item))) do
	setElementData(element,"clicked",nil)
end
return setElementData(item,"clicked",true)
end


function dxGridListGetSelectedItem(grid)
for id, element in ipairs (getElementChildren(grid)) do
	if getElementData(element,"clicked") then 
		return element
	end
end
return false
end

function dxGridListGetItemCount(grid)
if not grid then return false end
local count = 0
for id, element in ipairs (getElementChildren(grid)) do
	if getElementType(element) ~= "dxScrollBar" then 
		count = count + 1
	end
end
return count
end

function dxGridListSetItemColorCoded(item,bool)
if not item then return false end
return setElementData(item,"colored",bool)
end


function dxGridListRemoveRow(item)
return destroyElement(item)
end


function dxGridListClear(grid)
for id, element in ipairs (getElementChlidren(grid)) do
	destroyElement(element)
end
return true
end

function dxGridListGetItemText(item)
if not item then return false end
return getElementData(item,"text")
end

function dxGridListSetItemText(item,text)
if not item then return false end
return setElementData(item,"text",text)
end


function dxStaticImageLoadImage(image,path)
if not image then return false end
return setElementData(image,"filepath",path)
end

function dxScrollBarSetScrollPosition(scroll,position)
return setElementData(scroll,"scroll",position/100)
end

function dxCheckBoxGetSelected(cb)
if not cb then return false end
return (getElementData(cb,"check"))
end

function dxCheckBoxSetSelected(cb,state)
if not cb then return false end
return (setElementData(cb,"check",state))
end


function dxEditSetMasked(edit,bool)
if not edit then return false end
return setElementData(edit,"masked",bool)
end

function dxEditSetReadOnly(edit,bool)
if not edit then return false end
return setElementData(edit,"readonly",bool)
end


function dxScrollBarGetScrollPosition(scroll)
return (tonumber(getElementData(scroll,"scroll")*100))
end

function dxCreateWindow (x,y,width,height,titleBarText,relative)
if x and y and width and height and titleBarText then
	if relative then 
		x = x * sx
		y = y * sy
		width = width * sx
		height = height * sy
	end
	local element = createElement("dxWindow")
	setElementParent(element,dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"movable",true)
	setElementData(element,"text",titleBarText)
	setElementData(element,"font","default-bold")
	setElementData(element,"title",tocolor(0,0,0,255))
	setElementData(element,"backgroundColor",tocolor(255,255,255,255))
	setElementData(element,"titleBackgroundColor",tocolor(255,255,255,255))
	return element
else
	outputDebugString("ERROR: expected arguments are missing(dxCreateWindow)")
end
end


function dxWindowSetTitleBackgroundColor(element,red,green,blue)
setElementData(element,"titleBackgroundColor",tocolor(red,green,blue,255))
end

function dxWindowSetBackgroundColor(element,red,green,blue)
setElementData(element,"backgroundColor",tocolor(red,green,blue,255))
end

function dxCreateGridList (x,y,width,height,relative,parent)
if x and y and height and width then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxGridList")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"filepath",filepath)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateGridList)")	
end
end

function dxButtonSetBackgroundImage(button,state,path)
if not button or not state or not path then return false end
if path == "default" then
	path = "files/wave/gui/button" 
	if state == "normal" then
		path = path..".png"
	elseif state == "clicked" then
		path = path..state.."clicked.png"
	elseif state == "hovered" then
		path = path..state.."hover.png"
	end
end
return setElementData(button,path.."path",path)
end


function dxCreateProgressBar (x,y,width,height,relative,parent)
if x and y and height and width then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxProgressBar")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"progress",50)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateGridList)")	
end
end




function dxCreateScrollBar (x,y,width,height,horizontal, relative,parent)
if x and y and height and width then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxScrollBar")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"scroll",0)
	setElementData(element,"horizontal",horizontal)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"filepath",filepath)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	addEventHandler("onClientDXClick",element,
	function()
		local cx,cy = getCursorPosition()
		cx = cx * sx
		cy = cy * sy
		local x = 0
		local y = 0
		if getElementData(source,"parent") then
			x = getElementData(getElementParent(source),"x")
			y = getElementData(getElementParent(source),"y")
		end
		if getElementData(source,"horizontal") then
			cx = cx - getElementData(source,"x") - x
			cx = cx - (getElementData(source,"scroll")*getElementData(source,"width")/2)
			if cx >= 0 and cx <= ((getElementData(source,"width")/2)) then
				setElementData(source,"attachOffset",cx)
			end
		else
			cy = cy - getElementData(source,"y") - y
			cy = cy - (getElementData(source,"scroll")*getElementData(source,"height")/2)
			if cy >= 0 and cy <= ((getElementData(source,"height")/2)) then
				setElementData(source,"attachOffset",cy)
			end
		end
	end
	)
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateButton)")	
end
end



function dxCreateStaticImage (x,y,width,height,filepath,relative,parent)
if x and y and height and width and filepath then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxStaticImage")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"filepath",filepath)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateButton)")	
end
end


function dxCreateLabel (x,y,width,height,text,relative,parent,colorcoded)
if x and y and height and width and text then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxLabel")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"font","default")
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"text",text)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	setElementData(element,"colorcoded",colorcoded)
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateLabel)")	
end
end




function dxCreateButton(x,y,width,height,text,relative,parent)
if x and y and height and width and text then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxButton")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"text",text)
	setElementData(element,"font","default-bold")
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	setElementData(element,"normalpath","files/wave/gui/button.png")
	setElementData(element,"hoveredpath","files/wave/gui/buttonhover.png")
	setElementData(element,"clickedpath","files/wave/gui/buttonclicked.png")
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateButton)")	
end
end

function dxCreateEdit(x,y,width,height,text,relative,parent)
if x and y and height and width and text then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxEdit")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"text",text)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	setElementData(element,"font","default")
	addEventHandler("onClientDXClick",element,moveCursor)
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateEdit)")	
end
end


function dxCreateMemo(x,y,width,height,text,relative,parent)
if x and y and height and width and text then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxMemo")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",width)
	setElementData(element,"height",height)
	setElementData(element,"text",text)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	setElementData(element,"font","default")
	addEventHandler("onClientDXClick",element,moveCursor)
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateEdit)")	
end
end



function dxCreateCheckBox(x,y,text,selected,relative,parent)
if x and y and text then
	if relative then 
		if parent then
			x = x*getElementData(parent,"x")
			y = y*getElementData(parent,"y")
		else
			x = x * sx
			y = y* sy
		end
	end
	local element = createElement("dxCheckBox")
	setElementParent(element,parent or dxRootElement)
	setElementData(element,"x",x)
	setElementData(element,"y",y)
	setElementData(element,"width",20)
	setElementData(element,"height",20)
	setElementData(element,"text",text)
	setElementData(element,"check",selected)
	setElementData(element,"parent",parent)
	setElementData(element,"state","normal")	
	setElementData(element,"font","default")
	addEventHandler("onClientDXClick",element,function () setElementData(source,"check",not getElementData(source,"check")) end)
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxCreateButton)")	
end
end





function setEditText ()
local control = controls()
for id,element in ipairs(getElementsByType("dxEdit")) do
	if getElementData(element,"input") and not getElementData(element,"readonly") then
		if control == "backspace" then 
			setElementData(element,"text",string.sub(getElementData(element,"text"),1,string.len(getElementData(element,"text"))-1))
		else
			if getElementData(element,"maxlength") then
				
				if (string.len(getElementData(element,"text"))) < getElementData(element,"maxlength") then
					setElementData(element,"text",getElementData(element,"text")..control)
				end
			else
				setElementData(element,"text",getElementData(element,"text")..control)
			end
		end
	end
end
end



function moveCursor()
for id, element in ipairs (getElementsByType("dxEdit")) do
	setElementData(element,"input",nil)
end
setElementData(source,"input",true)
removeEventHandler("onClientRender",getRootElement(),setEditText)
addEventHandler("onClientRender",getRootElement(),setEditText)
end


local KeyStates = {}

function controls()
keyTable = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
 "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z","backspace","num_0", "num_1", "num_2", "num_3", "num_4", "num_5",
 "num_6", "num_7", "num_8", "num_9", "num_mul", "num_add", "num_sub", "num_div", "num_dec","space","[", "]", ";", ",", "-", ".", "/", "#", "\\", "="} 
for id, key in ipairs(keyTable) do
	if getKeyState(key) then
		if not KeyStates[id] then 
			KeyStates = {}
			KeyStates[id] = true
			if key == "num_0" then return "0"
			elseif key == "num_1" then return "1"
			elseif key == "num_2" then return "2"
			elseif key == "num_3" then return "3"
			elseif key == "num_4" then return "4"
			elseif key == "num_5" then return "5"
			elseif key == "num_6" then return "6"
			elseif key == "num_7" then return "7"
			elseif key == "num_8" then return "8"
			elseif key == "num_9" then return "9"
			elseif key == "num_add" then return "+"
			elseif key == "num_sub" then return "-"
			elseif key == "num_div" then return "/"
			elseif key == "num_mul" then return "*"
			elseif key == "num_dec" then return ","
			elseif key == "space" then return " "
			else
			if not (getKeyState("lshift") or getKeyState("rshift")) then
				return key
			else
				return string.upper(key)
			end
			end
		else
			return ""
		end
	end
end
KeyStates = {}
return ""
end

function dxWindowSetMovable(window,bool)
if not window then return false end
return setElementData(window,"movable",bool)
end




function drawingGUI()
for id, dxGUIElement in ipairs (getElementsByType("dxWindow")) do
dxDrawImageSection( getElementData(dxGUIElement,"x"), getElementData(dxGUIElement,"y"), getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),0,0,getElementData(dxGUIElement,"width"),getElementData(dxGUIElement,"height"), "files/wave/gui/window.png",0,0,0,getElementData(dxGUIElement,"backgroundColor"))
dxDrawImageSection ( getElementData(dxGUIElement,"x"), getElementData(dxGUIElement,"y"), getElementData(dxGUIElement,"width"), 30,0,0,800,30,"files/wave/gui/window.png",0,0,0,getElementData(dxGUIElement,"titleBackgroundColor"))
dxDrawImage ( getElementData(dxGUIElement,"x")+getElementData(dxGUIElement,"width")-64, getElementData(dxGUIElement,"y")-1, 64, 32,"files/wave/gui/closehover.png",0,0,0,tocolor(255,255,255,255))
dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x"),getElementData(dxGUIElement,"y"),getElementData(dxGUIElement,"x")+getElementData(dxGUIElement,"width"),getElementData(dxGUIElement,"y")+30,tocolor(255,255,255,255),1,getElementData(dxGUIElement,"font"),"center","center")
end
for id, dxGUIElement in ipairs (getElementsByType("dxCheckBox")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if getElementData(dxGUIElement,"state") == "normal" then
		if getElementData(dxGUIElement,"check") then
			dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y,20,20, "files/wave/gui/checkboxcheck.png")
		else
			dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, 20,20, "files/wave/gui/checkbox.png")
		end
	else
		if getElementData(dxGUIElement,"check") then
			dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, 20,20, "files/wave/gui/checkboxcheck_hover.png")
		else
			dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, 20,20, "files/wave/gui/checkbox_hover.png")
		end
	end
	dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+25, getElementData(dxGUIElement,"y")+y,0,getElementData(dxGUIElement,"y")+y+20,tocolor(255,255,255,255),1.5*(15/dxGetFontHeight(1,getElementData(dxGUIElement,"font"))),getElementData(dxGUIElement,"font"),"left","center")
end
for id, dxGUIElement in ipairs (getElementsByType("dxButton")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if getElementData(dxGUIElement,"state") == "normal" then
		dxDrawRectangle ( getElementData(dxGUIElement,"x")+x-1, getElementData(dxGUIElement,"y")+y-1, getElementData(dxGUIElement,"width")+2, getElementData(dxGUIElement,"height")+2, tocolor(0,0,0,100) )
		dxDrawImageSection( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),0,0, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), getElementData(dxGUIElement,"normalpath"))
		
	elseif getElementData(dxGUIElement,"state") == "hovered" then
		dxDrawRectangle ( getElementData(dxGUIElement,"x")+x-1, getElementData(dxGUIElement,"y")+y-1, getElementData(dxGUIElement,"width")+2, getElementData(dxGUIElement,"height")+2, tocolor(0,0,0,100) )
		dxDrawImageSection( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),0,0, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), getElementData(dxGUIElement,"hoveredpath"))
	elseif getElementData(dxGUIElement,"state") == "clicked" then
		dxDrawRectangle ( getElementData(dxGUIElement,"x")+x-1, getElementData(dxGUIElement,"y")+y-1, getElementData(dxGUIElement,"width")+2, getElementData(dxGUIElement,"height")+2, tocolor(0,0,0,100) )
		dxDrawImageSection( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),0,0, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), getElementData(dxGUIElement,"clickedpath"))
	end
	dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+1, getElementData(dxGUIElement,"y")+y+1,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width")+1, getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height")+1,tocolor(0,0,0,150),1,getElementData(dxGUIElement,"font"),"center","center")
	dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(255,255,255,255),1,getElementData(dxGUIElement,"font"),"center","center")
end
for id, dxGUIElement in ipairs (getElementsByType("dxEdit")) do
	local x = 0
	local y = 0
	local text = getElementData(dxGUIElement,"text")
	if getElementData(dxGUIElement,"masked") then
		text = string.gsub(text,".","*")
	end
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if getElementData(dxGUIElement,"state") == "normal" then
		dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), "files/wave/gui/edit.png")
	else
		dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), "files/wave/gui/edit_hover.png")
	end
	if dxGetTextWidth(text,getElementData(dxGUIElement,"height")/15) <= getElementData(dxGUIElement,"width") then
		dxDrawText(text,getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(0,0,0,255),getElementData(dxGUIElement,"height")/( dxGetFontHeight(1,getElementData(dxGUIElement,"font")) ),getElementData(dxGUIElement,"font"),"left","center",true)
	else
		dxDrawText(text,getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(0,0,0,255),getElementData(dxGUIElement,"height")/dxGetFontHeight(1,getElementData(dxGUIElement,"font")),getElementData(dxGUIElement,"font"),"right","center",true)
	end
end	
for id, dxGUIElement in ipairs (getElementsByType("dxMemo")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if getElementData(dxGUIElement,"state") == "normal" then
		dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), "files/wave/gui/memo.png")
	else
		dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), "files/wave/gui/memo_hover.png")
	end
	--Since I haven't got bottom aligning of a huge text working, I disabled it. It would only show last line of text and that is useful anyways. Because of that, dxMemos are NOT editable.  
	--if ((dxGetTextWidth(getElementData(dxGUIElement,"text"),1.5)/getElementData(dxGUIElement,"width"))*22.5) <= getElementData(dxGUIElement,"height") then      --This calculation isn't perfect too, but there isn't better way.
		dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(0,0,0,255),1.5*(15/dxGetFontHeight(1,getElementData(dxGUIElement,"font"))),getElementData(dxGUIElement,"font"),"left","top",true,true)
	--else
		--	dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y ,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(0,0,0,255),1.5*(15/dxGetFontHeight(1,getElementData(dxGUIElement,"font"))),getElementData(dxGUIElement,"font"),"left","bottom",true,true)
	--end		
	end
for id, dxGUIElement in ipairs (getElementsByType("dxStaticImage")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), getElementData(dxGUIElement,"filepath"))		
end
for id, dxGUIElement in ipairs (getElementsByType("dxLabel")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if not getElementData(dxGUIElement,"colorcoded") then
		dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(255,255,255,255),getElementData(dxGUIElement,"height")/dxGetFontHeight(1,getElementData(dxGUIElement,"font")),getElementData(dxGUIElement,"font"),"left","top",true,false)
	else
		dxDrawText(getElementData(dxGUIElement,"text"),getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"x")+x+getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"y")+y+getElementData(dxGUIElement,"height"),tocolor(255,255,255,255),getElementData(dxGUIElement,"height")/dxGetFontHeight(1,getElementData(dxGUIElement,"font")),getElementData(dxGUIElement,"font"),"left","top",true,false,false, true)
	end
end
for id, dxGUIElement in ipairs (getElementsByType("dxScrollBar")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	if not getElementData(dxGUIElement,"horizontal") then
	
		dxDrawRectangle(getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),tocolor(30,30,30,130))
		dxDrawRectangle(getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y + ((getElementData(dxGUIElement,"height")/2)*getElementData(dxGUIElement,"scroll")),getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height")/2,tocolor(50,50,50,200))
	else
		dxDrawRectangle(getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y,getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"),tocolor(30,30,30,130))
		dxDrawRectangle(getElementData(dxGUIElement,"x")+x+5+ ((getElementData(dxGUIElement,"width")/2)*getElementData(dxGUIElement,"scroll")), getElementData(dxGUIElement,"y")+y ,getElementData(dxGUIElement,"width")/2, getElementData(dxGUIElement,"height"),tocolor(50,50,50,200))
	end
	
end	

	
	for id, dxGUIElement in ipairs (getElementsByType("dxGridList")) do
		local x = 0
		local y = 0
		if getElementData(dxGUIElement,"parent") then
			x = getElementData(getElementParent(dxGUIElement),"x")
			y = getElementData(getElementParent(dxGUIElement),"y")
		end
		dxDrawRectangle( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), tocolor(150,150,150,150))
		local no = #getElementChildren(	dxGUIElement )
		--is scrooling
		for id, item in ipairs (getElementChildren(	dxGUIElement )) do
		local delta = getElementData(getElementData(dxGUIElement,"scrollbar"),"scroll")*no*1.5*15
			if getElementData(dxGUIElement,"scrollbar") then
				local delta = getElementData(getElementData(dxGUIElement,"scrollbar"),"scroll")*no*1.5*15
			end
			delta = delta/2
			if (((id)*1.5*15)-delta) <= (getElementData(dxGUIElement,"height")+22.5) and (((id)*1.5*15)-delta) >= 0 then
				setElementData(item,"shown",true)
				if getElementData(item,"state") == "hovered" then dxDrawRectangle(getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0),getElementData(dxGUIElement,"width"),getItemShowingHeight(item),tocolor(255,255,255,100)) end
				if getElementData(item,"state") == "clicked" then dxDrawRectangle(getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0),getElementData(dxGUIElement,"width"),getItemShowingHeight(item),tocolor(0,0,0,100)) for id, el in ipairs(getElementChildren(getElementParent(item))) do setElementData(el,"clicked",nil) end setElementData(item,"clicked",true) end
				if getElementData(item,"clicked") then dxDrawRectangle(getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0),getElementData(dxGUIElement,"width"),getItemShowingHeight(item),tocolor(255,200,0,255)) end
				if getElementData(item,"colored") then
					dxDrawText(getElementData(item,"text"),getElementData(dxGUIElement,"x")+x+3,3+ getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0),getElementData(dxGUIElement,"width")+getElementData(dxGUIElement,"x")+x-3,getElementData(dxGUIElement,"y")+y + math.min(getElementData(dxGUIElement,"height"),((id)*1.5*15)-delta)-3,tocolor(255,255,255,255),1.3,"default","left", getItemAlign(math.max(((id-1)*1.5*15)-delta,0)) ,true, false, false, true)
				else
					dxDrawText(getElementData(item,"text"),getElementData(dxGUIElement,"x")+x+3,3+ getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0),getElementData(dxGUIElement,"width")+getElementData(dxGUIElement,"x")+x-3,getElementData(dxGUIElement,"y")+y + math.min(getElementData(dxGUIElement,"height"),((id)*1.5*15)-delta)-3,tocolor(255,255,255,255),1.3,"default","left", getItemAlign(math.max(((id-1)*1.5*15)-delta,0)) ,true, false, false, false)
				end
				setElementData(item,"width",getElementData(dxGUIElement,"width"))
				setElementData(item,"height",15*1.5)
				setElementData(item,"x",getElementData(dxGUIElement,"x")+x)
				setElementData(item,"y",getElementData(dxGUIElement,"y")+y + math.max(((id-1)*1.5*15)-delta,0))
			else
				setElementData(item,"shown",false)
			end
		end		
for id, dxGUIElement in ipairs (getElementsByType("dxProgressBar")) do
	local x = 0
	local y = 0
	if getElementData(dxGUIElement,"parent") then
		x = getElementData(getElementParent(dxGUIElement),"x")
		y = getElementData(getElementParent(dxGUIElement),"y")
	end
	dxDrawImage( getElementData(dxGUIElement,"x")+x, getElementData(dxGUIElement,"y")+y, getElementData(dxGUIElement,"width"), getElementData(dxGUIElement,"height"), "files/wave/gui/progress.png")
	dxDrawRectangle(getElementData(dxGUIElement,"x")+x+5, getElementData(dxGUIElement,"y")+y+5, ((getElementData(dxGUIElement,"width")-10)*((getElementData(dxGUIElement,"progress")/100))),getElementData(dxGUIElement,"height")-10,tocolor(0,255,0,155))
end
end	
end


function getItemAlign(value)
if value == 0 then return "bottom" else return "top" end
end

function getItemShowingHeight(item)
local y = getElementData(item,"y")
local gx,gy = dxGetPosition(getElementParent(item))
local delta =  getElementData(getElementParent(item),"height") - (y-gy)
return math.min(delta,22.5)
end


function dxGridListAddRow(gridlist,text)
if gridlist and text then
	local element = createElement("dxGridListItem")
	setElementParent(element,gridlist)
	setElementData(element,"text",text)	
	if (#(getElementChildren(gridlist))*15*1.5) >= getElementData(gridlist,"height") and not getElementData(gridlist,"scrollbar")then
		setElementData(gridlist,"width",getElementData(gridlist,"width")-20)
		local x,y = dxGetPosition(gridlist)
		local x1,y1 = dxGetPosition(getElementParent(gridlist))
		x = x- x1
		y = y - y1
		local scrollbar = dxCreateScrollBar(x+getElementData(gridlist,"width")-3,y,20,getElementData(gridlist,"height"),false,false,getElementParent(gridlist))
		setElementData(gridlist,"scrollbar",scrollbar)
		end
	return element
else
	outputDebugString("ERROR: expected arguments are missing (dxGridListAddRow)")	
	return false
end
end



function dxGetPosition(element,relative)
if not element or not isElement(element) then return false end
local x = getElementData(element,"x")
local y = getElementData(element,"y")
local px = getElementData(getElementParent(element),"x")
local py = getElementData(getElementParent(element),"y")
if not relative then
	return x + px, y + py
else
	return x/px, y/py
end
end

function dxSetPosition(element,fx,fy,relative)
if not element then return false end
local x = getElementData(element,"x")
local y = getElementData(element,"y")
local px = getElementData(getElementParent(element),"x")
local py = getElementData(getElementParent(element),"y")
if not relative then
	setElementData(element,"x",fx)
	setElementData(element,"y",fy)
else
	setElementData(element,"x",fx*px)
	setElementData(element,"y",fy*py)
end
end

function dxSetSize(element,fx,fy,relative)
if not element then return false end
local px = getElementData(getElementParent(element),"width")
local py = getElementData(getElementParent(element),"height")
if not relative then
	setElementData(element,"width",fx)
	return setElementData(element,"height",fy)
else
	setElementData(element,"height",fx*px)
	return setElementData(element,"width",fy*py)
end
end

function dxGetSize(element,relative)
if not element then return false end
local px = getElementData(getElementParent(element),"width")
local py = getElementData(getElementParent(element),"height")
if not relative then
	return getElementData(element,"width"),getElementData(element,"height")
else
	return (getElementData(element,"height"))/py, (getElementData(element,"width"))/py
end
end

function dxEditSetMaxLength (edit,length)
if not edit then return false end
return setElementData(edit,"maxlength",length)
end

function dxProgressBarSetProgress(progressbar,progress)
if not progressbar then return false end
return setElementData(progressbar,"progress",progress)
end

function dxProgressBarGetProgress(progressbar)
if not progressbar then return false end
return getElementData(progressbar,"progress")
end

function dxSetFont(element,font)
return setElementData(element,"font",font)
end

function dxGetFont(element)
return getElementData(element,"font")
end



addEventHandler("onClientRender",getRootElement(), 
function()
if not attachedScrollBar then return end
local cx, cy = getCursorPosition()
if not cx or not cy then return end
cx = cx * sx
cy = cy * sy
local x = 0
local y = 0
if getElementData(attachedScrollBar,"parent") then
	x = getElementData(getElementParent(attachedScrollBar),"x")
	y = getElementData(getElementParent(attachedScrollBar),"y")
end
if getElementData(attachedScrollBar,"horizontal") then
	x = x + getElementData(attachedScrollBar,"x")
	cx = cx - x - (getElementData(attachedScrollBar,"attachOffset") or 0 )
	local scroll = cx / (getElementData(attachedScrollBar,"width")/2)
	scroll = math.max(0,scroll)
	scroll = math.min(1,scroll)
	setElementData(attachedScrollBar,"scroll",scroll)
else
	y = y + getElementData(attachedScrollBar,"y")
	cy = cy - y - (getElementData(attachedScrollBar,"attachOffset") or 0 )
	local scroll = cy / (getElementData(attachedScrollBar,"height")/2)
	scroll = math.max(0,scroll)
	scroll = math.min(1,scroll)
	setElementData(attachedScrollBar,"scroll",scroll)
end
end
)


function GUIstates()
if not isCursorShowing() then return end
local x,y = getCursorPosition()
x = x * sx
y = y * sy
for id,element_r in ipairs(getElementChildren(dxRootElement)) do
	for id, element in ipairs(getElementChildren(element_r)) do
		if getElementType(element) == "dxGridList" then
			for id, element in ipairs(getElementChildren(element)) do
				if getElementType(element) == "dxGridListItem" and getElementData(element,"shown") then
					local g_height = getElementData(element,"height") or 0
					local g_width = getElementData(element,"width") or 0
					local px = getElementData(element,"x")
					local py = getElementData(element,"y")
					if x >= px and x <= (px+g_width) and y >= py and y <= (py + g_height) then
						if getKeyState("mouse1") then
							setElementData(element,"state","clicked",sync)
						else
							setElementData(element,"state","hovered",sync)
						end
					else
						setElementData(element,"state","normal",sync)
					end
				end
			end
		else
			local g_height = getElementData(element,"height") or 0
			local g_width = getElementData(element,"width") or 0
			local px, py = dxGetPosition(element)
			if x >= px and x <= (px+g_width) and y >= py and y <= (py + g_height) then
				if getKeyState("mouse1") then
					setElementData(element,"state","clicked",sync)
				else
					if getElementData(element,"state") == "normal" then
						triggerEvent("onClientDXMouseEnter",element)
					end
					setElementData(element,"state","hovered",sync)
				end
			else
				if getElementData(element,"state") == "hovered" then
					triggerEvent("onClientDXMouseLeave",element)
				end
				setElementData(element,"state","normal",sync)
			end
		end
	end
end
end



function movingGUI(button,state,x,y)
attachedScrollBar = nil
for id, element in ipairs (getElementsByType("dxEdit")) do
	setElementData(element,"input",nil)
end
if button == "left" and state == "down" then
	for id, element in ipairs(getElementChildren(dxRootElement)) do
		local width = getElementData(element,"width") or 0
		local height = getElementData(element,"height") or 0
		if x >= getElementData(element,"x") and x <= (getElementData(element,"x")+width) and y >= getElementData(element,"y") and y <= (getElementData(element,"y") + 30) then
			elementBeingMoved = element
			movedElementOffset = { x - getElementData(element,"x"), y - getElementData(element,"y")}
		end
	end
	for id, element in ipairs(getElementsByType("dxScrollBar")) do
		if isElement(element) then
			local g_height = getElementData(element,"height") or 0
				local g_width = getElementData(element,"width") or 0
				local px, py = dxGetPosition(element)
				if x >= px and x <= (px+g_width) and y >= py and y <= (py + g_height) then
			if getElementType(element) == "dxScrollBar" then
				triggerEvent("onClientDXClick",element)
				attachedScrollBar = element
			end
		end
	end
	end
else
	elementBeingMoved = nil
	for id,element_r in ipairs(getElementChildren(dxRootElement)) do
		for id, element in ipairs(getElementChildren(element_r)) do
			local g_height = getElementData(element,"height") or 0
			local g_width = getElementData(element,"width") or 0
			local px, py = dxGetPosition(element)
			if x >= px and x <= (px+g_width) and y >= py and y <= (py + g_height) then
					if state == "up" and button =="left" then
						triggerEvent("onClientDXClick",element)
					end
			end
		end
	end
end
end

function movingWindow()
	for id, dxGUIElement in ipairs (getElementsByType("dxWindow")) do
	if getElementData(dxGUIElement,"movable")  then
		if elementBeingMoved == dxGUIElement then
			if isCursorShowing() then
				local cx,cy = getCursorPosition()
				cx = cx*sx
				cy = cy*sy
				setElementData(dxGUIElement,"x",  cx - movedElementOffset[1]) 
				setElementData(dxGUIElement,"y",  cy - movedElementOffset[2]) 
			end
		end
	end
	end
end


function dxGetText(element)
if not element then return false end
return getElementData(element,"text")
end

function dxSetText(element,text)
if not element then return false end
return setElementData(element,"text",text)
end





addEvent("onClientDXClick",true)
addEvent("onClientDXMouseEnter",true)
addEvent("onClientDXMouseLeave",true)
addEventHandler("onClientClick",getRootElement(),movingGUI)
addEventHandler("onClientPreRender",getRootElement(),movingWindow)
addEventHandler("onClientRender",getRootElement(),drawingGUI, true, "low-5")
addEventHandler("onClientRender",getRootElement(),GUIstates)

--TEST
--[[
local sx, sy = guiGetScreenSize()
local window = dxCreateWindow((sx/2)-320,(sy/2)-240,640,480,"Test window",false)
local progress = dxCreateProgressBar(350,50,200,50,false,window)
local button = dxCreateButton(350,180,200,60,"Test button",false,window)
addEventHandler("onClientDXClick",button,function() outputChatBox("You clicked a dxGUI button!") end)
addEventHandler("onClientDXMouseEnter",button,function() outputChatBox("Your mouse pointer is over a dxGUI button!") end)
addEventHandler("onClientDXMouseLeave",button,function() outputChatBox("Your mouse pointer has left a dxGUI button!") end)
dxCreateMemo(5,300,300,140,"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.",false,window)
dxCreateEdit(5,35,300,30,"You can type here",false,window)
local edit = dxCreateEdit(5,75,300,25,"You can type here too",false,window)
dxEditSetMasked(edit,true)
dxCreateLabel(5,100,400,30,"This label isn't #ffffffcolorcoded",false,window)
dxCreateLabel(5,130,300,30,"#00ff00This #0000ffone #fff000is",false,window,true)
local lab = dxCreateLabel(5,170,300,30,"#ff0000Different #00ff00font",false,window,true)
dxSetFont(lab,"pricedown")
chck = dxCreateCheckBox(5,200,"Banana",true,false,window)
dxCreateCheckBox(5,230,"Pineapple",false,false,window)
dxCreateCheckBox(5,260,"Apple",false,false,window)
local gridlist = dxCreateGridList(310,250,310,220,false,window)
local row = dxGridListAddRow(gridlist,"This one is #ffff00color#00ffffcoded!")
dxGridListSetItemColorCoded (row,true)
for i = 1,50 do
	dxGridListAddRow(gridlist,"This #ff6600is #ffff00not")
end
showCursor(true)

local scrollbar = dxCreateScrollBar(310,140,280,30,true,false,window)

addEventHandler("onClientRender",getRootElement(),function() dxProgressBarSetProgress(progress, dxScrollBarGetScrollPosition(scrollbar)) end)]]