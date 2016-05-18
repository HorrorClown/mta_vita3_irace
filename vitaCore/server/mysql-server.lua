--[[
Project: vitaCore
File: mysql-server.lua
Author(s):	Werni
			Sebihunter
]]--
g_mysql = {}
local hasPlayersLoaded = false

function onResourceStartMysqlConnection()
	local xml = xmlLoadFile("config.xml")
	if not xml then
		outputServerLog("Could not find config.xml. Aborting")
		cancelEvent()
		stopResource(getThisResource())
		return false
	end
	
	--MySQL Daten
	local mysqlchild = xmlFindChild(xml, "mysqldata", 0)
	if not mysqlchild then
		outputServerLog("No MySQL data was found.")
	end
	
	local mysqlhost = xmlGetVal(mysqlchild, "host")
	if mysqlhost then mysql_host = mysqlhost end
	
	local mysqluser = xmlGetVal(mysqlchild, "user")
	if mysqluser then mysql_user = mysqluser end
	
	local mysqlpsw = xmlGetVal(mysqlchild, "password")
	if mysqlpsw then mysql_password = mysqlpsw end

	local mysqltable = xmlGetVal(mysqlchild, "table")
	if mysqltable then mysql_table = mysqltable end	
	
	g_mysql["connection"] = mysql_connect(mysql_host, mysql_user, mysql_password, mysql_table, 3306, nil, "")

	if not g_mysql["connection"] then
		outputServerLog("Could not connect to MySQL!")
		print("Could not connect to MySQL!")
		stopResource(getThisResource())
		eventcancled = 1
		cancelEvent()
		return false
	end
	
	if not hasPlayersLoaded then
		hasPlayersLoaded = true
		if mysql_ping ( g_mysql["connection"] ) == false then
			onResourceStopMysqlEnd()
			hasPlayersLoaded = false
			onResourceStartMysqlConnection()
		end	
		local result = mysql_query(g_mysql["connection"], "SELECT * FROM `players` ORDER BY `id` ASC")
		if result then
			while true do
				local row = mysql_fetch_assoc(result)
				if not row then break end
				
				local accElement = createElement ( "userAccount" )
				setElementData(accElement, "AccountName", row["accountname"])
				setElementData(accElement, "Points", tonumber(row["points"]))	
				setElementData(accElement, "PlayerName", row["playerName"])
				setElementData(accElement, "Level", row["level"])
			end
			mysql_free_result(result)
		else
			outputServerLog("Could not load player elements! Trying again...")
			print("Could not load player elements! Trying again...")
			onResourceStopMysqlEnd()
			hasPlayersLoaded = false
			onResourceStartMysqlConnection()
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStartMysqlConnection)

function onResourceStopMysqlEnd()
	mysql_close(g_mysql["connection"])
end
addEventHandler("onResourceStop", resourceRoot, onResourceStopMysqlEnd, false, "low-1")