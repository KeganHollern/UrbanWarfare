/*
	File: setup.sqf
	Description: Client one-time Setup
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

diag_log "<START>: ONE TIME SETUP STARTED";
BRMINI_ZoneObjects = [];
BRMINI_ReportItems = [];

call BRGH_fnc_setupGUI;
call BRGH_fnc_createInGameGUI;

call BRGH_fnc_clientWeather;

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
_wins set[_index,_numWins];
profileNamespace setVariable  ["UW_Wins",_wins];
saveProfileNamespace;

UW_WINS = _numWins;
[] spawn {
	scriptName "Win_Variable_Updater";
	while{true} do {
		player setVariable ["UW_WinRars",UW_WINS,true];
		waitUntil{uiSleep 1; ((player getVariable ["UW_WinRars",-1]) != UW_Wins)}; 
	};
};



//--- TODO: Fix AFK Timer [] spawn BRGH_fnc_afkTimer;

//--- Setup bird effect
0 fadeMusic 0.5;
playMusic "BirdsEffect";
addMusicEventHandler["MusicStop",{playMusic "BirdsEffect";}];

enableRadio false;
enableSentences false;
showSubtitles false;
0 fadeRadio 0;
setObjectViewDistance [1000,0];
setViewDistance 1500;

[] spawn BRGH_fnc_autoReload;
[] spawn BRGH_fnc_StartSpectator;

[] spawn {
	scriptName "Player_Grouping_Fix";
	while{true} do {
		setGroupIconsVisible [false,false];
		waitUntil{count(units (group player)) > 1};
		[player] joinSilent (creategroup (side player));
		{
			if(count(units _x) == 0 && local _x) then {
				deleteGroup _x;
			};
		} forEach allGroups;
	};
};

[] spawn {
	scriptName "Limited_Third_Person";
	while{true} do {
		waitUntil{vehicle player == player && (currentWeapon player) != "" && cameraView == "External" && cameraon == player};
		player switchCamera "Internal";
	};
};

(findDisplay 46) displayAddEventHandler ["KeyDown",{
	_key = _this select 1;
	_success = false;
	if(_key in (ActionKeys "getOver")) then {
		if((inputAction "Turbo" > 0) || (inputAction "MoveFastForward" > 0) || (speed player > 15)) then {
			[] spawn BRGH_fnc_doJump;
			_success = true;
		};
	};
	_success;
}];

"Animation" addPublicVariableEventHandler {
	(_this select 1) spawn BRGH_fnc_Animation;
};

"BR_LS_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BR_lightning;
};

"BR_DRAWZONE" addPublicVariableEventHandler {
	_this spawn {
		_old = BRMINI_ZoneObjects;
		BRMINI_ZoneObjects = [];
		_data = _this select 1;
		_textures = [];
		{
			_type = _x select 0;
			_position = _x select 1;
			_dir = _x select 2;
			_texture = _x select 3;
			_obj = _type createVehicleLocal _position;
			_obj setDir _dir;
			_obj setPosATL _position;
			_obj enableSimulation false;
			_textures set [count(_textures),_texture];
			BRMINI_ZoneObjects set [count(BRMINI_ZoneObjects),_obj];
		} forEach _data;
		{	
			_x setObjectTexture[0,_textures select _forEachIndex];
		} forEach BRMINI_ZoneObjects;
		{
			deleteVehicle _x;
		} forEach _old;
	};
};

"BR_ServerRainValue" addPublicVariableEventHandler {
	10 setRain ((_this select 1) select 0);
	10 setGusts ((_this select 1) select 0);
};

"BR_SF_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BRGH_fnc_clientFog;
};

"BR_DT_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BIS_fnc_dynamicText;
};