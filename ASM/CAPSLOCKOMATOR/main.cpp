// Krzysztof Michalski

#include "stdafx.h"
#include "conio.h"
#include "stdio.h"
#include "string.h"
#include "stdlib.h"

// function for getting string from user
char *getln()
{
    char *line = NULL, *tmp = NULL;                 // variables to store whole line
    size_t size = 0, index = 0;                     // size which by allocated memory will be expanded and multipler (index / number of characters entered)
    int ch = EOF;                                   // variable to which each character will be loaded

    while (ch) {
        ch = getc(stdin);                           // read next character

        if (ch == EOF || ch == '\n') ch = 0;        // if enter was pressed then stop reading

        if (size <= index) {                        // check if allocated memory needs expanding
            size += sizeof(char);                   // if so calculate needed size (number of entered characters * size of char type)
            tmp = (char *)realloc(line, size);      // memory realloaction assing to tmp for test
            if (!tmp) {                             // if failure
                free(line);                         // free memory
                line = NULL;                        // reset line
                break;                              // break the loop
            }
            line = tmp;                             // if success overwrite line with tmp
        }

        line[index++] = ch;                         // after memory expanding assing new character to line
    }

    return line;                                    // after all return line
}

int _tmain(int argc, _TCHAR* argv[])
{
    char *a, *b;
    a = getln();                                    // get string from user to variable a

    b = (char *)malloc(sizeof(char));               // set variable b
    realloc(b, strlen(a) * sizeof(char));           // to the same size as variable a

    __asm
    {
        mov ecx, 0                                  ; ecx is a counter, set it to zero (characters array index) (use ecx because 32 bits are required for counter)
        mov ebx, a                                  ; read pointer for variable a
        mov edx, b                                  ; read pointer for variable b
        
        start:
            mov al, [ebx+ecx]                       ; this register will be used for test if convertion is needed at all, during the test data will be lost
            mov ah, [ebx+ecx]                       ; this register will be used for convertion

            cmp al, 0                               ; for loop break, if '\0' was readed then end
            je end
                                                    ; test if convertion is needed at all
            sub al, 0x61                            ; subtract from a[index] number from start of the range (small 'a' in ASCII is 0x61 = 97)
            cmp al, 0x19                            ; compare with end of the range (small 'z' in ASCII is 0x7A = 122), so 122 - 97 = 25 = 0x19
            ja nextchar                             ; if character is not in the range a-z do nothing

            xor ah, 0x20                            ; but if is then set sixth bit to 1 by xor operation with 0x20 (00100000)
        
            nextchar:
                mov [edx+ecx], ah                   ; move result to variable b[index]
                add ecx, 1                          ; counter incrementation

            jmp start                               ; next loop iteration
            end:
                mov [edx+ecx], 0                    ; at the end set char '\0' in variable b on the same position as in variable a
    };

    printf("%s\n", b);                              // display result
    _getch();                                       // catch enter so result can be seen
    return 0;
}

