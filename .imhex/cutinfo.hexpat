u32 string_pool_offset @ 0x0C;

struct Data {
    u32 actor_name_offset;
    u32 secondary_name_offset;
    u32 data_size;
    u8 data[data_size];
    
    char actor[] @ string_pool_offset + 0x10 + actor_name_offset;
    char secondary_name[] @ string_pool_offset + 0x10 + secondary_name_offset;
};

struct ResCut {
    float frame; // start frame
    u32 data_count;
    Data data[data_count];
};

struct CutOffset {
    u32 offset;
    
    ResCut cut @ offset + 0x10;
};

struct ResCutInfo {
    char magic[4]; // GECR GameEventCutinfoResource
    u32 version;
    u32 cut_count;
    u32 string_pool_offset;
    CutOffset cuts[cut_count];
};

ResCutInfo file @ 0x00;