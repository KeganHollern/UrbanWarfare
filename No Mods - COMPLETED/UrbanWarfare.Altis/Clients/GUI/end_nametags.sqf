/*
	File: end_nametags.sqf
	Description: Stop Nametags UI
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
if(!isNil "NAMETAGS_UI") then {
	removeMissionEventHandler ["Draw3D",NAMETAGS_UI];
	NAMETAGS_UI = nil;
};