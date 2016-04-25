--[[
Project: vitaCore
File: xml-shared.lua
Author(s):	Werni
]]--

function xmlSetNode(xmlfile, nodename, nodeval)
	local thenode = xmlFindChild(xmlfile, nodename, 0)
	if not thenode then
		local newnode = xmlCreateChild(xmlfile, nodename)
		xmlNodeSetValue(newnode, tostring(nodeval))
		return newnode
	else
		xmlNodeSetValue(thenode, tostring(nodeval))
		return thenode
	end	
	return false
end

function oneNodeEdit(xmlfile, nodename, nodeval)
	local xml = xmlLoadFile(xmlfile)
	xmlSetNode(xml, nodename, nodeval)
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
end

function oneNodeGet(xmlfile, nodename)
	local xml = xmlLoadFile(xmlfile)
	local find = xmlFindChild(xml, nodename, 0)
	local val = xmlNodeGetValue(find)
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	return val
end

function xmlGetVal(xmlfile, nodename)
	local find = xmlFindChild(xmlfile, nodename, 0)
	local val = xmlNodeGetValue(find)
	if val then return val end
	return false
end



