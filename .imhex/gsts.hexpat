struct Stats {
    char magic[4];
    u32 reserve;
    u32 size;
    u8 data[size];
};

Stats file @ 0x00;