/*
	File: start.sqf
	Description: Client initialiaztion for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
call BRGH_fnc_playerSetup;

BRMINI_ReportItems = [
	false, //--- Show report 0
	[], //--- Weapons 1
	[], //--- Kills 2
	"", //--- Killer / Winner 3
	0, //--- Killer HP if killed 4
	0, //--- Killed from 5
	0, //--- Time Alive 6
	1  //--- Finish Place 7
];

diag_log "<START>: START TAGS";
call BRGH_fnc_startTags;

//--- Lock them to the start region
[] spawn {
	scriptName "Start_Region_Lock";
	while{true} do {
		waitUntil{BRMini_GameStarted || (player distance (getmarkerpos "Spawn_Area")) > (((getmarkersize "Spawn_Area") select 0)*20)};
		if(BRMini_GameStarted) exitWith {}; 
		
		_pos = (getmarkerpos "Spawn_Area");
		_x = (_pos select 0) + (random(20)-10);
		_y = (_pos select 1) + (random(20)-10);
		(vehicle player) setposatl [_x,_y,0];
	};
};

diag_log "<START>: CHECK GAME IN PROGRESS";
_count = ({alive _x && isplayer _x} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",500]));
if(_count > 0) exitWith {
	["THE GAME IS IN PROGRESS! PLEASE WAIT!",0,0.45,5,0] call BIS_fnc_dynamicText;
	if(str(fnc_BRCamera) != "{}") then {
		hintSilent "Press TAB To enter spectator mode!";	
	};
	_keybinds = (findDisplay 46) displayAddEventHandler ["KeyDown",{if((_this select 1) == 15) then {(getMarkerPos "BRMini_SafeZone") spawn fnc_BRCamera;};false}];
	waitUntil {[] call BRGH_fnc_updateInGameGUI; ({alive _x && isplayer _x} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",500])) == 0 || !(alive player)};
	(findDisplay 46) displayRemoveEventHandler ["KeyDown",_keybinds];
	call BRGH_fnc_endTags;
	call BRGH_fnc_endSpectate;
	if !(alive player) exitWith {};
	_body = player;
	player setDamage 1;
	hideBody _body;
};
["<t align='center' color='#FFFFFF'>WAITING FOR THE ROUND TO START</t>"] call BRGH_fnc_updateInGameGUI;
waitUntil{BRMini_GameStarted};

[""] call BRGH_fnc_updateInGameGUI; //--- clear header
call BRGH_fnc_endTags;

diag_log "<START>: TAGS STOPPED";

diag_log "<START>: CLEANING BLUEZONE";
{
		deleteVehicle _x;
} forEach BRMINI_ZoneObjects;
BRMINI_ZoneObjects = [];

waitUntil{(player distance (getMarkerPos "BRMini_SafeZone")) < 500};
player setUnitRecoilCoefficient 2.4;
uiSleep 3;
BRMINI_ReportItems set [6,time];
player setVariable ["circleKill",false,true];
[] spawn BRGH_fnc_circleDamage;
player allowDamage true;
BRMINI_ReportItems set[0,true];
diag_log "<START>: ROUND STARTED";