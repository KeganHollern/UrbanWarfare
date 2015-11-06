
_house = _this;
_type = toLower(typeof _house);
_buildingType = "Residential";
_positions = [];
//--- Get the building type & positions
_index = res_buildings find _type;
if(_index != -1) then {
	_buildingType = "Residential";
	_positions = res_positions select _index;
} else {
	_index = mil_buildings find _type;
	if(_index != -1) then {
		_buildingType = "Military";
		_positions = mil_positions select _index;
	} else {
		_index = ind_buildings find _type;
		if(_index != -1) then {
			_buildingType = "Industrial";
			_positions = ind_positions select _index;
		} else {
			diag_log ["<LOOT>: Couldn't define building type: %1",_type];
		};
	};
};
//--- Check there are positions to spawn loot in
_positionCount = count(_positions);
if(_positionCount == 0) exitWith {};

//--- Read building configs
_cfgLootTypes = missionConfigFile >> "CfgLoot" >> _buildingType;
_pileChance = getNumber(_cfgLootTypes >> "lootChance");
_buildingChance = getNumber(_cfgLootTypes >> "spawnChance");
_typeChance = getArray(_cfgLootTypes >> "typeChance");
_gearChances = getArray(_cfgLootTypes >> "gearChance");

_highChance = _typeChance select 0;
_mediumChance = _typeChance select 1;
_lowChance = _typeChance select 2;

_weaponChance = _gearChances select 0;
_magazineChance = _gearChances select 1;
_gearChance = _gearChances select 2;
_clothingChance = _gearChances select 3;
_backpackChance = _gearChances select 4;

_minPiles = getNumber(missionConfigFile >> "CfgLoot" >> "minPiles");

if(random(100) < _buildingChance) then {
	_lootPositions = [];
	for "_i" from 1 to _minPiles do {
		if(count(_positions) == 0) exitWith {};
		_lootPositions pushBack (_positions deleteAt (floor(random(count(_positions)))));
	};
	{
		if(random(100) < _pileChance) then {
			_lootPositions pushBack _x;
		};
	} forEach _positions;
	{
		_pos = _house modelToWorld _x;
		_object = "groundWeaponHolder" createVehicle _pos;
		_object setPosASL (AGLToASL _pos);
		
		_usedLoot = [];
		_usedCount = [];
		scopeName "ExitLoop";
		for "_i" from 1 to (floor(random(3)) + 1) do {
			//--- Generate Loot Value
			_value = "HighValue";
			_rand = random(100);
			_total = _lowChance;
			if(_rand < _total) then {
				_value = "LowValue";
			} else {
				_total = _total + _mediumChance;
				if(_rand < _total) then {
					_value = "MediumValue";
				};
			};
			
			//--- Generate Gear Type W/O allowing broken loot piles
			_gearType = "";
			_max = _weaponChance + _magazineChance + _gearChance + _clothingChance + _backpackChance;
			_selectingLoot = true;
			while{_selectingLoot} do {
				_rand = random(_max);
				_value = _weaponChance;
				if(_rand < _value) then {
					_gearType = "weapons";
				} else {
					_value = _value + _magazineChance;
					if(_rand < _value) then {
						_gearType = "magazines";
					} else {
						_value = _value + _gearChance;
						if(_rand < _value) then {
							_gearType = "gear";
						} else {
							_value = _value + _clothingChance;
							if(_rand < _value) then {
								_gearType = "clothing";
							} else {
								_gearType = "backpacks";
								
							};
						};
					};
				};
				
				_index = _usedLoot find _gearType;
				if(_index == -1) then {
					_usedLoot pushBack _gearType;
					_usedCount pushBack 1;
					_selectingLoot = false;
				} else {
					_count = _usedCount select _index;
					if((_count+1) <= getNumber(missionConfigFile >> "CfgLoot" >> "Limits" >> ("max" + _gearType))) then {
						_selectingLoot = false;
						_usedCount set[_index,_count+1];
					};
				};
			};
			
			if(_i == 1) then {
				if !("weapons" in _usedLoot) then {
					_usedLoot pushBack "weapons";
					_usedCount pushBack 1;
				};
			};
			
			_lootList = getArray(missionConfigFile >> "CfgLoot" >> "LootTypes" >> _value >> _gearType);
			
			_total = 0;
			_items = [];
			_item = "";
			_i = 0;
			{
				_total = _total + (_x select 1);
			} forEach _lootList;
			_value = random(_total);
			{
				_newI = _i + (_x select 1);
				if(_value >= _i && _value < _newI) exitWith {
					_item = _x select 0;
				};
				_i = _newI;
			} forEach _lootList;
			
			switch(_gearType) do {
				case "weapons": {
					_object addWeaponCargoGlobal [_item,1];
					_mags = getArray(ConfigFile >> "CfgWeapons" >> _item >> "magazines");
					_configMagazines = configFile >> "CfgMagazines";
					while{true} do {
						if(count(_mags) == 0) exitWith {};
						_index = floor(random(count(_mags)));
						_mag = _mags deleteAt _index;
						if(isClass (_configMagazines >> _mag)) exitWith {
							_object addMagazineCargoGlobal [_mag,(floor(random 2)) + 1];
						};
					};
					breakTo "ExitLoop";
				};
				case "magazines": {
					_object addMagazineCargoGlobal [_mag,(floor(random 2)) + 1];
				};
				case "gear": {
					_object addItemCargoGlobal [_mag,1];
				};
				case "clothing": {
					_object addItemCargoGlobal [_mag,1];
				};
				case "backpacks": {
					_object addBackpackCargoGlobal [_mag,1];
				};
			};
			{
				_x reveal [_object,4];
			} forEach allPlayers;
		};
	} forEach _lootPositions;
};