#include <assert.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "testMulti265.h"



#define xstr(s) str(s)
#define str(s) #s





static void measureMulti265( unsigned int inputLen){
    
    ALIGN(64) uint8_t input[inputLen];
    ALIGN(64) uint8_t output[inputLen];
    ALIGN(64) uint8_t key[inputLen];
    memset(input, 0x3B, sizeof(input));
    {
	Multi265field(input, output, (size_t)inputLen);
    }
}



void testMulti265One( void )
{
    
    uint32_t len;    
    for(len=10; len <= 200000; len=len*10) {
        measureMulti265(36*len);
        
    }
}


void testMulti265(void)
{
    testMulti265One();
}



