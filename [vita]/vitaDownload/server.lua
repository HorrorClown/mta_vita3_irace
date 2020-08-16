addEvent("requestFileDownload", true)
addEventHandler("requestFileDownload", getRootElement(),
	function (serverFile, clientFile, gameModeID)
		local file = fileOpen(serverFile)
		if file then
			local fileSize = fileGetSize ( file )
			triggerClientEvent(source, "onClientDownloadPreStart", source, serverFile, clientFile, fileSize, gameModeID)
			fileClose(file) 
		else
			triggerEvent("onDownloadFailure", source, serverFile, clientFile)
			triggerClientEvent(source, "onClientDownloadFailure", source, serverFile, clientFile)
		end		
	end
)

addEvent("startFileDownload", true)
addEventHandler("startFileDownload", getRootElement(),
	function (serverFile, clientFile, gameModeID)
		local file = fileOpen(serverFile)
		if file then
			local buffer = ""
			local ix = 1
			buffer = fileRead(file, fileGetSize ( file ))
			--while not fileIsEOF(file) do
			--	print(tostring(ix))
			--	ix = ix +1 
			--	buffer = buffer .. fileRead(file, 500)
			--end
			triggerLatentClientEvent ( source, "onFileReceive", 500000, false, getRootElement(), clientFile, buffer, gameModeID )
			fileClose(file)
		else
			triggerEvent("onDownloadFailure", source, serverFile, clientFile)
			triggerClientEvent(source, "onClientDownloadFailure", source, serverFile, clientFile)
		end		
	end
)

setTimer(function()
	for i, v in pairs(getElementsByType("player")) do
		local handles = getLatentEventHandles ( v )
		if handles ~= false and handles ~= nil then
			if handles[1] then
				local status = getLatentEventStatus(v, handles[1])
				triggerClientEvent(v, "onClientGetLatentInfo", v, status)
			end
		end
	end
end, 100, 0)

function getServerFileSize(file, type)
local path = ""
	if not file then return false; end
	if string.find(file, ":") == 1 then
		path = file
	else
		if sourceResource then
			path = ":"..getResourceName(sourceResource).."/"..file
		else
			path = file
		end

	end
	if string.len(path) == 0 then
		outputDebugString("There must be a valid file to read from.", 3)
		return false;
	else
		local tFile = fileOpen(path, true)
		if tFile then
			local size = fileGetSize (tFile)
			if string.upper(type) == "KB" then
				size = math.round(size / 1024, 2)
			elseif string.upper(type) == "MB" then
				size = math.round(size / 1048576, 2)
			end
			fileClose(tFile)
			return size;
		else
			return false;
		end
	end
end

addEvent("onDownloadFailure", true)
addEvent("onDownloadComplete", true)
addEvent("onDownloadPreStart", true)