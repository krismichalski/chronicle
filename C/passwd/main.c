//Krzysztof Michalski

#include <unistd.h>
#include <stdio.h>
#include <pwd.h>
#include <grp.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
  int opt;
  int show_groups = 0;
  char *shell = 0;

  struct passwd *pwd;
  int i, ngroups;
  gid_t *groups = NULL;

  while ((opt = getopt(argc, argv, "gs:")) != -1) {
    switch (opt) {
    case 'g':
      show_groups = 1;
      break;
    case 's':
      shell = optarg;
      break;
    default:
      fprintf(stderr, "Usage: %s [-g] [-s shell_name]\n", argv[0]);
      return 1;
    }
  }

  while ((pwd = getpwent()) != NULL) {
    if(shell != NULL && strcmp(shell, pwd->pw_shell) != 0) continue;

    printf("%s", pwd->pw_name);

    if(show_groups == 1 || shell != NULL)
    {
      if(getgrouplist(pwd->pw_name, pwd->pw_gid, NULL, &ngroups) < 0) {
        groups = (gid_t*)malloc(ngroups * sizeof(gid_t));
        getgrouplist(pwd->pw_name, pwd->pw_gid, groups, &ngroups);

        printf("; groups: ");
      }

      for(i = 0; i < ngroups; i++) printf("%s ", getgrgid(groups[i])->gr_name);
      ngroups = 0;
      groups = NULL;
    }
    
    printf("\n");
  }

  return 0;
}