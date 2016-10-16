/*
	fn_start
	
	Desolation Redux
	2016 Desolation Dev Team
	
	License info here and copyright symbol above
*/
disableUserInput false;

call BASE_fnc_initEventHandlers;

{
	if((toLower(_x) find "initclient") != -1) then {
		[] spawn (missionNamespace getVariable [_x,{DIAG_LOG "FAILED TO FIND FUNCTION";}]);
	};
} forEach BASE_var_Files;
0 cutRsc ["background","PLAIN",0];
