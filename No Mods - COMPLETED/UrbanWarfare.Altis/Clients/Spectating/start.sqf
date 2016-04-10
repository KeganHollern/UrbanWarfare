/* 
	File: start.sqf
	Description: Camera initialiaztion for UrbanWarfare
	Created By: Lystic
	Date: 03/27/2016
	Parameters: n/a
	Returns: n/a
*/

scriptName "Spectator_Billboard_Updater";

while{true} do {
	//--- if pip is disabled then we need to wait until it is enabled to continue the script
	if(!isPipEnabled) then {
		waitUntil{uiSleep 1;isPipEnabled};
	};
	
	_angle = 30;//random(360);
	_x = sin(_angle) * 280;
	_y = cos(_angle) * 280;
	
	_groundPOS = markerPos "BRMini_SafeZone";
	
	_cam = "camera" camCreate [(_groundPOS select 0) + _x,(_groundPOS select 1) + _y,280];
	_cam cameraEffect ["Internal","back","specttt"];
	_cam camSetTarget _groundPos;
	_cam camCommit 0;
	
	_lastChange = diag_tickTime - 0.5;
	
	_fov = 0.7;
	_targetFOV = 0.7;
	
	_pos = _groundPOS;
	_targetPOS = _groundPOS;
	
	_camUpdate = false;
	
	_mode = 0;
	
	_lastShot = objNull;
	
	while{(_groundPOS IsEqualTo (markerPos "BRMini_SafeZone")) && isPipEnabled} do {
		
		_hour = date select 3;
		if(_hour < 7 || _hour > 17) then {
			if(_mode != 1) then {
				_mode = 1;
				"specttt" setPiPEffect [1];
			};
		} else {
			if(_mode != 0) then {
				_mode = 0;
				"specttt" setPiPEffect [0];
			};
		};
		
		if(diag_tickTime > (_lastChange + 0.5)) then {
			_camUpdate = false;
			
			_targetPOS = _groundPOS;
			
			if(getMarkerColor "Blue_Zone" != "") then {
				
				_targetPOS = getMarkerPos "Blue_Zone";
				
			};
			
			if(!isNull _lastShot) then {
				if !(_lastShot getVariable ["BRFired",false]) then {
					_lastShot = objNull;
				};
			};
			
			if(isNull _lastShot) then {
				
				{
					if(_x getVariable ["BRFired",false]) exitWith {
						_targetPOS = _x;
						_lastShot = _x;
					};
				} forEach allPlayers;
				
			} else {
				_targetPOS = _lastShot;
			};
			
			if(typename _pos != typename _targetPOS || !(_pos isEqualTo _targetPOS)) then {
				_targetFOV = 0.05;
				if(typename _targetPOS == typename []) then {
					_targetFOV = 0.7; 
				};
				_cam camSetTarget _targetPOS;
				_camUpdate = true;
			};
			
			if(_fov != _targetFOV) then {
				_cam camSetFov _targetFOV;
				_camUpdate = true;
			};
			
			if(_camUpdate) then {
				_cam camCommit 0.5;
				_lastChange = diag_tickTime;
				_fov = _targetFOV;
				_pos = _targetPOS;
			};
		};
		uiSleep 0.1;
	};
	
	_cam cameraEffect ["terminate","back"];
	camDestroy _cam;
};













