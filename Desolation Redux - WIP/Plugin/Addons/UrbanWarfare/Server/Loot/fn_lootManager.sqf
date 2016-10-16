diag_log "LOOT MANAGER: started";
scriptName "Loot_Manager";
while{true} do {
	{
		if(alive _x && (_x distance (getMarkerPos "UrbanW_SafeZone")) < 1000) then {
			_building = nearestObject [_x,"House"];
			_hasVar = _building getVariable ["SpawnedLoot",false];
			if !(_hasVar) then {
				_building setVariable ["SpawnedLoot",true];
				if(toLower(typeof _building) in all_buildings) then {
					diag_log "LOOT MANAGER: spawning loot";
					[_building,UW_fnc_spawnLoot] execFSM 'FSM\call.fsm';
				};
			};
		};
	} forEach allPlayers;
};
