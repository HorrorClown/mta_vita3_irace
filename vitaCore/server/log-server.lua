--[[
Project: vitaCore
File: log-server.lua
Author(s):	MrX
]]--
Logger = {}
Logger.__index = Logger

function Logger.create(filepath)
	local nlog = {}
	
	if not fileExists(filepath) then
		fileClose(fileCreate(filepath)) -- hacky but efficient o_O
	end
	
	nlog.pFile = filepath
	setmetatable(nlog, Logger)
	return nlog
end

function Logger:addEntry(line)
	local handle = fileOpen(self.pFile)
	fileSetPos(handle, fileGetSize(handle))
	fileWrite(handle, timeformat().." "..line.."\n")
	fileClose(handle)
end