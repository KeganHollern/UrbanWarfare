/*
	File: initPlayerLocal.sqf
	Description: Client On Join Initialiaztion
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
BRMINI_BZoneObjects = [];
//--- fix for black zone not drawing in first round
"BR_DRAWBLACKZONE" addPublicVariableEventHandler {
	_data = _this select 1;
	_old = BRMINI_BZoneObjects;
	BRMINI_BZoneObjects = [];
	{
		_type = _x select 0;
		_position = _x select 1;
		_dir = _x select 2;
		_texture = _x select 3;
		
		_obj = _type createVehicleLocal _position;
		_obj setDir _dir;
		_obj setPosATL _position;
		_obj setObjectTexture [0,_texture];
		_obj enableSimulation false;
		BRMINI_BZoneObjects pushBack _obj;
	} forEach _data;
	{
		deleteVehicle _x;
	} forEach _old;
};

onPreloadFinished {
	onPreloadFinished {};
	enableEnvironment false;
	call BRGH_fnc_clientSetup;
	[] spawn BRGH_fnc_clientStart;
};		
player linkItem "ItemMap";
player linkItem "ItemGPS";

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