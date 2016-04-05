/*
	File: setup.sqf
	Description: Server one-time setup for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

BRMini_ZoneStarted = false;
BRMini_InGame = false;
BRMini_ServerOn = true;

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


BRMini_QuadData = [];
{
	BRMini_QuadData pushBack [getposatl _x,getdir _x];
} forEach (allMissionObjects "C_Quadbike_01_F");

BRMini_Winners = [];
BRMini_WinnerScores = [];

BRMini_GamesPlayed = 0;
br_maxFogHeight = 200;
br_maxFogDensity = 0.04;
br_maxFogStrength = 0.1;

call BRGH_fnc_serverConfig;
//--- TODO: Fix Vehicle Handler Check call BRGH_fnc_vehicleHandler;

BRMini_RE = compileFinal '
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