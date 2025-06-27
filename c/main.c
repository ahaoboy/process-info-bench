#include <windows.h>
#include <tlhelp32.h>
#include <psapi.h>
#include <stdio.h>

int processInfo(DWORD processId, int deep)
{
  HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshot == INVALID_HANDLE_VALUE)
  {
    // printf("error code %lu\n", GetLastError());
    return deep;
  }

  PROCESSENTRY32 pe32;
  pe32.dwSize = sizeof(PROCESSENTRY32);

  char processPath[MAX_PATH] = "unknow";
  HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, processId);
  if (hProcess != NULL)
  {
    if (GetModuleFileNameExA(hProcess, NULL, processPath, MAX_PATH) == 0)
    {
      printf("failed to get process name: %lu\n", GetLastError());
      return 0;
    }
    CloseHandle(hProcess);
  }
  else
  {
    // printf("failed to open process %lu, error code %lu\n", processId, GetLastError());
    return deep;
  }

  printf("pid: %lu, path: %s\n", processId, processPath);

  DWORD parentProcessId = 0;
  if (Process32First(hSnapshot, &pe32))
  {
    do
    {
      if (pe32.th32ProcessID == processId)
      {
        parentProcessId = pe32.th32ParentProcessID;
        break;
      }
    } while (Process32Next(hSnapshot, &pe32));
  }
  else
  {
    // printf("error: %lu\n", GetLastError());
  }

  CloseHandle(hSnapshot);

  if (parentProcessId != 0)
  {
    return processInfo(parentProcessId, deep + 1);
  }
  return deep;
}

int main()
{
  DWORD currentProcessId = GetCurrentProcessId();
  int deep = processInfo(currentProcessId, 0);
  printf("deep: %d", deep);
  return 0;
}