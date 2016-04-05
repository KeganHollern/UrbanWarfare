/*
	File: start.sqf
	Description: Server initialiaztion for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

call BRGH_fnc_findPlayarea;
call BRGH_fnc_mapSetup; //--- update black zone

BRMini_GamesPlayed = BRMini_GamesPlayed + 1;

//--- Start Weather
_fogThread = [] spawn BRGH_fnc_simpleFog; 
_weatherThread = [] spawn BRGH_fnc_startWeather;

//--- Start Loot
_lootThread = [] spawn BRGH_fnc_lootManager;

//--- Wait for min players
call BRGH_fnc_waitForPlayers;

//--- Announce round number
BR_DT_PVAR = [format["Round number %1 is starting...",BRMini_GamesPlayed],0,0.45,5,0];
publicVariable "BR_DT_PVAR";

//--- Start opening credit
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

//--- Announce round start
BRMini_GameStarted = true;
publicVariable "BRMini_GameStarted";

//--- Disable Input
"DISABLE_EVENTS = (findDisplay 46) displayAddEventHandler ['KeyDown',{true}];" call BRMini_RE;

//--- Teleport
_pos = (getMarkerPos "BRMini_SafeZone");
_roads = _pos nearRoads 150;	
{
	_pos = getposatl (_roads select floor(random(count(_roads))));
	moveOut _x;
	waitUntil{_x == (vehicle _x)};
	_x setposatl _pos;
} forEach allPlayers;

//--- Reset start region for dead players
call BRGH_fnc_resetQuads;

//--- Countdown to start
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

//--- Enable input again
"(findDisplay 46) displayRemoveEventHandler ['KeyDown',DISABLE_EVENTS];" call BRMini_RE;

//--- Start death messages and zoning
[] spawn BRGH_fnc_deathMessages;
[] spawn BRGH_fnc_startZoning;

//--- Wait till game end
waitUntil{!BRMini_InGame};

BRMini_ServerOn = false;

uiSleep 5;

//--- Announce all winners
_winners = (getMarkerPos "BRMini_SafeZone") nearObjects ["Man",300];
_numWinners = count(_winners);
{
	if(alive _x && isplayer _x) then {
		_name = name _x;
		
		//--- add a win to their profile
		[{
			_servers = profileNamespace getVariable ["UW_Servers",[]];
			_index = _servers find serverName;
			if(_index == -1) then {
				_index = _servers pushBack serverName;
				profileNamespace setVariable ["UW_Servers",_servers];
			};
			_wins = profileNamespace getVariable ["UW_Wins",[]];
			_numWins = 0;
			if(count(_wins) > _index) then {
				_numWins = _wins select _index;
			};
			_numWins = _numWins + 1;
			_wins set[_index,_numWins];
			profileNamespace setVariable  ["UW_Wins",_wins];
			saveProfileNamespace;
			
			UW_Wins = _numWins; //--- update their win counter in game
		}] remoteExec ["BIS_fnc_SPAWN",_x];
		
		//--- find winner data index & increment their score
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
		
		//--- announce name of winner (fix for when there are multiple winners to avoid confusion)
		if(_numWinners == 1) then {
			BR_DT_PVAR = [ format["%1 IS THE LAST MAN STANDING!",_name],0,0.45,10,0];
			publicVariable "BR_DT_PVAR";
		} else {
			BR_DT_PVAR = [ format["%1 IS ONE OF THE LAST MEN STANDING!",_name],0,0.45,10,0];
			publicVariable "BR_DT_PVAR";
		};
		uiSleep 5;
		BR_DT_PVAR = ["CONGRATULATIONS!",0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		BR_DT_PVAR = [format["%1 IS AN URBAN WARFARE WINNER!",_name],0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		
		//--- The winner wins a nice death & deletion
		_x setDamage 1;
		deleteVehicle _x;
	};
} forEach _winners;

//--- Fix for no annoucing when no one wins
if(_numWinners == 0) then {
	BR_DT_PVAR = ["NO ONE IS LEFT STANDING!",0,0.45,10,0];
	publicVariable "BR_DT_PVAR";
};

//--- Stop loot thread
terminate _lootThread;
uiSleep 4;

//--- reset server
[[_fogThread,_weatherThread,_lootThread],[]] spawn BRGH_fnc_serverReset;