/*
	File: start_nametags.sqf
	Description: Start Nametags UI
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

if(isNil "NAMETAGS_UI") then {
	NAMETAGS_UI = addMissionEventHandler ["Draw3d",{
		{
			if(alive _x && isplayer _x && (_x distance (markerPos "Spawn_Area")) < 100) then {
				_wins = _x getVariable ["UW_WinRars",0];
				drawIcon3D ["", [1,1,1,1], (ASLtoATL (eyepos _x)) vectorAdd [0,0,0.3], 0, 0, 0, (name _x) + " | " + str(_wins) + " Win" + (if(_wins > 1) then {"s"} else {""}), 1, 0.05, "PuristaMedium"];
			};
		} forEach allUnits;
	}];
};