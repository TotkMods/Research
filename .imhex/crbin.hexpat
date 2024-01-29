#pragma array_limit 1000000
#pragma pattern_limit 10000000

struct Section1 {
    u16 reserve0;
    u16 reserve1;
    u16 reserve2;
    u16 reserve3;
};

struct Section2 {
    u32 reserve0;
    u32 reserve1;
};

struct Section3 {
    u16 reserve0;
    u16 reserve1;
};

struct Section3Quad {
    u32 reserve0;
    u32 reserve1;
};

struct Section4 {
    float reserve0;
    float reserve1;
    float reserve2;
    float reserve3;
    float reserve4;
    float reserve5;
};

struct Section4Quad {
    u8 reserve;
};

struct Section5 {
    u32 reserve0;
    u8 reserve1[12];
};

struct Section5Quad {
    u8 reserve[4];
};

struct Section6 {
    u8 reserve[4];
};

struct Section7 {
    u32 reserve0;
    u32 reserve1;
    u16 reserve2;
    u16 reserve3;
};

struct Section7Quad {
    float reserve[6];
};

struct Section8 {
    float reserve[8];
};

struct Section8Quad {
    u8 reserve[6];
};

struct CrbinFile {
    u32 reserve; // lines up with offset 0xc of the chunk file
    u32 file_index;
};

struct Offset<T> {
    u32 offset;
    u32 count;
    
    T entries[count] @ offset;
};

struct Sections {
    Offset<Section1> section_1;
    Offset<Section2> section_2;
    Offset<Section3> section_3;
    Offset<Section4> section_4;
    Offset<Section5> section_5;
    Offset<Section6> section_6;
    Offset<Section7> section_7;
    Offset<Section8> section_8;
    Offset<CrbinFile> chunks;
};

struct SectionsQuad {
    Offset<Section1> section_1;
    Offset<Section2> section_2;
    Offset<Section3Quad> section_3;
    Offset<Section4Quad> section_4;
    Offset<Section5Quad> section_5;
    Offset<Section6> section_6;
    Offset<Section7Quad> section_7;
    Offset<Section8Quad> section_8;
    Offset<CrbinFile> quads;
};

struct Header {
    char magic[8]; // cave017\x00
    u32 file_size;
    u32 reserve0; // version?
    u32 crbin_id;
    float reserve2;
    u32 reserve3;
    float reserve4;
    float reserve5;
    u32 reserve6;
    float reserve7;
    u32 reserve8;
    float reserve9;
    float reserve10;
    u32 reserve11;
    float reserve12;
    float reserve13;
    Offset<u8> reserve14[4];
    u32 reserve15;
    Sections chunk_sections;
    u32 reserve16;
    u32 reserve17;
    float reserve18;
    float reserve19;
    float reserve20;
    float reserve21;
    u32 reserve22;
    float reserve23;
    float reserve24;
    float reserve25;
    float reserve26;
    float reserve27;
    float reserve28;
    u32 reserve29[4];
    SectionsQuad quad_sections;
    float reserve31[12];
    u8 resreve32[112];
};

Header file @ 0x00;