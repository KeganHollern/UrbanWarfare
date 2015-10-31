
_showReport = BRMINI_ReportItems select 0;
_weaponData = BRMINI_ReportItems select 1;
_killData = BRMINI_ReportItems select 2;
_killerType = BRMINI_ReportItems select 3;
_killerHP = BRMINI_ReportItems select 4;
_killedDistance = BRMINI_ReportItems select 5;
_timeAlive = BRMINI_ReportItems select 6;
_place = BRMINI_ReportItems select 7;
if(_showReport) then {
	_text = "<t size='1.1' align='center'>You " + (if(_killerType == "") then {"Won!"} else {"Lost."}) + "</t><br/>";
	_text = _text + "Kills: " + str(count(_killData)) + "<br/>";
	_text = _text + "Place: " + str(_place) + "<br/>";
	_text = _text + "Alive: " + str(round(_timeAlive)) + " seconds<br/>";
	_text = _text + "<br/>";
	_text = _text + "Killed: <br/><t size='0.7'>";
	{
		_name = _x select 0;
		_dist = _x select 1;
		_text = _text + "	" + _name + "(" + str(round(_dist)) + "m)<br/>";
	} forEach _killData;
	_text = _text + "</t><br/>";
	if(_killerType != "") then {
		_text = _text + "Killed By: " + _killerType + "<br/>"; 
		_text = _text + "Killer HP: " + str(_killerHP) + "<br/>";
		_text = _text + "Distance: " + str(round(_killedDistance)) + "m<br/>";
	};
	disableserialization;
	createDialog "RoundReport";

	_ctrl = (findDisplay 1337) displayCtrl 4;
	_ctrl ctrlSetStructuredText parseText _text;
	_ctrl ctrlSetPosition [0,0,0.725,ctrlTextHeight _ctrl];
	_ctrl ctrlCommit 0;
};