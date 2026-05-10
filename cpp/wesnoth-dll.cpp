// DLL based gold hack for Wesnoth 1.14.9
#include <Window.h>

void injected_thread(){
	while (true){
		if (GetAsyncKeyState('M')){
			DWORD* player_base = (DWORD*)0x017EED18;
			DWORD* game_base = (DWORD*)(*player_base + 0xA90);
			DWORD* gold = (DWORD*)(*game_base + 4);
			*gold = 999;
		}
		sleep(1);
	}
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved){
	if (fdwReason == DLL_PROCESS_ATTACH){
		CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)injected_thread, NULL, 0, NULL);
	}
	return true;
}
