with uiNamespace do {
	_display = (findDisplay 46);
	_ctrl = _display ctrlCreate ["RscStructuredText",-1];
	_ctrl ctrlsetposition [safezonex,safezoney,safezonew,safezoneh/20];
	_ctrl ctrlsetbackgroundcolor [0,0,0,0];
	_ctrl ctrlsettextcolor [0,0,0,1];
	_ctrl ctrlSetStructuredText parseText "<t align='center'></t>";
	_ctrl ctrlCommit 0;
	CTRL_INGAME_HEADER = _ctrl;
};	