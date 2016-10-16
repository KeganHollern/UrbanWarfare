/*
	fn_timeoutCheck
	
	Desolation Redux
	2016 Desolation Dev Team
	
	License info here and copyright symbol above
*/
while{BASE_var_LastData != 0} do {
	if((BASE_var_LastData + 60) < diag_tickTime && BASE_var_LastData != 0) then {
		diag_log "TIMEOUT ON JOIN";
		endMission "FAIL";
	};
	uiSleep 1;
};