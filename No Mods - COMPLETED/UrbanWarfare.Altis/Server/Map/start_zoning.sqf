/*
	File: start_zoning.sqf
	Description: UW Blue and Black Zoning System
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

_minutes = 21;
_zoneChange = 7;
_changeTime = ceil(_minutes / _zoneChange);

_zoneCenter = (getMarkerPos "UrbanW_SafeZone");
_zoneSize = 280;
_nextZoneCenter = [0,0,0];
	
_zoneSizeScaling = 40;

if(_zoneSizeScaling >= 1) then {
	_zoneSizeScaling = _zoneSizeScaling / 100; 
};
_timeTillChange = _changeTime;
for "_i" from 1 to _minutes do {
	_timeTillChange = _timeTillChange - 1;
	
	_time = time + 60;
	waitUntil{time >= _time || !UrbanW_InGame};
	if(!UrbanW_InGame) exitWith {};
	
	_isZoneChange = _timeTillChange == 0;
	if(_i <= _changeTime) then { //--- is before or equal to first zone
		if(_isZoneChange) then { //--- time to create first
			_zoneCenter = _nextZoneCenter;
			_zoneSize = _zoneSize - (_zoneSize*_zoneSizeScaling);
			_blue = createMarker ["Blue_Zone",_zoneCenter];
			"Blue_Zone" setMarkerColor "ColorBlue";
			"Blue_Zone" setMarkerShape "ELLIPSE";
			"Blue_Zone" setMarkerBrush "BORDER";
			"Blue_Zone" setMarkerSize [_zoneSize,_zoneSize];
			deleteMarker "Temp_Zone";
			UrbanW_ZoneStarted = true;
			publicVariable "UrbanW_ZoneStarted";
			UR_DT_PVAR = ["PLAY IS NOW RESTRICTED TO THE AREA INSIDE THE BLUE ZONE!",0,0.7,10,0];
			publicVariable "UR_DT_PVAR";
		} else {
			_doUpdateMap = _timeTillChange == 1;
			if(_doUpdateMap) then { //--- preview zone?
				_scaleChange = (_zoneSize*_zoneSizeScaling);
				_tempSize = _zoneSize - _scaleChange;
				_changeDIR = random(360);
				_nextZoneCenter = [(_zoneCenter select 0) + random(_scaleChange*sin(_changeDIR)),(_zoneCenter select 1) + random(_scaleChange*cos(_changeDIR)),0];
				_temp = createMarker ["Temp_Zone",_nextZoneCenter];
				"Temp_Zone" setMarkerColor "ColorBlue";
				"Temp_Zone" setMarkerShape "ELLIPSE";
				"Temp_Zone" setMarkerBrush "BORDER";
				"Temp_Zone" setMarkerSize [_tempSize,_tempSize];
				//draw new zones
				_steps = floor ((2 * pi * _tempSize) / 15);
				_radStep = 360 / _steps;
				_data = [];
				for [{_j = 0}, {_j < 360}, {_j = _j + _radStep}] do {
					_pos2 = [_nextZoneCenter, _tempSize, _j] call BIS_fnc_relPos;
					_pos2 set [2, 0];
					_data set[count(_data),["UserTexture10m_F",_pos2,_j,"#(argb,8,8,3)color(0,0,1,0.4)"]];
					_data set[count(_data),["UserTexture10m_F",_pos2,(_j + 180),"#(argb,8,8,3)color(0,0,1,0.4)"]];
				};
				UR_DRAWZONE = _data;
				publicVariable "UR_DRAWZONE";
				UR_DT_PVAR = ["YOUR MAP HAS BEEN UPDATED WITH THE BLUE ZONE!",0,0.7,10,0];
				publicVariable "UR_DT_PVAR";
			} else { //--- notify when the blue circle will be locked
				UR_DT_PVAR = [format["IN %1 MINUTES THE BLUE ZONE WILL BE CREATED",_timeTillChange],0,0.7,5,0];
				publicVariable "UR_DT_PVAR";
			};
		};
	} else {
		if(_i <= (_minutes-_changeTime)) then { //--- still zoning?
			if(_isZoneChange) then { //--- time to change to a new zone
				_zoneCenter = _nextZoneCenter;
				_zoneSize = _zoneSize - (_zoneSize*_zoneSizeScaling);
				"Blue_Zone" setMarkerPos _zoneCenter;
				"Blue_Zone" setMarkerSize [_zoneSize,_zoneSize];
				"Blue_Zone" setMarkerColor "ColorBlue";
				deleteMarker "Temp_Zone";
				UR_DT_PVAR = ["PLAY IS NOW RESTRICTED TO THE AREA INSIDE THE BLUE ZONE!",0,0.7,10,0];
				publicVariable "UR_DT_PVAR";
			} else {
				_doUpdateMap = _timeTillChange == 1;
				if(_doUpdateMap) then { //--- time to preview a zone
					_scaleChange = (_zoneSize*_zoneSizeScaling);
					_tempSize = _zoneSize - _scaleChange;
					_changeDIR = random(360);
					_nextZoneCenter = [(_zoneCenter select 0) + random(_scaleChange*sin(_changeDIR)),(_zoneCenter select 1) + random(_scaleChange*cos(_changeDIR)),0];
					_temp = createMarker ["Temp_Zone",_nextZoneCenter];
					"Temp_Zone" setMarkerColor "ColorBlue";
					"Temp_Zone" setMarkerShape "ELLIPSE";
					"Temp_Zone" setMarkerBrush "BORDER";
					"Temp_Zone" setMarkerSize [_tempSize,_tempSize];
					"Blue_Zone" setMarkerColor "ColorRed";
					_steps = floor ((2 * pi * _tempSize) / 15);
					_radStep = 360 / _steps;
					_data = [];
					for [{_j = 0}, {_j < 360}, {_j = _j + _radStep}] do {
						_pos2 = [_nextZoneCenter, _tempSize, _j] call BIS_fnc_relPos;
						_pos2 set [2, 0];
						_data set[count(_data),["UserTexture10m_F",_pos2,_j,"#(argb,8,8,3)color(0,0,1,0.4)"]];
						_data set[count(_data),["UserTexture10m_F",_pos2,(_j + 180),"#(argb,8,8,3)color(0,0,1,0.4)"]];
					};
					UR_DRAWZONE = _data;
					publicVariable "UR_DRAWZONE";
					UR_DT_PVAR = ["YOUR MAP HAS BEEN UPDATED!",0,0.7,10,0];
					publicVariable "UR_DT_PVAR";
				} else { //--- notify when a new zone will appear 
					UR_DT_PVAR = [format["IN %1 MINUTES, THE PLAY AREA WILL SHRINK AGAIN!",_timeTillChange],0,0.7,10,0];
					publicVariable "UR_DT_PVAR";
				};
			};
		} else { //--- no more zones
			if(_i < (_minutes-1)) then { //--- mulitple minutes till end
				UR_DT_PVAR = [format["THERE IS %1 MINUTES LEFT IN THE ROUND!",_changeTime - _timeTillChange],0,0.7,10,0];
				publicVariable "UR_DT_PVAR";
			} else {
				if(_i != _minutes) then { //--- last minute
					UR_DT_PVAR = ["THERE IS 1 MINUTE LEFT IN THE ROUND!",0,0.7,10,0];
					publicVariable "UR_DT_PVAR";
				};
			};
		};
	};
	if(_isZoneChange) then {_timeTillChange = _changeTime;};

};
UrbanW_InGame = false;
diag_log "<UrbanW>: ROUND ENDED!";
deleteMarker "Blue_Zone";
deleteMarker "Temp_Zone";