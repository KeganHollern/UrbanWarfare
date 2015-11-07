/*
	File: start.sqf
	Description: Server initialiaztion for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

BRMini_GamesPlayed = BRMini_GamesPlayed + 1;

_fogThread = [] call BRGH_fnc_simpleFog;
_weatherThread = [] spawn BRGH_fnc_startWeather;
_lootThread = [] spawn BRGH_fnc_lootManager;

call BRGH_fnc_waitForPlayers;
if(BRMini_GamesPlayed > 1) then {
	BR_DT_PVAR = ["The next round is starting...",0,0.45,5,0];
	publicVariable "BR_DT_PVAR";
} else {
	BR_DT_PVAR = ["The first round is starting...",0,0.45,5,0];
	publicVariable "BR_DT_PVAR";
};
uiSleep 7;
BR_DT_PVAR = ["Welcome to Urban Warfare",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 6;
BR_DT_PVAR = ["Please report any bugs",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 6;
BR_DT_PVAR = ["Enjoy the round!",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 7;

BRMini_GameStarted = true;
publicVariable "BRMini_GameStarted";

"DISABLE_EVENTS = (findDisplay 46) displayAddEventHandler ['KeyDown',{true}];" call BRMini_RE;

_pos = (getMarkerPos "BRMini_SafeZone");
_roads = _pos nearRoads 150;	
{
	_pos = getposatl (_roads select floor(random(count(_roads))));
	_x setposatl _pos;
} forEach playableUnits;

uiSleep 1;
BR_DT_PVAR = ["3",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BR_DT_PVAR = ["2",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BR_DT_PVAR = ["1",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BRMini_InGame = true;
BR_DT_PVAR = ["GOOD LUCK!",0,0.45,1,0];
publicVariable "BR_DT_PVAR";

"(findDisplay 46) displayRemoveEventHandler ['KeyDown',DISABLE_EVENTS];" call BRMini_RE;

[] spawn BRGH_fnc_deathMessages;
[] spawn BRGH_fnc_startZoning;


waitUntil{!BRMini_InGame};

BRMini_ServerOn = false;

uiSleep 5;

_winners = (getMarkerPos "BRMini_SafeZone") nearObjects ["Man",300];
{
	if(alive _x && isplayer _x) then {
		_name = name _x;

		_index = BRMini_Winners find _name;
		if(_index == -1) then {
			_index = count(BRMini_Winners);
			BRMini_Winners set[count(BRMini_Winners),_name];
		};
		_score = 0;
		if(_index < count(BRMini_WinnerScores)) then {
			_score = (BRMini_WinnerScores select _index);
		};
		_score = _score + 1;
		BRMini_WinnerScores set[_index,_score];
		
		BR_DT_PVAR = [ format["%1 IS THE LAST MAN STANDING!",_name],0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		BR_DT_PVAR = ["CONGRATULATIONS!",0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		BR_DT_PVAR = ["YOU ARE AN URBAN WARFARE WINNER!",0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		_x setDamage 1;
		deleteVehicle _x;
	};
} forEach _winners;
terminate _lootThread;
uiSleep 4;

[[_fogThread,_weatherThread,_lootThread],[]] spawn BRGH_fnc_serverReset;