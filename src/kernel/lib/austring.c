#include "austring.h"
#include "aumath.h"
#include <stdint.h>
#include <stdbool.h>

unsigned int strcmp(const char* stra, const char* strb)
{
    uint32_t index = 0;

    while (stra[index] != '\0' && strb[index] != '\0') {
        if (stra[index] != strb[index]) {
            return stra[index] - strb[index];
        }
        index++;
    }
    
    return stra[index] - strb[index];
}