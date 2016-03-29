/*
	File: reset_quads.sqf
	Description: Quadbike reset for UrbanWarfare
	Created By: Lystic
	Date: 03/27/2016
	Parameters: n/a
	Returns: n/a
*/

{
	_x setDamage 0;
	_x allowDamage false;
	_x setposatl ((BRMini_QuadData select _forEachIndex) select 0);
	_x setVectorUp (surfaceNormal ((BRMini_QuadData select _forEachIndex) select 0));
	_x setDir ((BRMini_QuadData select _forEachIndex) select 1);
} forEach (allMissionObjects "C_Quadbike_01_F");