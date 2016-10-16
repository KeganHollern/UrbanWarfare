
{deleteVehicle _x;} forEach allDead;
{deleteVehicle _x;} forEach ((getMarkerPos "UrbanW_SafeZone") nearObjects ["WeaponHolder",400]);
{
	_x setDamage 0; 
	_config = configFile >> "CfgVehicles" >> (typeof _x);
	_userActions = _config >> "UserActions";
	if(isClass _userActions) then {
		_doorNum = 1;
		for "_i" from 0 to count(_userActions)-1 do {
			_action = _userActions select _i;
			if(isClass _action) then {
				_name = configName _action;
				if(["OpenDoor",_name] call BIS_fnc_inString) then {
					 [_x, format['Door_%1_rot',_doorNum], format['Door_Handle_%1_rot_1',_doorNum], format['Door_Handle_%1_rot_2',_doorNum]] execVM "\A3\Structures_F\scripts\fn_DoorClose.sqf";
					_doorNum = _doorNum + 1;
				};
			};
		};
	};
} forEach ((getMarkerPos "UrbanW_SafeZone") nearObjects ["House",400]);
diag_log "<CLEANUP>: MAP CLEANED";