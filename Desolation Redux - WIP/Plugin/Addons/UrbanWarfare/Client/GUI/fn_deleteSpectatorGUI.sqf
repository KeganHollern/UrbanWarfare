with uiNamespace do {
	CTRL_SPECTATOR_ISRUNNING = false;
	waitUntil{scriptDone THREAD_SPECTATOR_START}; //wait for spectator thread to stop
	//delete controls
	{
		ctrlDelete _x;
	} forEach CTRL_SPECTATOR_PLAYERLIST;
	CTRL_SPECTATOR_PLAYERLIST = [];
	DATA_SPECTATOR_PLAYERNAMES  = [];
	DATA_SPECTATOR_PLAYERDATA = [];
};