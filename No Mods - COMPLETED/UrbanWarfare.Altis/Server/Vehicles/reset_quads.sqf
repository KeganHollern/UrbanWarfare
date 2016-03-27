/*
	File: reset_quads.sqf
	Description: Quadbike reset for UrbanWarfare
	Created By: Lystic
	Date: 03/27/2016
	Parameters: n/a
	Returns: n/a
*/

_positions = [
	[5456.846,14970.749,0],
	[5455.482,14971.886,0],
	[5454.012,14972.973,0],
	[5452.6,14974.136,0],
	[5497.217,15028.83,0],
	[5498.498,15027.602,0],
	[5499.889,15026.415,0],
	[5501.216,15025.156,0]
];
_directions = [
	37.3062,
	37.3062,
	37.3062,
	37.3062,
	221.293,
	221.293,
	221.293,
	221.293
];
{
	_x setposatl (_positions select _forEachIndex);
	_x setVectorUp (surfaceNormal (_positions select _forEachIndex));
	_x setDir (_directions select _forEachIndex);
} forEach (allMissionObjects "C_Quadbike_01_F");