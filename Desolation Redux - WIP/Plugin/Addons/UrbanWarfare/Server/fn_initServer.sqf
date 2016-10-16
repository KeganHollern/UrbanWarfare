[] spawn {
	UrbanW_GameStarted = false;
	call UW_fnc_serverSetup;
	call UW_fnc_serverStart;
};