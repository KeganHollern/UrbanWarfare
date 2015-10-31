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
			if(isServer) then {
				if(!isNull (_killer)) then {
					_killer = driver _killer;
				};
				_message = "";
				if((_dead distance (getMarkerPos "BRMini_SafeZone")) < 1000) then {
					if(!isNull _killer && isPlayer(_killer) && _killer == _dead) then {
						_message = format["%1 HAS COMMITTED SUICIDE",name _dead];
					};
					if(!isNull _killer && isPlayer _killer && _killer != _dead) then {
						_message = format["%1 WAS KILLED BY %2",name _dead];
					};
					if(isNull _killer && (_dead getVariable ["circleKill",false])) then {
						_message = format["%1 HAS DIED TO THE CIRCLE",name _dead];
					};
				};
				if(_message != "") then {
					_message spawn {
						uisleep 0.5;
						BR_DT_PVAR = [_this + format[". %1 REMAIN",({alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]))],0,0.45,5,0];
						publicVariable "BR_DT_PVAR";
					};
				};
			};
		}];
	};
} forEach playableUnits;
_OnDC = addMissionEventHandler ["HandleDisconnect",{
	_unit = _this select 0;
	_name = _this select 3;
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