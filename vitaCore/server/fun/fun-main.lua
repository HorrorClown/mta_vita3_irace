--[[
Project: vitaCore
File: fun-main.lua
Author(s):	Sebihunter
]]--


gFunMinimodes = {
[1] = { name = "Ware", startfunc = "startFunWare", endfunc = "endFunWare", joinfunc = "joinFunWare", quitfunc = "quitFunWare", wastedfunc = "wastedFunWare", img = "files/minigames_vote/games_ware.png", imghover = "files/minigames_vote/games_ware_hover.png"},
[2] = { name = "Hay", startfunc = "startFunHay", endfunc = "endFunHay", joinfunc = "playerJoinHay", quitfunc = "quitFunHay", wastedfunc = "playerWastedHay", img = "files/minigames_vote/games_hay.png", imghover = "files/minigames_vote/games_hay_hover.png"},
[3] = { name = "GunGame", startfunc = "startFunGG", endfunc = "endFunGG", joinfunc = "playerJoinGG", quitfunc = "quitFunGG", wastedfunc = "playerWastedGG", img = "files/minigames_vote/games_gungame.png", imghover = "files/minigames_vote/games_gungame_hover.png"},
[4] = { name = "Running Men", startfunc = "startFunRG", endfunc = "endFunRG", joinfunc = "playerJoinRG", quitfunc = "quitFunRG", wastedfunc = "playerWastedRG", img = "files/minigames_vote/games_rg.png", imghover = "files/minigames_vote/games_rg_hover.png"},
[5] = { name = "Sumo", startfunc = "startFunSU", endfunc = "endFunSU", joinfunc = "playerJoinSU", quitfunc = "quitFunSU", wastedfunc = "playerWastedSU", img = "files/minigames_vote/games_su.png", imghover = "files/minigames_vote/games_su_hover.png"}
}

gGamemodeFUN = 4
gElementFUN = createElement("elementFUN")
gCurrentFunMinimode = false

gVoteTimer = false
gModeStartTimer = false

