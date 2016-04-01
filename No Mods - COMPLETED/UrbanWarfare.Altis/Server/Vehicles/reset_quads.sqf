/*
	File: reset_quads.sqf
	Description: Quadbike reset for UrbanWarfare
	Created By: Lystic
	Date: 03/27/2016
	Parameters: n/a
	Returns: n/a
*/

{
	deleteVehicle _x;
} forEach (allMissionObjects "C_Quadbike_01_F");

{
	_quad = "C_Quadbike_01_F" createVehicle (_x select 0);
	_quad setposatl (_x select 0);
	_quad setDir (_x select 1);
	_quad allowDamage false;
} forEach BRMini_QuadData;