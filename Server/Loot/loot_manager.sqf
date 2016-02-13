/*
	Loot Manager - Created By: Lystic
	Date: 1 Nov 2015	
*/
diag_log "LOOT MANAGER: started";

while{true} do {
	{
		if(alive _x && (_x distance (getMarkerPos "BRMini_SafeZone")) < 1000) then {
			_building = nearestObject [_x,"House"];
			_hasVar = _building getVariable ["SpawnedLoot",false];
			if !(_hasVar) then {
				_building setVariable ["SpawnedLoot",true];
				if(toLower(typeof _building) in all_buildings) then {
					diag_log "LOOT MANAGER: spawning loot";
					[_building,BRGH_fnc_spawnLoot] execFSM 'FSM\call.fsm';
				};
			};
		};
	} forEach allPlayers;
};
