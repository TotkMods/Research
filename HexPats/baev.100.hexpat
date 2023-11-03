// By Watertoon

#pragma pattern_limit 2000000

using ResBaev;

/* Common */
struct ResBaevHeader {
    u32 magic;
    u32 section_offset;
    u32 section_size;
    u32 section_alignment;
};

struct ResBaevArray<T> {
    u64  array;
    u32  count;
    u32  element_size;
    
    T o_array[count] @ array;
};

/* Section info */
struct ResBaevSectionInfo : ResBaevHeader {
    u64  section_base;
    char section_name[0x10];
};

/* Event hash */
struct ResBaevEventHash {
    u32 hash;
    u32 reserve0;
    ResBaevArray<u32> reserve1;
    
};

/* Event 1 */
struct ResBaevEvent1 {
    u32 type;
    u32 reserve0;
    
    if (type == 0) {
        u32 reserve1;
        u32 reserve2;
    } else if (type == 3) {
        u32 reserve1;
        u32 reserve2;
        u32 reserve3;
        u32 reserve4;
    } else if (type == 5) {
        u64  bone_name;
        
        char o_bone_name[] @ bone_name;
    }
};

struct ResBaevEvent1Offset {
    u64 event1;
    
    ResBaevEvent1 o_event1 @ event1;
};

/* Event */
struct ResBaevEventArray1 {
    ResBaevArray<ResBaevEvent1Offset> reserve0;
    u32                               reserve1;
    float                             reserve2;
};

struct ResBaevEvent {
    u64                              name;
    ResBaevArray<u8>                 array0;
    ResBaevArray<ResBaevEventArray1> array1;
    u32                              reserve0;
    u32                              reserve1;
    
    char o_name[] @ name;
};

/* Event node */
struct ResBaevEventNode {
    u64 event;
    u32 reserve0;
    u32 name_offset;
    u32 hash;
    u32 reserve1;
    
    ResBaevEvent o_event @ event;
};

/* Container */
struct ResBaevContainer {
    u64  head;
    u8   micro_version;
    u8   minor_version;
    u16  major_version;
    u32  reserve0;
    u64  string_pool;
    ResBaevArray<ResBaevEventHash> event_hash_array;
    ResBaevArray<ResBaevEventNode> event_node_array;
};

/* Head */
struct ResBaev : ResBaevHeader {
    ResBaevArray<ResBaevSectionInfo> section_info_array;
    u64                              container;
    char                             meme_string[0x80];
    
    ResBaevContainer o_container @ container;
};

ResBaev head @ 0x0;