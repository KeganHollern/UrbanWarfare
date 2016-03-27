class RoundReport {
	access = 0;
	enableDisplay = 1;
	enableSimulation = 1;
	movingEnable = 1;
	idd = 1337;
	class controlsBackground {
		class IGUIBack_2200: Back
		{
			idc = 1;
			x = 0.125;
			y = 0.2;
			w = 0.75;
			h = 0.04;
			colorBackground[] = {0.77,0.51,0.08,0.8};
		};
		class IGUIBack_2201: Back
		{
			idc = 2;
			x = 0.125;
			y = 0.248;
			w = 0.75;
			h = 0.56;
			colorBackground[] = {0,0,0,0.7};
		};
	};
	class Controls {
		class RscText_1000: Text
		{
			idc = 3;
			text = "Round Report"; //--- ToDo: Localize;
			x = 0.125;
			y = 0.2;
			w = 0.2375;
			h = 0.04;
		};
		class RscButton_1600: Button
		{
			idc = 5;
			text = "Continue"; //--- ToDo: Localize;
			x = 0.7375;
			y = 0.812;
			w = 0.1375;
			h = 0.04;
			colorBackground[] = {0,0,0,0.7};
			onButtonClick = "closeDialog 0;";
		};
		class ScrollGroup: VScrollGroup {
			idc = 6;
			x = 0.1375;
			y = 0.288;
			w = 0.725;
			h = 0.48;
			class Controls {
				class RscStructuredText_1100: StructuredText
				{
					idc = 4;
					x = 0;
					y = 0;
					w = 0.725;
					h = 0.48;
				};
			};
		};
	};
};