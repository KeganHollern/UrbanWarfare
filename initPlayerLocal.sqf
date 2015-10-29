/*
	File: initPlayerLocal.sqf
	Description: Client On Join Initialiaztion
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
onPreloadFinished {
	onPreloadFinished {};
	enableEnvironment false;
	call BRGH_fnc_clientSetup;
	[] spawn BRGH_fnc_clientStart;
};		

//--- Map Texture Fix
if (getNumber ( missionConfigFile >> "briefing" ) != 1) then {
	if ( getClientState == "BRIEFING READ" ) exitWith {};
	waitUntil { getClientState == "BRIEFING SHOWN" };
	if ( !isNull findDisplay 53 ) then {
		ctrlActivate ( ( findDisplay 53 ) displayCtrl 107 );
	};
};
waitUntil { getClientState == "BRIEFING READ" };
waitUntil { !isNull findDisplay 12 }; 
ctrlActivate ( ( findDisplay 12 ) displayCtrl 107 );