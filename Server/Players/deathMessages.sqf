/*
	File: deathMessages.sqf
	Description: Player death messages for BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

uiSleep 10;
{
	if((_x distance (getMarkerPos "BRMini_SafeZone")) < 1000) then {
		_x addMPEventHandler ["MPKilled",{
			_dead = _this select 0;
			_killer = _this select 1;
			if(!isNull (_killer)) then {
				_killer = driver _killer;
			};
			if(isServer) then {
				_message = "";
				if((_dead distance (getMarkerPos "BRMini_SafeZone")) < 1000) then {
					if(!isNull _killer && isPlayer _killer && _killer == _dead) then {
						_message = format["<t color='#B30000'>%1</t> HAS COMMITTED SUICIDE",name _dead];
					};
					if(!isNull _killer && isPlayer _killer && _killer != _dead) then {
						diag_log "<DEATHMSGS>: Suicide?";
						_message = format["<t color='#B30000'>%1</t> WAS KILLED BY <t color='#2EB82E'>%2</t>",name _dead,name _killer];
					};
					if(!isNull _killer && isPlayer _killer && _killer == _dead && (_dead getVariable ["circleKill",false])) then {
						_message = format["<t color='#B30000'>%1</t> HAS DIED TO THE CIRCLE",name _dead];
					};
					if(_message == "") then {
						_message = format["<t color='#B30000'>%1</t> HAS DIED FOR AN UNKNOWN REASON",name _dead];
					};
				};
				if(_message != "") then {
					_message spawn {
						uisleep 0.5;
						_message = _this + format["<br/>%1 REMAIN",({alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]))];
						diag_log ("<DEATHMSGS>: " + toUpper(_message));
						BR_DT_PVAR = [toUpper(_message),0,0.45,5,0];
						publicVariable "BR_DT_PVAR";
					};
				};
			} else {
				if(_dead == player) then {
					if(!isNull _killer && alive _killer && isPlayer _killer && _killer != player) then {
						_killer spawn {
							_view = cameraView;
							_this switchCamera "EXTERNAL";
							waitUntil{alive player};
							player switchCamera _view;
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
	if((_unit distance (getMarkerPos "BRMini_SafeZone")) < 1000) then {
		BR_DT_PVAR = [format["%1 HAS DISCONNECTED. %2 REMAIN",_name,({alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]))],0,0.45,5,0];
		publicVariable "BR_DT_PVAR";
	};
}];
_count = {alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
while{true} do {
	waitUntil{!BRMini_InGame || _count <= 1 || _count != ({alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]))};
	_count = {alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
	if(!BRMini_InGame || _count <= 1) exitWith {};
};
removeMissionEventHandler ["HandleDisconnect",_OnDC];
{
	_x removeAllMPEventHandlers "MPKilled";
} forEach playableUnits;
BRMini_InGame = false;