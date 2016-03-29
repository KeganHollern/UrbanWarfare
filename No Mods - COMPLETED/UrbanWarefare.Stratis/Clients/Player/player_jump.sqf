_isJumping = missionNamespace getVariable ["jumping",false];
if(vehicle player == player) then {
	if(!_isJumping) then {
		if(isTouchingGround player) then {
			if(stance player == "STAND") then {
				missionNamespace setVariable ["jumping",true];
				_height = 3.5-((load player)); 
				_vel = velocity player;
				_dir = direction player;
				_speed = 0.4;
				player setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),_height];
				_lastAnim = animationState player;
				Animation = [player,"AovrPercMrunSrasWrflDf"];
				player switchMove "AovrPercMrunSrasWrflDf";
				publicVariable "Animation";
				uiSleep 0.73;
				player switchMove _lastAnim;
				missionNamespace setVariable ["jumping",false];
			};
		};
	};
};