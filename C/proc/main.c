// Krzysztof Michalski

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>

int main(int argc, char *argv[], char *envp[])
{
  DIR *pDir;
  struct dirent *pDirent;

  int fileHandler;
  char buffer[512];
  char pathToCmd[30];

  char *lastSlash;

  int killall = 0;

  if(strcmp("./killall", argv[0]) == 0)
  {
    killall = 1;
  }

  pDir = opendir("/proc");
  while ((pDirent = readdir(pDir)) != NULL) {
    if(isdigit(pDirent->d_name[0]))
    {
      sprintf(pathToCmd, "/proc/%s/cmdline", pDirent->d_name);
      fileHandler = open(pathToCmd, O_RDONLY);
      int r = read(fileHandler, buffer, 511);
      if(r > 0)
      {
        lastSlash = strrchr(buffer, '/');
        if(lastSlash != NULL)
        {
          strncpy(buffer, buffer+(lastSlash-buffer+1), 512);
        }

        if(strcmp(buffer, argv[1]) == 0)
        {
          if(killall == 1)
          {
            int pid = strtol(pDirent->d_name, NULL, 10);
            kill(pid, SIGKILL);
          }
          printf("%s\n", pDirent->d_name);
        }
      }

      close(fileHandler);
    }
  }

  closedir(pDir);
  return 0;
}