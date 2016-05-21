--[[
Project: vitaCore
File: player-server.lua
Author(s):	Werni
			Sebihunter
]]--

g_playerstat = {}

function registerPlayer(player, accname, password)
	if mysql_ping ( g_mysql["connection"] ) == false then
		onResourceStopMysqlEnd()
		onResourceStartMysqlConnection()
	end
	accname = escapeString(tostring(accname))
	password = escapeString(tostring(password))
	
	local result = mysql_query(g_mysql["connection"], "SELECT * FROM `players` WHERE `accountname` = '"..accname.."'")
	if mysql_num_rows(result) ~= 0 then
		triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This accountname is already used.")
		return false
	end



	local result = mysql_query(g_mysql["connection"], "INSERT INTO `players` (`accountname`) VALUES ('"..accname.."');")
	outputConsole(tostring(result))
	if not result then return end
	
	local id = mysql_query(g_mysql["connection"], "SELECT LAST_INSERT_ID(id) AS last FROM players ORDER BY id DESC LIMIT 1;")
	local lastid = mysql_insert_id(g_mysql["connection"])
	mysql_free_result(id)
	
	local colors = {}
	colors["r1"] = 255
	colors["g1"] = 255
	colors["b1"] = 255
	colors["r2"] = 255
	colors["g2"] = 255
	colors["b2"] = 255	
	local mysqlColor = toJSON(colors)
	
	local lightcolors = {}
	lightcolors["rl"] = 255
	lightcolors["gl"] = 255
	lightcolors["bl"] = 255
	local mysqlLighrcolor = toJSON(lightcolors)
	
	local archivements = {}	
	local mysqlArchivements = toJSON(archivements)
	
	local time = getRealTime()
	local LastActivity = tostring(time.monthday)..":"..tostring(time.month+1)..":"..tostring(time.year+1900).."/"..tostring(time.hour)..":"..tostring(time.minute)
	
	mysql_query(g_mysql["connection"], "UPDATE `players` SET `password` = '"..md5(password).."',\
															 `level` = 'User',\
															 `skin` = '0',\
															 `points` = '0',\
															 `rank` = '0',\
															 `money` = '0',\
															 `wonmaps` = '0',\
															 `playedmaps` = '0',\
															 `ddmaps` = '1',\
															 `dmmaps` = '1',\
															 `shmaps` = '1',\
															 `ramaps` = '1',\
															 `dmwon` = '0',\
															 `ddwon` = '0',\
															 `shwon` = '0',\
															 `rawon` = '0',\
															 `betcounter` = '0',\
															 `playedtimecounter` = '0',\
															 `vehcolor` = '"..mysqlColor.."',\
															 `lightcolor` = '"..mysqlLighrcolor.."',\
															 `lastactivity` = '"..LastActivity.."',\
															 `timeonserver` = '0',\
															 `toptimes` = '0',\
															 `toptimesra` = '0',\
															 `km` = '0',\
															 `winningstreak` = '0',\
															 `archivements` = '"..mysqlArchivements.."',\
															 `memeActivated` = '0',\
															 `ddWinrate` = '0',\
															 `dmWinrate` = '0',\
															 `shWinrate` = '0',\
															 `raWinrate` = '0',\
															 `playerName` = '"..escapeString(_getPlayerName(player)).."',\
															 `isDonator` = '0',\
															 `usedHorn` = '0',\
															 `wheels` = '0',\
															 `shooterkills` = '0',\
															 `ddkills` = '0',\
															 `donatordate` = '20.04.1889',\
															 `backlights` = '0'\
	WHERE `id` = '"..lastid.."' LIMIT 1 ;")
	
	triggerClientEvent ( player, "addNotification", getRootElement(), 2, 50, 200, 50, "Account successfully created!\nYour password: "..tostring(password))

	local accElement = createElement("userAccount")
	setElementData(accElement, "AccountName", accname)
	setElementData(accElement, "PlayerName", _getPlayerName(player))
	setElementData(accElement, "Points", 0)	
	setElementData(accElement, "Level", "User")	
	
	loginPlayer(accname, password, "server", player)
end
--addEvent("registerPlayer", true)
--addEventHandler("registerPlayer", getRootElement(), registerPlayer)

function quitPlayer(reason)
	addPlayerArchivement(source, 37)
	
	savePlayer(source, reason)
	
	if getPlayerGameMode(source) == 0 then return true end
	callServerFunction(gRaceModes[getPlayerGameMode(source)].quitfunc, source)	
end
--addEventHandler("onPlayerQuit", getRootElement(), quitPlayer)

--MySQL_debug = Logger.create("logs/mysqldebug.log")

