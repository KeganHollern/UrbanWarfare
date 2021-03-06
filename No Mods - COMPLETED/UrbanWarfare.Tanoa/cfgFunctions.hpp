
class cfgFunctions {
	class UW {
		class Server {
			//Root Server
			class serverStart {
				file = "Server\start.sqf";
			};
			class serverSetup {
				file = "Server\setup.sqf";
			};
			class serverReset {
				file = "Server\reset.sqf";
			};
			class serverConfig {
				file = "Server\config.sqf";
			};
			//vehicles
			class resetQuads {
				file = "Server\Vehicles\reset_quads.sqf";
			};
			//players
			class deathMessages {
				file = "Server\Players\deathMessages.sqf";
			};
			class waitForPlayers {
				file = "Server\Players\waitForPlayers.sqf";
			};
			//map
			class mapSetup {
				file = "Server\Map\setup_map.sqf";
			};
			class mapCleanup {
				file = "Server\Map\cleanup_map.sqf";
			};
			class startZoning {
				file = "Server\Map\start_zoning.sqf";
			};
			class vehicleHandler {
				file = "Server\Map\vehicle_handler.sqf";
			};
			class findPlayarea {
				file = "Server\Map\find_playarea.sqf";
			};
			//weather
			class simpleFog {
				file = "Server\Weather\fn_simpleFog.sqf";
			};
			class startWeather {
				file = "Server\Weather\start_weather.sqf";
			};
			//loot
			class spawnLoot {
				file = "Server\Loot\spawn_loot.sqf";
			};
			class lootManager {
				file = "Server\Loot\loot_manager.sqf";
			};
		};
		class Client {
			//Root Client
			class clientStart {
				file = "Clients\start.sqf";
			};	
			class clientSetup {
				file = "Clients\setup.sqf";
			};
			class clientReset {
				file = "Clients\reset.sqf";
			};
			//zoning
			class circleDamage {
				file = "Clients\Zoning\circle_damage.sqf";
			};
			//functions
			class animation {
				file = "Clients\Functions\animation.sqf";
			};
			//player
			class doJump {
				file = "Clients\Player\player_jump.sqf";
			};
			class autoReload {
				file = "Clients\Player\auto_reload.sqf";
			};
			class playerSetup {
				file = "Clients\Player\setup_player.sqf";
			};
			class playerEvents {
				file = "Clients\Player\Player_EventHandlers.sqf";
			};
			class afkTimer {
				file = "Clients\Player\AFK_timer.sqf";
			};
			//map
			class clientWeather {
				file = "Clients\Map\setup_weather.sqf";
			};
			class clientFog {
				file = "Clients\Map\clientFog.sqf";
			};
			//spectating
			class StartSpectator {
				file = "Clients\Spectating\start.sqf";
			};
			class spectate {
				file = "Clients\Spectating\spectate.sqf";
			};
			class endSpectate {
				file = "Clients\Spectating\kill_spectate.sqf";
			};
			//GUI
			class startTags {
				file = "Clients\GUI\start_nametags.sqf";
			};
			class endTags {
				file = "Clients\GUI\end_nametags.sqf";
			};
			class showReport {
				file = "Clients\GUI\show_report.sqf";
			};
			class createInGameGUI {
				file = "Clients\GUI\inGame_create.sqf";
			};
			class updateInGameGUI {
				file = "Clients\GUI\inGame_update.sqf";
			};
			class deleteInGameGUI {
				file = "Clients\GUI\inGame_cleanup.sqf";
			};
			class startSpectatorGUI {
				file = "Clients\GUI\spectator_start.sqf";
			};
			class deleteSpectatorGUI {
				file = "Clients\GUI\spectator_stop.sqf";
			};
			class setupGUI {
				file = "Clients\GUI\setup_GUI.sqf";
			};
		};
	};
};