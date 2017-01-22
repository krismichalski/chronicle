// Krzysztof Michalski

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <wait.h>
#include <signal.h>

volatile int loop = 1;
volatile int catched = 0;

static void signal_handler(int signo){
  switch (signo)
  {
    case SIGINT:
      loop = 0;
      break;
    case SIGTSTP:
      catched = 1;
      break;
  }
}

int main(int argc, char *argv[], char *envp[])
{
  pid_t pid = getpid();
  pid_t child1 = pid;
  pid_t child2 = pid;
  char *pidtxt;

  struct sigaction action;
  action.sa_handler = signal_handler;
  sigaction(SIGINT, &action, NULL);
  sigaction(SIGTSTP, &action, NULL);

  sigset_t signal_set;
  sigemptyset(&signal_set);
  sigaddset(&signal_set, SIGTSTP);
  sigprocmask(SIG_BLOCK, &signal_set, NULL);

  int n = strtol(argv[1], NULL, 10);
  char *strn = argv[1];

  if(n < 0) n = 0;
  if(argv[2] != NULL) pidtxt = argv[2];

  sprintf(pidtxt, "%s %d", pidtxt, pid);

  for(int i = 0; i < 2; i++)
  {
    // child stuff
    if(n != 0)
    {
      if(i == 0) child1 = fork();
      else child2 = fork();
    }
    if(child1 == 0 || child2 == 0)
    {
      setpgid(0, 0);
      sprintf(strn, "%d", n - 1);
      char *args[] = { "main", strn, pidtxt, 0 };
      char *env[] = { 0 };

      execve("main", args, env);
      printf("error execve returns\n");
      exit(2);
    }
  }

  while(loop)
  {
    sleep(1);
  }
  kill(child1, SIGINT);
  kill(child2, SIGINT);
  wait(NULL);
  wait(NULL);
  printf("%s\n", pidtxt);
  sigprocmask(SIG_UNBLOCK, &signal_set, NULL);
  if(catched == 1) printf("Ctrl+Z catched\n");
  return 0;
}