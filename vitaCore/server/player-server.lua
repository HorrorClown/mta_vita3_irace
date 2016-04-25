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

	mysql_query(g_mysql["connection"], "INSERT INTO `players` (`accountname`) VALUES ('"..accname.."');")
	
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
	local mysqlColor = table.save(colors)
	
	local lightcolors = {}
	lightcolors["rl"] = 255
	lightcolors["gl"] = 255
	lightcolors["bl"] = 255
	local mysqlLighrcolor = table.save(lightcolors)
	
	local archivements = {}	
	local mysqlArchivements = table.save(archivements)
	
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

	local accElement = createElement ( "userAccount" )
	setElementData(accElement, "AccountName", accname)
	setElementData(accElement, "PlayerName", _getPlayerName(player))
	setElementData(accElement, "Points", 0)	
	setElementData(accElement, "Level", "User")	
	
	loginPlayer(accname, password, "server", player)
end
addEvent("registerPlayer", true)
addEventHandler("registerPlayer", getRootElement(), registerPlayer)

function loginPlayer(_accname, _password, typ, playerSource)
	if typ == "server" then
		client = playerSource
	end
	if _accname and _password then
		if mysql_ping ( g_mysql["connection"] ) == false then
			onResourceStopMysqlEnd()
			onResourceStartMysqlConnection()
		end
		password = escapeString(_password)
		accname = escapeString(_accname)
		local player = mysql_query(g_mysql["connection"], "SELECT * FROM `players` WHERE `accountname` = '"..accname.."' LIMIT 0, 1")
		if player then
			--while true do
			local row = mysql_fetch_assoc(player)
			if not row then 
				triggerClientEvent ( client, "addNotification", getRootElement(), 1, 200, 50, 50, "Account not found.")
				return
			end
		
			if tostring(md5(_password)) ~= tostring(row["password"]) then
				triggerClientEvent ( client, "addNotification", getRootElement(), 1, 200, 50, 50, "Wrong password.")
				return
			end
			
			local lockedAccs = getElementsByType ( "lockedAcc" )
			for theKey,lockedAcc in ipairs(lockedAccs) do
				if getElementData(lockedAcc, "name") == _accname then triggerClientEvent ( client, "addNotification", getRootElement(), 1, 200, 50, 50, "Account already in use.") return false end
			end

			setElementData(client, "Userid", tonumber(row["id"]))
			setElementData(client, "AccountName", row["accountname"])
			setElementData(client, "Level", row["level"])
			setElementData(client, "memeActivated", tonumber(row["memeActivated"]))
			local donatorstring = row["donatordate"]
			setElementData(client, "donatordate", donatorstring)
			
			if tonumber(row["isDonator"]) == 1 then
				local removeDonator = false
				local donatorDate = split ( donatorstring, 46 )
				if type(donatorDate) == "table" and donatorDate[1] and donatorDate[2] and donatorDate[3] then
					local todayDate = getRealTime()
					if ( tonumber(donatorDate[3]) < todayDate.year+1900 ) or ( tonumber(donatorDate[2]) < todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 ) or ( tonumber(donatorDate[2]) <= todayDate.month+1 and tonumber(donatorDate[3]) <= todayDate.year+1900 and tonumber(donatorDate[1]) < todayDate.monthday ) then
						removeDonator = true
						setElementData(client, "isDonator", false)
						triggerClientEvent ( client, "addNotification", getRootElement(), 2, 155, 77, 77, "Your donation has expired.")
					end
				end
				
				if not removeDonator then
					setElementData(client, "isDonator", true)
				end
			else
				setElementData(client, "isDonator", false)
			end
			
				local accountPassword = tostring(math.random(111111, 999999))
				if getAccount(tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName"))) then
					removeAccount(getAccount(tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName"))))
				end
				addAccount(tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")), accountPassword)	
				local account = getAccount(tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
				
				if getElementData(client, "Level") == "Admin" then
					setPlayerTeam(client, adminTeam)
					aclGroupAddObject(aclGetGroup("Admin"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
					local players = getElementsByType("player")
					for _,iPly in pairs(players) do
						addPlayerArchivement(iPly, 38)
					end
				elseif getElementData(client, "Level") == "GlobalModerator" then
					setPlayerTeam(client, globalTeam)
					aclGroupAddObject(aclGetGroup("SuperModerator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))					
				elseif getElementData(client, "Level") == "Moderator" then
					setPlayerTeam(client, moderatorTeam)
					aclGroupAddObject(aclGetGroup("Moderator"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
				elseif getElementData(client, "Level") == "SeniorMember" then
					setPlayerTeam(client, seniorTeam)
					aclGroupAddObject(aclGetGroup("SeniorMember"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))					
				elseif getElementData(client, "Level") == "Member" then
					setPlayerTeam(client, memberTeam)
					aclGroupAddObject(aclGetGroup("Member"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
				elseif getElementData(client, "Level") == "Recruit" then
					setPlayerTeam(client, recruitTeam)
					aclGroupAddObject(aclGetGroup("Recruit"), "user."..tostring(getElementData(client, "Userid")).."_"..tostring(getElementData(client, "AccountName")))
				else
					setElementData(client, "Level", "User")
				end
				if getPlayerTeam(client) == false and getElementData(client, "isDonator") == true then
					setPlayerTeam(client, donatorTeam)
				end
				logOut(client)
				logIn(client, account, accountPassword)
			--end
			setElementData(client, "Skin",  tonumber(row["skin"]))
			setElementData(client, "Points", tonumber(row["points"]))
			setElementData(client, "Rank", tonumber(row["rank"]))
			setElementData(client, "Money", tonumber(row["money"]))
			setElementData(client, "WonMaps", tonumber(row["wonmaps"]))
			setElementData(client, "PlayedMaps", tonumber(row["playedmaps"]))
			setElementData(client, "DDMaps", tonumber(row["ddmaps"]))
			setElementData(client, "DMMaps", tonumber(row["dmmaps"]))
			setElementData(client, "SHMaps", tonumber(row["shmaps"]))
			setElementData(client, "RAMaps", tonumber(row["ramaps"]))
			setElementData(client, "DDWon", tonumber(row["ddwon"]))
			setElementData(client, "DMWon", tonumber(row["dmwon"]))
			setElementData(client, "SHWon", tonumber(row["shwon"]))
			setElementData(client, "RAWon", tonumber(row["rawon"]))
			setElementData(client, "shooterkills", tonumber(row["shooterkills"]))
			setElementData(client, "ddkills", tonumber(row["ddkills"]))
			setElementData(client, "betCounter", tonumber(row["betcounter"]))
			setElementData(client, "playedTimeCounter", tonumber(row["playedtimecounter"]))
			
			if row["wheels"] and tonumber(row["wheels"]) ~= 0 then
				setElementData(client, "Wheels", tonumber(row["wheels"]))
			end
			
			setElementData(client, "Backlights", tonumber(row["backlights"]))
			
			local color = table.load(row["vehcolor"])
			setElementData(client, "r1", color["r1"])
			setElementData(client, "r2", color["r2"])
			setElementData(client, "g1", color["g1"])
			setElementData(client, "g2", color["g2"])
			setElementData(client, "b1", color["b1"])
			setElementData(client, "b2", color["b2"])
			
			local lightcolor = table.load(row["lightcolor"])
			setElementData(client, "rl", lightcolor["rl"])
			setElementData(client, "gl", lightcolor["gl"])
			setElementData(client, "bl", lightcolor["bl"])

			setElementData(client, "TimeOnServer", tonumber(row["timeonserver"]))
			setElementData(client, "JoinTime", getTimestamp())
			
			local toptimeCount = getPlayerToptimeCount(client, "%[DM%]")
			setElementData(client, "TopTimes", toptimeCount)
			setElementData(client, "TopTimeCounter", toptimeCount)
			
			toptimeCount = getPlayerToptimeCount(client, "%[RACE%]")
			setElementData(client, "TopTimesRA", toptimeCount)
			
			setElementData(client, "KM", tonumber(row["km"]))
			setElementData(client, "WinningStreak", tonumber(row["winningstreak"]))
			setElementData(client, "Rank", tonumber(row["rank"]))
			
			local archivements = table.load(row["archivements"])
			setElementData(client, "Archivements", archivements)
			
			--OTHER
			setElementData(client, "isRandomSoundturnedON", 0)
			setElementData(client, "Bet", false)
			setElementData(client, "FPSaction", false)
			setElementData(client, "Pingaction", false)
			setElementData(client, "AFK", false)
			setElementData(client, "ghostmod", false)
			setElementData(client, "isLoggedIn", true)
			setElementData(client, "country", getPlayerCountry ( client ))
			
			syncArchivmentTableForPlayer(client)
			
			setElementData(client, "usedHorn", tonumber(row["usedHorn"]))
			
			--setElementData(client, "country", getPlayerCountry ( client ))
			if not getElementData(client, "TimeOnServer") then
			
				setElementData(client, "TimeOnServer", 0)
			end
			
			g_playerstat[client] = {}
			g_playerstat[client]["TimeTimer"] = setTimer(function (client)
				if getElementData(client, "TimeOnServer") then
					setElementData(client, "TimeOnServer", getElementData(client, "TimeOnServer")+1)
				end
			end, 1000, 0, client)
			
			triggerClientEvent ( client, "addNotification", getRootElement(), 2, 50, 200, 50, "Successfully logged in.")
			triggerClientEvent ( client, "hideLogin", getRootElement() )
			sendModesToClient(client)			
			
			local accElement = createElement ( "lockedAcc" )
			setElementData(accElement, "name", _accname)
			setElementData(accElement, "player", client)
			setElementData(client, "accName", _accname)
			--destroyBlipsAttachedTo(client)
			setElementData(client, "winningCounter", 0)
			setElementData(client, "hunterReachedCounter", 0)
			--end
		mysql_free_result(player)
		addPlayerArchivement( client, 1 )
		
		local accElements = getElementsByType ( "userAccount" )
		for theKey,accElement in ipairs(accElements) do
			if getElementData(accElement, "AccountName") == getElementData(client, "AccountName") then 
				callClientFunction(getRootElement(), "updatePlayerRanks")
				setElementData(accElement, "PlayerName", _getPlayerName(client))
				setElementData(accElement, "Level", getElementData(client, "Level"))
				setElementData(client, "accElement", accElement)
			end  
		end
		end
	end
end
addEvent("loginPlayer", true)
addEventHandler("loginPlayer", getRootElement(), loginPlayer)


function quitPlayer(reason)
	addPlayerArchivement(source, 37)
	
	savePlayer(source, reason)
	
	if getPlayerGameMode(source) == 0 then return true end
	callServerFunction(gRaceModes[getPlayerGameMode(source)].quitfunc, source)	
end
addEventHandler("onPlayerQuit", getRootElement(), quitPlayer)

--MySQL_debug = Logger.create("logs/mysqldebug.log")

function savePlayer(source, reason)
		if getElementData(source, "isLoggedIn") == true then
			if mysql_ping ( g_mysql["connection"] ) == false then
				onResourceStopMysqlEnd()
				onResourceStartMysqlConnection()
			end
			local accid = escapeString(getElementData(source, "Userid"))
			
			local atable = getElementData(source, "Archivements")
			local archivements_save = table.save(atable)
			
			local color = {}
			color["r1"] = getElementData(source, "r1")
			color["g1"] = getElementData(source, "g1")
			color["b1"] = getElementData(source, "b1")
			color["r2"] = getElementData(source, "r2")
			color["g2"] = getElementData(source, "g2")
			color["b2"] = getElementData(source, "b2")
			local mysqlColor = table.save(color)
			
			local lightcolor = {}
			lightcolor["rl"] = getElementData(source, "rl")
			lightcolor["gl"] = getElementData(source, "gl")
			lightcolor["bl"] = getElementData(source, "bl")
			local mysqlLightcolor = table.save(lightcolor)
			
			
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
			
			local sourceName = escapeString(_getPlayerName(source))
			if rollOldNick[source] and rollOldNick[source] ~= false then
				sourceName = escapeString(tostring(rollOldNick[source]))
			end
			
			local sql = "UPDATE `players` SET `accountname` = '"..tostring(getElementData(source, "AccountName")).."',\
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
												`lastactivity` = '"..tostring(LastActivity).."',\
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
			--MySQL_debug:addEntry(tostring(sql))
			mysql_query(g_mysql["connection"], sql)
			sql = nil
			
			if archivements_save ~= "return {{},}--|" then
				sql = "UPDATE `players` SET `archivements` = '"..archivements_save.."' \
											WHERE `id` = '"..accid.."' LIMIT 1 ;"
				mysql_query(g_mysql["connection"], sql)
				sql = nil
			end

			local account = getAccount(tostring(getElementData(source, "Userid")).."_"..tostring(getElementData(source, "AccountName")))
			
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
			end
			
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
setTimer ( freeLockedAccs, 60000, 0 )

function vitaResourceStop()
	local players = getElementsByType("player")
	for _,player in pairs(players) do
		savePlayer ( player, "Race restart!")
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()),vitaResourceStop)