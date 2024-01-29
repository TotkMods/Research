#pragma pattern_limit 10000000
#pragma array_limit 1000000

#include <std/mem.pat>

struct Unknown {
    u16 reserve0;
    u16 reserve1;
    u16 reserve2;
    u16 reserve3;
};

struct Entry {
    u24 offset;
    u8 reserve;
    
    if (reserve == 1 || reserve == 3) {
        float data[5] @ offset + $ - 4;
    } else if (reserve == 5) {
        float data[1] @ offset + $ - 4;
    } else {
        float data[3] @ offset + $ - 4;
    }
};

struct Header {
    char magic[4]; // ATRA
    u32 version; // probably
    u32 file_size;
    u32 count;
    Unknown reserve[count];
    u32 end = $ + std::mem::read_unsigned($, 3);
    Entry entries[while($ < end)];
};

Header file @ 0x00;