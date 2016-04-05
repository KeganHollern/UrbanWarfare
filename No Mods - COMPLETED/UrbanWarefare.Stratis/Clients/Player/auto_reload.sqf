scriptName "Auto_Reload";
while{true} do {
	if (needReload player == 1) then {
		reload player
	};
	uisleep 0.1;
};