/*
	File: initPlayerLocal.sqf
	Description: Client On Join Initialiaztion
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
UrbanW_BZoneObjects = [];
//--- fix for black zone not drawing in first round

UW_fnc_updateBlackZone = {
	params["_data"];
	_old = UrbanW_BZoneObjects;
	UrbanW_BZoneObjects = [];
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
		UrbanW_BZoneObjects pushBack _obj;
	} forEach _data;
	{
		deleteVehicle _x;
	} forEach _old;
};

[] spawn {
	scriptName "Black_Zone_Drawer";
	while{true} do {
		waitUntil{uiSleep 1; !isNil "UR_DRAWBLACKZONE"};
		[UR_DRAWBLACKZONE] call UW_fnc_updateBlackZone;
		UR_DRAWBLACKZONE = nil;
	};
};


onPreloadFinished {
	onPreloadFinished {};
	enableEnvironment false;
	call UW_fnc_clientSetup;
	[] spawn UW_fnc_clientStart;
};		
player linkItem "ItemMap";
player linkItem "ItemGPS";

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