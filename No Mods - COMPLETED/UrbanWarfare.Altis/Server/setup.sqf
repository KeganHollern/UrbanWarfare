/*
	File: setup.sqf
	Description: Server one-time setup for UW
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

UrbanW_ZoneStarted = false;
UrbanW_InGame = false;
UrbanW_ServerOn = true;

[] spawn {
	scriptName "Server_Group_Management";
	while{true} do {
		uiSleep 1;
		{
			if(count(units _x) == 0 && local _x) then {
				deleteGroup _x;
			};
		} forEach allGroups;
	};
};


UrbanW_QuadData = [];
{
	UrbanW_QuadData pushBack [getposatl _x,getdir _x];
} forEach (allMissionObjects "C_Quadbike_01_F");

UrbanW_Winners = [];
UrbanW_WinnerScores = [];

UrbanW_GamesPlayed = 0;
UR_maxFogHeight = 200;
UR_maxFogDensity = 0.04;
UR_maxFogStrength = 0.1;

call UW_fnc_serverConfig;
//--- TODO: Fix Vehicle Handler Check call UW_fnc_vehicleHandler;

UrbanW_RE = compileFinal '
	_script = if(typename _this == "STRING") then {compile _this} else {_this};
	_agent = createAgent ["LOGIC",[0,0,0],[],0,"NONE"];
	_agent addMPEventHandler ["MPKilled",_script];
	_agent setDamage 1;
	deleteVehicle _agent;
';

//--- Fix for BI's getServerVariable server backdoor
"BIS_fnc_getServerVariable_packet" addPublicVariableEventHandler {
	_var = _this select 1;
	_target = _var select 0;
	_variab = _var select 1;
	diag_log format["<HACKS>: %1('%2') just tried to get the variable %3 (hacking?)",name _target, getplayeruid _target, _variab];
};

mil_positions = [];
mil_buildings = [];
ind_positions = [];
ind_buildings = [];
res_positions = [];
res_buildings = [];
all_buildings = [];

{
	mil_positions pushBack (_x select 1);
	mil_buildings pushBack toLower(_x select 0);
} forEach getArray(missionConfigFile >> "CfgLoot" >> "BuildingTypes" >> "military");
{
	ind_positions pushBack (_x select 1);
	ind_buildings pushBack toLower(_x select 0);
} forEach getArray(missionConfigFile >> "CfgLoot" >> "BuildingTypes" >> "industrial");
{
	res_positions pushBack (_x select 1);
	res_buildings pushBack toLower(_x select 0);
} forEach getArray(missionConfigFile >> "CfgLoot" >> "BuildingTypes" >> "residential");

all_buildings = mil_buildings + ind_buildings + res_buildings;

diag_log format["LOOT MANAGER: buildings loaded: %1",count(all_buildings)];