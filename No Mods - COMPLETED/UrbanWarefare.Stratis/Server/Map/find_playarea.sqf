_minHouses = 50;
_area = 280;

diag_log "<MAP SETUP>: Finding a new play area";

while{true} do {
	_pos = [random(worldSize),random(worldSize),0];
	_houses = {toLower(typeof _x) in all_buildings} count(_pos nearObjects ["house",_area]);
	if(_houses > _minHouses && count(_pos nearRoads 150) > 0) exitWith {
		"BRMini_SafeZone" setMarkerPos _pos;
	};
};