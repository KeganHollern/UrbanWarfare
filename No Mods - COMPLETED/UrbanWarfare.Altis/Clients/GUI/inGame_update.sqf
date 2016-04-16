/*
	File: inGame_update.sqf
	Description: update in game UI with custom message / number of players remaining
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
if(count(_this) == 0) then {
	_getCount = {
		private["_count"];
		_count = ({alive _x && isplayer _x} count((getMarkerPos "UrbanW_SafeZone") nearObjects ["Man",500]));
		_count;
	};
	_count = call _getCount;
	_s = if(_count > 1) then {"S"} else {""};
	_text = format["<t align='center' color='#FFFFFF'>%1 PLAYER%2 REMAINING</t>",_count,_s];
	with uinamespace do {
		if(!isNull CTRL_INGAME_HEADER) then {
			CTRL_INGAME_HEADER ctrlSetStructuredText parseText _text;
		};
	};
	waitUntil{_count != (call _getCount);};
} else {
	with uinamespace do {
		if(!isNull CTRL_INGAME_HEADER) then {
			CTRL_INGAME_HEADER ctrlSetStructuredText parseText (_this select 0);
		};
	};
};