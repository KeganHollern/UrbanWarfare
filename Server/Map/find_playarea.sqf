_minHouses = 50;
_area = 280;

while{true} do {
	_pos = [random(worldSize),random(worldSize),0];
	_houses = {(typeof _x) in all_buildings}count(_pos nearObjects ["house",280]);
	if(_houses > _minHouses) exitWith {
		"BRMini_SafeZone" setMarkerPos _pos;
	};
};