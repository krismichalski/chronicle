//Krzysztof Michalski

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include "so2ext2.h"
#include <readline/readline.h>
#include <readline/history.h>

int disk_handle;
struct ext2_super_block super_block;
struct ext2_group_desc group_desc;
int block_size;
int current_inode;
char current_dir[200];
int exception;

void ls()
{
  int return_here = lseek(disk_handle, 0, SEEK_CUR);
  struct ext2_dir_entry dir;
  struct ext2_inode file;

  int rec_len_sum = 0;

  printf("size \t acl \t type \t name\n\n");
  do
  {
    read(disk_handle, &dir, sizeof(struct ext2_dir_entry));
    int next = lseek(disk_handle, dir.rec_len - sizeof(struct ext2_dir_entry), SEEK_CUR);

    lseek(disk_handle, block_size * (group_desc.bg_inode_table + (dir.inode / super_block.s_inodes_per_group) * super_block.s_blocks_per_group) + (sizeof(struct ext2_inode) * ((dir.inode % super_block.s_inodes_per_group) - 1)), SEEK_SET);
    read(disk_handle, &file, sizeof(struct ext2_inode));
    lseek(disk_handle, next, SEEK_SET);

    printf("%d \t %o \t %d \t %.*s \n", file.i_size, file.i_mode % (16*16*16), dir.file_type, dir.name_len, dir.name);
    rec_len_sum += dir.rec_len;
  }
  while(rec_len_sum != block_size);

  lseek(disk_handle, return_here, SEEK_SET);
}

int get_inode(char* dir_name)
{
  if(strcmp("/", dir_name) == 0 && exception == 1)
  {
    current_inode = 2;
    strcpy(current_dir, "/");
    return current_inode;
  }

  int inode = current_inode;
  int return_here = lseek(disk_handle, 0, SEEK_CUR);
  struct ext2_dir_entry dir;

  int rec_len_sum = 0;
  int current_dir_name_len = 0;

  do
  {
    read(disk_handle, &dir, sizeof(struct ext2_dir_entry));

    if(strcmp(dir.name, ".") == 0)
    {
      current_dir_name_len = dir.name_len;
    }

    if(dir.file_type == 2 && strcmp(dir.name, dir_name) == 0)
    {
      inode = dir.inode;

      if(strcmp(".", dir_name) != 0)
      {
        if(strcmp("..", dir_name) != 0)
        {
          strncat(current_dir, dir_name, dir.name_len);
          strncat(current_dir, "/", 1);
        }
        else
        {
          current_dir[strlen(current_dir) - current_dir_name_len - 1] = '\0';
        }
      }
    }

    lseek(disk_handle, dir.rec_len - sizeof(struct ext2_dir_entry), SEEK_CUR);
    rec_len_sum += dir.rec_len;
  }
  while(rec_len_sum != block_size);

  // if not changed than something went wrong
  // except when passed '.'
  if(current_inode == inode && strcmp(dir_name, ".") != 0)
  {
    printf("Directory not found or absolute path given.\n");
  }

  lseek(disk_handle, return_here, SEEK_SET);
  current_inode = inode;
  return inode;
}

void cd(char* dir_name)
{
  int inode_num = get_inode(dir_name);
  struct ext2_inode inode;
  lseek(disk_handle, block_size * (group_desc.bg_inode_table + (inode_num / super_block.s_inodes_per_group) * super_block.s_blocks_per_group) + (sizeof(struct ext2_inode) * ((inode_num % super_block.s_inodes_per_group) - 1)), SEEK_SET);
  read(disk_handle, &inode, sizeof(struct ext2_inode));
  lseek(disk_handle, block_size * inode.i_block[0], SEEK_SET);

  return;
}

void pwd()
{
  printf("%s\n", current_dir);
}

int main(int argc, char *argv[])
{
  char *disk = argv[1];

  if(disk == NULL)
  {
    fprintf(stderr, "Usage: %s [disk_name]\n", argv[0]);
    return 1;
  }

  disk_handle = open(disk, O_RDONLY);
  lseek(disk_handle, 1024, SEEK_SET);
  read(disk_handle, &super_block, sizeof(struct ext2_super_block));
  block_size = 1024 * (super_block.s_log_block_size + 1);
  lseek(disk_handle, 1024 + sizeof(struct ext2_super_block), SEEK_SET);
  read(disk_handle, &group_desc, sizeof(struct ext2_group_desc));

  // I shouldn't pass absolute paths
  // but doing this once at the beginning is quite handy
  // so I'm making an exception here
  exception = 1;
  cd("/");
  exception = 0;

  char* line;
  char* token;
  char prompt[200];

  while(1)
  {
    strcpy(prompt, "");
    strncat(prompt, "you@", 4);
    strncat(prompt, argv[1], strlen(argv[1]));
    strncat(prompt, " [", 2);
    strncat(prompt, current_dir, strlen(current_dir));
    strncat(prompt, "] > ", 4);

    line = readline(prompt);
    token = strtok(line, " ");

    if(strcmp(token, "exit") == 0)
    {
      break;
    }
    else if(strcmp(token, "cd") == 0)
    {
      token = strtok(NULL, " ");
      cd(token);
    }
    else if(strcmp(token, "ls") == 0)
    {
      ls();
    }
    else if(strcmp(token, "pwd") == 0)
    {
      pwd();
    }
    else
    {
      printf("Unknown command\n");
    }

    free(line);
  }

  close(disk_handle);

  return 0;
}
