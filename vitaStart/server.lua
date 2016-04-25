function playerHere ( )
	triggerClientEvent ( "receiveCurrentTime", getRootElement(), getRealTime() )
end
addEvent( "playerHere", true )
addEventHandler( "playerHere", getRootElement(), playerHere )