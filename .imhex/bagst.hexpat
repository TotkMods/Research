#include <std/mem.pat>

u32 string_pool_offset @ 0x20;

struct String {
    char string[];
};

struct StringPool {
    char magic[4]; // STRG
    u32 string_pool_size;
    String strings[while(!(std::mem::eof()))];
};

// I am not labeling the BYML files lol

struct GCCD {
    char magic[4]; // GCCD
    u32 byml_size;
    // BYML file goes here
};

struct PASE {
    char magic[4]; // PASE
    u32 byml_size;
    // BYML file goes here
};

struct MAND {
    char magic[4]; // MAND
    u32 byml_size;
    // BYML file goes here
};

enum ActiveSoundLimiterType : u32 {
    PriorityEarlier = 1,
    PriorityLater = 2,
    Earlier = 3,
    Later = 4,
};

struct TargetSetting {
    u32 offset;
    float reserve0;
    float reserve1;
    float reserve2;
    u32 reserve3;
    
    char name[] @ offset + string_pool_offset + 8;
};

struct StringEntry {
    u32 string_offset;
    float reserve;
    
    char namep[] @ string_offset + $ - 8;
};

struct GroupEntry {
    u32 section_size;
    u32 count;
    
    StringEntry entries[count];
};

struct GroupParam {
    u32 string_offset;
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    float volume;
    float pitch;
    float lfe;
    float lpf;
    s32 biquad_filter_type;
    float biquad_filter_value;
    s32 angle_index;
    float spread;
    float device_volume;
    float reserve3;
    float reserve4;
    s32 reserve5;
    float reserve6;
    float reserve7;
    float bus_volume0;
    float bus_volume1;
    float bus_volume2;
    float bus_volume3;
    ActiveSoundLimiterType active_sound_limiter_type;
    u32 reserve8;
    u32 reserve9;
    u32 request_sound_limiter_type;
    s32 reserve10;
    u32 reserve11;
    u32 reserve12;
    float reserve13;
    float reserve14;
    u32 request_interval_limiter_type;
    float reserve15;
    u32 reserve16;
    u32 reserve17;
    u32 reserve18;
    u32 reserve19;
    float ducking_floor_volume;
    u32 reserve20;
    u32 target_count;
    TargetSetting targets[target_count];
    u32 reserve21;
    u32 reserve22;
    u32 reserve23;
    u32 reserve24;
    u32 reserve25;
    u32 pos = $;
    GroupEntry strings;
    $ = strings.section_size + pos + 4;
    std::mem::AlignTo<4>;
    u32 section_size;
    char name[];
    std::mem::AlignTo<4>;
    
    char group_name[] @ string_offset + string_pool_offset + 8;
};

struct Entry {
    u32 offset;
    
    GroupParam params @ offset;
};

struct Group {
    char magic[4]; // "GRP "
    u32 section_size;
    u32 count;
    Entry group_params[count];
};

using TreeNode;

struct TreeNode {
    u32 node_size;
    u32 group_index;
    u32 children_count;
    
    TreeNode nodes[children_count];
};

struct Tree {
    char magic[4]; // TREE
    u32 section_size;
    u32 name_offset;
    TreeNode root_node;
    
    char group_name[] @ name_offset + string_pool_offset + 8;
};

struct Header {
    char magic[4]; // AGST
    u16 bom;
    u16 version;
    u32 file_size;
    u32 tree_offset;
    u32 group_offset;
    u32 mand_offset;
    u32 pase_offset;
    u32 gccd_offset;
    u32 string_pool_offset;
    
    Tree tree_section @ tree_offset;
    Group groups @ group_offset;
    MAND mand_section @ mand_offset;
    PASE pase_section @ pase_offset;
    GCCD gccd_section @ gccd_offset;
    StringPool strings @ string_pool_offset;
};

Header file @ 0x00;