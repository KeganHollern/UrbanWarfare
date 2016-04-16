/*
	File: deathMessages.sqf
	Description: Player death messages for UW
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
scriptName "Death_Messages";
uiSleep 10;
{
	if((_x distance (getMarkerPos "UrbanW_SafeZone")) < 1000) then {
		//--- may double execute TODO: implement a double execute patch?
		_x addMPEventHandler ["MPKilled",{
			_dead = _this select 0;
			_killer = _this select 1;
			if(!isNull (_killer)) then {
				_killer = driver _killer;
			};
			if(isServer) then {
				_message = "";
				if((_dead distance (getMarkerPos "UrbanW_SafeZone")) < 1000) then {
					if(!isNull _killer && isPlayer _killer && _killer == _dead) then {
						_message = format["<t color='#B30000'>%1</t> HAS COMMITTED SUICIDE",toUpper name _dead];
					};
					if(!isNull _killer && isPlayer _killer && _killer != _dead) then {
						_message = format["<t color='#B30000'>%1</t> WAS KILLED BY <t color='#2EB82E'>%2</t>",toUpper name _dead,toUpper name _killer];
					};
					if(!isNull _killer && isPlayer _killer && _killer == _dead && (_dead getVariable ["circleKill",false])) then {
						_message = format["<t color='#B30000'>%1</t> HAS DIED TO THE CIRCLE",toUpper name _dead];
					};
					if(_message == "" && !isNull _dead) then {
						_message = format["<t color='#B30000'>%1</t> HAS DIED FOR AN UNKNOWN REASON",toUpper name _dead];
					};
				};
				if(_message != "") then {
					_message spawn {
						uisleep 0.5;
						_message = _this + format["<br/>%1 REMAIN",({alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]))];
						diag_log ("<DEATHMSGS>: " + _message);
						UR_DT_PVAR = [_message,0,0.45,5,0];
						publicVariable "UR_DT_PVAR";
					};
				};
			} else {
				if(_dead == player) then {
					UrbanW_ReportItems set[7,({alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]))+1];
					_start = UrbanW_ReportItems select 6;
					_alive = time - _start;
					UrbanW_ReportItems set[6,_alive];
					if(!isNull _killer && isPlayer _killer && _killer != player) then {
						UrbanW_ReportItems set[3,name _killer];
						UrbanW_ReportItems set[4,round((damage _killer)*100)];
						UrbanW_ReportItems set[5,player distance _killer];
						
						_killer spawn {
							_view = cameraView;
							_this switchCamera "EXTERNAL";
							waitUntil{alive player};
							player switchCamera _view;
						};
					};
					if(!isNull _killer && isPlayer _killer && _killer == player) then {
						UrbanW_ReportItems set[3,"Suicide"];
						UrbanW_ReportItems set[4,0];
						UrbanW_ReportItems set[5,0];
					};
					if(!isNull _killer && (player getVariable ["circleKill",false])&& isPlayer _killer && _killer == player) then {
						UrbanW_ReportItems set[3,"Circle"];
						UrbanW_ReportItems set[4,0];
						UrbanW_ReportItems set[5,0];
					};
					if(isNull _killer) then {
						UrbanW_ReportItems set[3,"Unknown"];
						UrbanW_ReportItems set[4,0];
						UrbanW_ReportItems set[5,0];
					};
				} else {
					if(_killer == player) then {
						_killData = UrbanW_ReportItems select 2;
						_hasKill = false;
						{
							if((_x select 0) == (name _dead)) exitWith {
								_hasKill = true;
							};
						} forEach _killData;
						if(!_hasKill) then {
							_newData = [];
							_newData pushBack (name _dead);
							_newData  pushBack (player distance _dead);
							_killData pushBack _newData;
							UrbanW_ReportItems set[2,_killData];
						};
					};
				};
				
			};
		}];
	};
} forEach playableUnits;
_OnDC = addMissionEventHandler ["HandleDisconnect",{
	_unit = _this select 0;
	_name = _this select 3;
	diag_log format["<DISCONNECT>: %1 DISCONNECTED",_name];
	if((_unit distance (getMarkerPos "UrbanW_SafeZone")) < 1000) then {
		UR_DT_PVAR = [format["%1 HAS DISCONNECTED<br/>%2 REMAIN",_name,({alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]))],0,0.45,5,0];
		publicVariable "UR_DT_PVAR";
	};
}];
_count = {alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]);
while{true} do {
	waitUntil{!UrbanW_InGame || _count <= 1 || _count != ({alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]))};
	_count = {alive _x && isplayer _x;} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",1000]);
	if(!UrbanW_InGame || _count <= 1) exitWith {};
};
removeMissionEventHandler ["HandleDisconnect",_OnDC];
{
	_x removeAllMPEventHandlers "MPKilled";
} forEach playableUnits;

if(UrbanW_Min_Players == 1) then {
	diag_log "Server in debug status. waiting 5 min to end round.";
	uiSleep 300;
};

UrbanW_InGame = false;