diag_log "Starting Urban Warfare on Client";
disableSerialization;

UrbanW_GameStarted = false;
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
	
player linkItem "ItemMap";
player linkItem "ItemGPS";

enableEnvironment false;

call UW_fnc_clientSetup;
1 fadeSound 2;
1 fadeMusic 2;
0 cutRsc ["background","BLACK IN",0];
[player,true] remoteExec ["enableSimulationGlobal",2];
[player,false] remoteExec ["hideObjectGlobal",2];
player allowDamage true;
[] spawn UW_fnc_clientStart;