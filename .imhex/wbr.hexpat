#pragma pattern_limit 1000000

struct Vector3f {
    float x;
    float y;
    float z;
};

struct Data {
    Vector3f data[4];
};

struct Blur {
    char name[0x40];
    u32 reserve0;
    u32 reserve1;
    u32 count;
    Data data[count];
};

struct Entry {
    u32 offset;
    
    Blur blur @ offset;
};

struct Header {
    u32 count;
    Entry entries[count];
};

Header file @ 0x00;