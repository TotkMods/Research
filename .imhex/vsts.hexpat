#include <std/mem.pat>

struct Array {
    u32 count;
    u32 values[count];
};

struct ArrayArray {
    u32 start = $ + 4;
    u32 size;
    Array array[while($ < start + size)];
};

struct Data {
    u32 size;
    u8 data[size];
};

struct Entry {
    ArrayArray reserve0;
    Data reserve1;
};

struct StatsEntry {
    u32 reserve0[10];
    if (std::mem::read_unsigned($, 4) != 0x20 && !std::mem::eof()) {
        Entry reserve1;
    }
};

struct Stats {
    char magic[4]; // VSTS
    u16 reserve0; // version?
    u8 reserve1;
    u8 count;
    StatsEntry entries[count];
};

Stats file @ 0x00;