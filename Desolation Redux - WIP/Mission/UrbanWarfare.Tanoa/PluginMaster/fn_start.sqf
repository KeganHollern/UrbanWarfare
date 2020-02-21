/*
 * Desolation Redux
 * http://desolationredux.com/
 * © 2016 - 2019 Desolation Dev Team
 * 
 * This work is licensed under the Arma Public License Share Alike (APL-SA) + Bohemia monetization rights.
 * To view a copy of this license, visit:
 * https://www.bistudio.com/community/licenses/arma-public-license-share-alike/
 * https://www.bistudio.com/monetization/
 */
 
//disableuserinput false;
params["_functionList"];

diag_log "<PluginManager>: INFO: Starting initClient's...";


private _eventScripts = [[],[]];
{

	// SCRIPT EVENTS
	_isStartClient = [_x,"_initClient"] call BASE_fnc_hasSuffix;
	_isStartClientLocal = [_x,"_initPlayerLocal"] call BASE_fnc_hasSuffix; // Same as initClient (named in arma like this)
	_isEventScriptRespawn = [_x,"_onPlayerRespawn"] call BASE_fnc_hasSuffix;
	_isEventScriptKilled = [_x,"_onPlayerKilled"] call BASE_fnc_hasSuffix;

	if(_isStartClient || _isStartClientLocal) then {
		[player,didJIP] spawn (missionNamespace getVariable [_x,{DIAG_LOG FORMAT ["<PluginManager>: ERROR: FAILED TO FIND FUNCTION: %1",_x];}]);
	};
	if(_isEventScriptRespawn) then {
		(_eventScripts select 0) pushBack _x;
	};
	if(_isEventScriptKilled) then {
		(_eventScripts select 1) pushBack _x;
	};


	// KEY EVENTS
	if((toLower(_x) find "keydown") != -1) then {
		_code = missionNamespace getVariable [_x,{}];
		
		["KEYDOWN", _code] call BASE_fnc_addEventHandler;
	};
} forEach _functionList;

diag_log format ["<PluginManager>: INFO: Function count: %1",count(_functionList)];

_eventScripts call BASE_fnc_initEventScripts; //--- Start init events (onPlayerRespawn | onPlayerKilled)
[player,didJIP] remoteExec ["BASE_fnc_runInitPlayerServer",2]; //-- Run initPlayerServer functions on server

[] spawn BASE_fnc_startActionManager; //--- start action management
[] spawn BASE_fnc_initKeybindUI; //--- start unmodded custom controls ui thread (this doesnt work as far as I know (rofl))
[] spawn BASE_fnc_initKeyEventHandlers; //--- Key events

// initialize player events, mission events and locations

waitUntil{!isNil "BASE_var_playerEvents"};
//if not overriden | init events
_override = BASE_var_playerEvents select 0;
if(!_override) then {
	call BASE_fnc_initPlayerEvents;
};

waitUntil{!isNil "BASE_var_missionEventsClient"};
_override = BASE_var_missionEventsClient select 0;
if(!_override) then {
	call BASE_fnc_initMissionEventsClient;
};

waitUntil{!isNil "BASE_var_playerActionEvents"};
_override = BASE_var_playerActionEvents select 0;
if(!_override) then {
	call BASE_fnc_initPlayerActionEvents;
};

waitUntil{!isNil "BASE_var_Locations"};
{
	_x call BASE_fnc_createLocation;
} forEach BASE_var_Locations;
diag_log format ["<PluginManager>: INFO: Created %1 location(s)!",count(BASE_var_Locations)];