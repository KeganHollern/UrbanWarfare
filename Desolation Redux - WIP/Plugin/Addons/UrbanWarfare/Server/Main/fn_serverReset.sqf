DIAG_LOG "<RESET>: CLEANING UP MAP";
call UW_fnc_mapCleanup;

DIAG_LOG "<RESET>: WAITING FOR THREADS";
if(typename _this == typename []) then {
	{waitUntil{scriptDone _x};} forEach (_this select 0);
	{waitUntil{completedFSM _x};} forEach (_this select 1);
};

DIAG_LOG "<RESET>: RESETING VARIABLES";
UrbanW_GameStarted = false;
UrbanW_ZoneStarted = false; 
UrbanW_InGame = false;
UrbanW_ServerOn = true; 

call UW_fnc_resetQuads;

DIAG_LOG "<RESET>: STARTING SERVER";
[] spawn UW_fnc_serverStart;