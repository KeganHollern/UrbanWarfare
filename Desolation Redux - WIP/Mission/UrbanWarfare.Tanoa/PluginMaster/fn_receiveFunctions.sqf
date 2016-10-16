/*
	fn_receiveFunctions
	
	Desolation Redux
	2016 Desolation Dev Team
	
	License info here and copyright symbol above
*/
private["_rFuncs"];

//10000 cutText [format["Receiving Functions\n%1/%2",0,BASE_var_TotalFiles],"BLACK FADED",0];
0 cutRsc ["background","PLAIN",0];
_rFuncs = [];
while{count(_rFuncs) < BASE_var_TotalFiles} do {
	{
		if(toLower(_x) in (allVariables missionNamespace)) then {
			if !(_x in _rFuncs) then {
				_rFuncs pushBack _x;
				//10000 cutText [format["Receiving Functions\n%1/%2",count(_rFuncs),BASE_var_TotalFiles],"BLACK FADED",0];
				0 cutRsc ["background","PLAIN",0];
				BASE_var_LastData = diag_tickTime;
			};
		};
	} forEach BASE_var_Files;
	//10000 cutText [format["Receiving Functions\n%1/%2",count(_rFuncs),BASE_var_TotalFiles],"BLACK FADED",0];
	0 cutRsc ["background","PLAIN",0];
	uiSleep 0.5;
};	
BASE_var_LastData = 0;

call BASE_fnc_addEvents;
call BASE_fnc_start;