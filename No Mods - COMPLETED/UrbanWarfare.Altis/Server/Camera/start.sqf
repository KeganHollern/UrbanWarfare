/*
	File: start.sqf
	Description: Camera initialiaztion for UrbanWarfare
	Created By: Lystic
	Date: 03/27/2016
	Parameters: n/a
	Returns: n/a
*/

if(!isNil "SPECUAV") then {
	deleteVehicle SPECUAV;
	publicVariable "SPECUAV";
};

_groundPOS = (getMarkerPos "BRMini_SafeZone");//--- TODO
_groundPOS set[2,0];
_uavPOS = _groundPOS vectorAdd [0,0,150];


//--- create uav & camera above black zone and center it on the black zone pos
SPECUAV = createVehicle ["B_UAV_01_F", _uavPOS, [], 0, "FLY"];
createVehicleCrew SPECUAV;
SPECUAV lockCameraTo [_groundPOS, [0]];
SPECUAV flyInHeight 150;

_wp = (group SPECUAV) addWaypoint [_groundPOS, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointLoiterRadius 150;


publicVariable "SPECUAV"; //--- tell clients to do their end of the camera stuff