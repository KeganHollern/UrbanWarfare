/*
	fn_receiveProgressData
	
	Desolation Redux
	2016 Desolation Dev Team
	
	License info here and copyright symbol above
*/
params["_functionList"];

if(BASE_var_TotalFiles == 0) then {
	BASE_var_Files = _functionList;
	BASE_var_TotalFiles = count(_functionList);
	[] spawn BASE_fnc_ReceiveFunctions;
};