function startVoteFUN()
	setElementData(gElementFUN, "rankingboard", {})
	local leftSeconds = 20
	setElementData(gElementFUN , "mapname", "Voting")
	gVoteTimer = setTimer(
		function()
			local _, leftSeconds = getTimerDetails(gVoteTimer)
			if leftSeconds == 1 then
				local voteMinigames = {}
				for i,v in ipairs(gFunMinimodes) do
					voteMinigames[#voteMinigames+1] = {}
					voteMinigames[#voteMinigames].votes = 0
					voteMinigames[#voteMinigames].id = i
				end
				for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
					local pVote = getElementData(v, "vitaVoteMi")
					if voteMinigames[pVote] then voteMinigames[pVote].votes = voteMinigames[pVote].votes+1 end
				end
				
				table.sort(voteMinigames, 
				function(a,b)
					return a.votes > b.votes
				end
				)
				local winVote = voteMinigames[1].id
				
				
				for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
					if winVote == getElementData(v, "vitaVoteMi") and #getGamemodePlayers(gGamemodeFUN) > 1 then
						addPlayerArchivement(v, 75)
					end				
					triggerClientEvent ( v, "setLeftTimeVote", getRootElement(), "Starting mode '"..gFunMinimodes[winVote].name.."'..." )
					triggerClientEvent ( v, "voteWonMode", getRootElement(), winVote )
					triggerClientEvent ( v, "addNotification", getRootElement(), 3, 100,100,100, "Starting mode '"..gFunMinimodes[winVote].name.."'." )
				end
				
				gModeStartTimer = setTimer(function(winVote)
					for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
						triggerClientEvent ( v, "hideMinigamesVote", getRootElement() )
					end
					gCurrentFunMinimode = winVote
					loadModeFUN()
				end, 3000, 1, winVote)
			else
				triggerClientEvent ( getRootElement(), "setLeftTimeVote", getRootElement(), leftSeconds-1 )
			end
		end
	,1000, leftSeconds )
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		triggerClientEvent ( v, "startMinigamesVote", getRootElement(), gFunMinimodes, leftSeconds )
	end
end

function loadModeFUN()
	callServerFunction(gFunMinimodes[gCurrentFunMinimode].startfunc)
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		callServerFunction(gFunMinimodes[gCurrentFunMinimode].joinfunc, v)
	end
end

function unloadModeFUN()
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		callServerFunction(gFunMinimodes[gCurrentFunMinimode].quitfunc, v)
		setElementData(v, "state", "waiting")
	end
	callServerFunction(gFunMinimodes[gCurrentFunMinimode].endfunc)
	gCurrentFunMinimode = false
	setElementData(gElementFUN , "mapname", false)
end

function joinFUN(player)
	--DISABLING MODE
	--if player then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This gamemode is deactivated.") return false end
	
	if getPlayerGameMode(player) == gGamemodeFUN then return false end
	if #getGamemodePlayers(gGamemodeFUN) >= gRaceModes[gGamemodeFUN].maxplayers then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This gamemode is currently full.") return false end
	
	setElementData(player, "gameMode", gGamemodeFUN)
	setElementInterior(player, 0)
	setElementAlpha(player, 255)
	setElementData(player, "AFK", false)
	toggleControl ( player, "enter_exit", true )

	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		if v ~= player then
			setElementVisibleTo ( gPlayerBlips[player], v, true )
			setElementVisibleTo ( gPlayerBlips[v], player, true )
		end
	end
	
	setElementDimension(player, gGamemodeFUN)
	setElementData(player, "mapname", false)
	triggerClientEvent ( player, "addNotification", getRootElement(), 2, 15,150,190, "You joined 'Minigames'." )
	triggerClientEvent ( player, "hideSelection", getRootElement() )
	outputChatBoxToGamemode ( "#CCFF66:JOIN: #FFFFFF"..getPlayerName(player).."#FFFFFF has joined the gamemode.", gGamemodeFUN, 255, 255, 255, true )

	setElementData(player, "state", "waiting")
	
	if gCurrentFunMinimode then
		callServerFunction(gFunMinimodes[gCurrentFunMinimode].joinfunc, player)
	else
		if isTimer(gVoteTimer) then
			local _, leftTimer = getTimerDetails(gVoteTimer)
			triggerClientEvent ( player, "startMinigamesVote", getRootElement(), gFunMinimodes, leftTimer )
		else
			if isTimer(gModeStartTimer) then else
				startVoteFUN()
			end
		end
	end
end
addEvent("joinFUN", true)
addEventHandler("joinFUN", getRootElement(), joinFUN)

function quitFUN(player)
	if getPlayerGameMode(player) ~= gGamemodeFUN then return false end
		
	--killFUNPlayer(player, true)
	triggerClientEvent ( player, "hideMinigamesVote", getRootElement() )
	
	if gCurrentFunMinimode then
		callServerFunction(gFunMinimodes[gCurrentFunMinimode].quitfunc, player)
	end	
	
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		if v ~= player then
			setElementVisibleTo ( gPlayerBlips[player], v, false )
			setElementVisibleTo ( gPlayerBlips[v], player, false )
		end
	end
	
	setElementData(player, "gameMode", 0)
	setElementData( player, "ghostmod", false )
	spawnPlayer(player, 0,0,0)
	setElementDimension(player, 0)
	setElementInterior(player, 0)
	setElementFrozen(player, true)
	outputChatBoxToGamemode ( "#FF6666:QUIT: #FFFFFF"..getPlayerName(player).."#FFFFFF has left the gamemode.", gGamemodeFUN, 255, 255, 255, true )

	if #getGamemodePlayers(gGamemodeFUN) == 1 then
		for i,v in pairs(getGamemodePlayers(gGamemodeFUN)) do
			triggerClientEvent(v, "foreveraloneClient",getRootElement())
			addPlayerArchivement(v, 64)
		end
	end
	
	if #getGamemodePlayers(gGamemodeFUN) == 0 then
		if gCurrentFunMinimode then
			unloadModeFUN()
		else
			if isTimer(gVoteTimer) then killTimer(gVoteTimer) end
			if isTimer(gModeStartTimer) then killTimer(gModeStartTimer) end
			setElementData(gElementFUN , "mapname", false)
		end
	end
end
addEvent("quitFUN", true)
addEventHandler("quitFUN", getRootElement(), quitFUN)


function killFUNPlayer(player, noSpectate, killer, weapon)
	if isInGamemode(player, gGamemodeFUN) == false then return end
	if gCurrentFunMinimode then
		callServerFunction(gFunMinimodes[gCurrentFunMinimode].wastedfunc, player, killer, weapon)
	end	
end

function onPlayerWastedFUN(ammo, killer, killerWeapon, bodypart, stealth)
	if isInGamemode(source, gGamemodeFUN) then
		killFUNPlayer(source, false, killer, killerWeapon)
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerWastedFUN )