// External hack for Wesnoth 1.14.9
# include <Windows.h>

int main(int argc, char** argv){
    DWORD proc_id = 0;
    DWORD gold_value = 0;
    DWORD gold_val = 999;
    SIZE_T bytes_read = 0;
    SIZE_T bytes_written = 0;

    HWND proc_window = FindWindowA(NULL, "The Battle for Wesnoth - 1.14.9");

    GetWindowThreadProcessId(proc_window, &proc_id);

    HANDLE wesnoth_proc = OpenProcess(PROCESS_ALL_ACCESS, true, proc_id);

    ReadProcessMemory(wesnoth_proc, (void*)0x017EED18, &gold_value, 4, &bytes_read);
    gold_value += 0xA90
    ReadProcessMemory(wesnoth_proc, (void*)gold_value, &gold_value, 4, &bytes_read);
    gold_value += 4
    WriteProcessMemory(wesnoth_proc, (void*)gold_value, &gold_val, 4, &bytes_written);

    return 0;
}