function savePlayer(source, reason)
		if getElementData(source, "isLoggedIn") == true then

			local accid = getElementData(source, "Userid")
            local atable = getElementData(source, "Archivements")
            local archivements_save = toJSON(atable)

            local color = {}
            color["r1"] = getElementData(source, "r1")
            color["g1"] = getElementData(source, "g1")
            color["b1"] = getElementData(source, "b1")
            color["r2"] = getElementData(source, "r2")
            color["g2"] = getElementData(source, "g2")
            color["b2"] = getElementData(source, "b2")
            local mysqlColor = toJSON(color)

            local lightcolor = {}
            lightcolor["rl"] = getElementData(source, "rl")
            lightcolor["gl"] = getElementData(source, "gl")
            lightcolor["bl"] = getElementData(source, "bl")
            local mysqlLightcolor = toJSON(lightcolor)


            if g_playerstat and g_playerstat[source] then
                if isTimer(g_playerstat[source]["TimeTimer"])then
                    killTimer(g_playerstat[source]["TimeTimer"])
                end
                g_playerstat[source] = nil
            end

            local currentTime = getTimestamp()

            local isDonator = 0
            if getElementData(source, "isDonator") == true then
                isDonator = 1
            end

            local time = getRealTime()
            local LastActivity = tostring(time.monthday)..":"..tostring(time.month+1)..":"..tostring(time.year+1900).."/"..tostring(time.hour)..":"..tostring(time.minute)

			sql:queryExec("UPDATE players SET accountname = ?, level = ?, skin = ?, points = ?, rank = ?, money = ?, wonmaps = ?, playedmaps = ?, ddmaps = ?, dmmaps = ?, shmaps = ?, ramaps = ?, ddwon = ?, dmwon = ?, shwon = ?, rawon = ?, betcounter = ?, playedtimecounter = ?, lastactivity = NOW(), vehcolor = ?, lightcolor = ?, timeonserver = ?, toptimes = ?, toptimesra = ?, km = ?, winningstreak = ?, memeActivated = ?, ddWinrate = ?, dmWinrate = ?, shWinrate = ?, raWinrate = ?, playerName = ?, isDonator = ?, usedHorn = ?, wheels = ?, shooterkills = ?, ddkills = ?, donatordate = ?, backlights = ?, archivements = ? WHERE id = ?", source:getData("AccountName"), source:getData("Level"), source:getData("Skin"), source:getData("Points"), source:getData("Rank"), source:getData("Money"), source:getData("WonMaps"), source:getData("PlayedMaps"), source:getData("DDMaps"), source:getData("DMMaps"), source:getData("SHMaps"), source:getData("RAMaps"), source:getData("DDWon"), source:getData("DMWon"), source:getData("SHWon"), source:getData("RAWon"), source:getData("betCounter"), source:getData("playedTimeCounter"), mysqlColor, mysqlLightcolor, source:getData("TimeOnServer"), source:getData("TopTimes"), source:getData("TopTimesRA"), source:getData("KM"), source:getData("WinningStreak"), source:getData("memeActivated"), math.round(source:getData("DDWon")/source:getData("DDMaps")*100,2), math.round(source:getData("DMWon")/source:getData("DMMaps")*100,2), math.round(source:getData("SHWon")/source:getData("SHMaps")*100,2), math.round(source:getData("RAWon")/source:getData("RAMaps")*100,2), source.name, isDonator, source:getData("usedHorn"), source:getData("Wheels"), source:getData("shooterkills"),	source:getData("ddkills"), source:getData("donatordate"), source:getData("Backlights"), archivements_save, accid)

            --[[local sql = "UPDATE `players` SET `accountname` = '"..tostring(getElementData(source, "AccountName")).."',\
												`level` = '"..tostring(getElementData(source, "Level")).."',\
												`skin` = '"..tostring(getElementData(source, "Skin")).."',\
												`points` = '"..tostring(getElementData(source, "Points")).."',\
												`rank` = '"..tostring(getElementData(source, "Rank")).."',\
												`money` = '"..tostring(getElementData(source, "Money")).."',\
												`wonmaps` = '"..tostring(getElementData(source, "WonMaps")).."',\
												`playedmaps` = '"..tostring(getElementData(source, "PlayedMaps")).."',\
												`ddmaps` = '"..tostring(getElementData(source, "DDMaps")).."',\
												`dmmaps` = '"..tostring(getElementData(source, "DMMaps")).."',\
												`shmaps` = '"..tostring(getElementData(source, "SHMaps")).."',\
												`ramaps` = '"..tostring(getElementData(source, "RAMaps")).."',\
												`ddwon` = '"..tostring(getElementData(source, "DDWon")).."',\
												`dmwon` = '"..tostring(getElementData(source, "DMWon")).."',\
												`shwon` = '"..tostring(getElementData(source, "SHWon")).."',\
												`rawon` = '"..tostring(getElementData(source, "RAWon")).."',\
												`betcounter` = '"..tostring(getElementData(source, "betCounter")).."',\
												`playedtimecounter` = '"..tostring(getElementData(source, "playedTimeCounter")).."',\
												`lastactivity` = NOW(),\
												`vehcolor` = '"..tostring(mysqlColor).."',\
												`lightcolor` = '"..tostring(mysqlLightcolor).."', \
												`timeonserver` = '"..tostring(getElementData(source, "TimeOnServer")).."', \
												`toptimes` = '"..tostring(getElementData(source, "TopTimes")).."', \
												`toptimesra` = '"..tostring(getElementData(source, "TopTimesRA")).."', \
												`km` = '"..tostring(getElementData(source, "KM")).."', \
												`winningstreak` = '"..tostring(getElementData(source, "WinningStreak")).."', \
												`memeActivated` = '"..tostring(getElementData(source, "memeActivated")).."', \
												`ddWinrate` = '"..tostring(math.round((getElementData(source, "DDWon")/getElementData(source, "DDMaps"))*100,2)).."', \
												`dmWinrate` = '"..tostring(math.round((getElementData(source, "DMWon")/getElementData(source, "DMMaps"))*100,2)).."', \
												`shWinrate` = '"..tostring(math.round((getElementData(source, "SHWon")/getElementData(source, "SHMaps"))*100,2)).."', \
												`raWinrate` = '"..tostring(math.round((getElementData(source, "RAWon")/getElementData(source, "RAMaps"))*100,2)).."', \
												`playerName` = '"..tostring(sourceName).."', \
												`isDonator` = '"..tostring(isDonator).."', \
												`usedHorn` = '"..tostring(getElementData(source, "usedHorn")).."', \
												`wheels` = '"..tostring(getElementData(source, "Wheels")).."', \
												`shooterkills` = '"..tostring(getElementData(source, "shooterkills")).."', \
												`ddkills` = '"..tostring(getElementData(source, "ddkills")).."', \
												`donatordate` = '"..tostring(getElementData(source, "donatordate")).."', \
												`backlights` = '"..tostring(getElementData(source, "Backlights")).."' \
										WHERE `id` = '"..accid.."' LIMIT 1 ;"

             outputServerLog(sql)]]

            --MySQL_debug:addEntry(tostring(sql))
			--local result = mysql_query(g_mysql["connection"], sql)
			--sql = nil
			
			--[[if archivements_save ~= "return {{},}--|" then
				sql = "UPDATE `players` SET `archivements` = '"..archivements_save.."' \
											WHERE `id` = '"..accid.."' LIMIT 1 ;"
				mysql_query(g_mysql["connection"], sql)
				sql = nil
			end]]

			--[[local account = getAccount(tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "Admin" ) ) then
				aclGroupRemoveObject(aclGetGroup("Admin"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "SuperModerator" ) ) then
				aclGroupRemoveObject(aclGetGroup("SuperModerator"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "Moderator" ) ) then
				aclGroupRemoveObject(aclGetGroup("Moderator"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "SeniorMember" ) ) then
				aclGroupRemoveObject(aclGetGroup("Member"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "Member" ) ) then
				aclGroupRemoveObject(aclGetGroup("SeniorMember"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
			
			if isObjectInACLGroup ("user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")), aclGetGroup ( "Recruit" ) ) then
				aclGroupRemoveObject(aclGetGroup("Recruit"), "user."..tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			end
				
			if account then
				removeAccount(account)
			end]]
			
			local lockedAccs = getElementsByType ( "lockedAcc" )
			for theKey,lockedAcc in ipairs(lockedAccs) do
				if getElementData(lockedAcc, "name") == getElementData(source, "accName") then 
					destroyElement(lockedAcc)
				end                                                             
			end		
			
			setElementData(source, "accName", nil)
		end
end

function freeLockedAccs()
	local lockedAccs = getElementsByType ( "lockedAcc" )
	for theKey,lockedAcc in ipairs(lockedAccs) do
		if isElement (getElementData(lockedAcc, "player")) == false then 
			destroyElement(lockedAcc)
		end
	end	
end
--[[setTimer ( freeLockedAccs, 60000, 0 )

function vitaResourceStop()
	local players = getElementsByType("player")
	for _,player in pairs(players) do
		savePlayer ( player, "Race restart!")
	end
end
addEventHandler("onResourceStop", resourceRoot,vitaResourceStop)]]