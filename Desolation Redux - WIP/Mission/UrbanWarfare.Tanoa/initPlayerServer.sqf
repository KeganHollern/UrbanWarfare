waitUntil{!(isNil "BASE_var_FUNCTIONLIST") && !(isNull (_this select 0))}; // wait for server and client to be ready 
[BASE_var_FUNCTIONLIST] remoteExec ["BASE_fnc_start",(_this select 0)]; // start loadin process

params["_unit","_jip"];

//_unit allowDamage false; // These will be enabled once the client is ready to spawn
//hideObjectGlobal _unit;
//_unit enableSimulationGlobal false;


