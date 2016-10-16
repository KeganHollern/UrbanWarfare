
diag_log "<PEH>:  ADDING EVENT HANDLERS";
player addEventHandler ["Respawn",{_this spawn UW_fnc_clientReset;}];
//--- spectator unit coloring features
player addEventHandler ["Hit",{
	[] spawn {
		player setVariable ["BRHit",true,true]; 
		player setVariable ["lastHit",diag_tickTime]; 
		uiSleep 5;
		if((diag_tickTime - (player getVariable ["lastHit",0])) >= 4.9) then {
			player setVariable ["BRHit",false,true];
		};
	};
}];
player addEventHandler ["Fired",{
	[] spawn {
		player setVariable ["BRFired",true,true]; 
		player setVariable ["lastFired",diag_tickTime]; 
		uiSleep 5;
		if((diag_tickTime - (player getVariable ["lastFired",0])) >= 4.9) then {
			player setVariable ["BRFired",false,true];
		};
	};
}];
