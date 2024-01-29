// By Watertoon, updated by dt12345

#pragma pattern_limit 2000000

using ResBaev;

struct Vector3f {
    float x;
    float y;
    float z;
};

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
struct ResBaevEventParameter {
    u32 type;
    padding[4];
    
    if (type == 0) {
        u32 value;
        padding[4];
    } else if (type == 1) { 
        float value;
        padding[4];
    } else if (type == 3) {
        Vector3f value;
        padding[4];
    } else if (type == 5) {
        u64  name_offset;
        char value[] @ name_offset;
    }
};

struct ResBaevEventParameterArray {
    u64 parameter_entry;
    
    ResBaevEventParameter parameter @ parameter_entry;
};

/* Event */
struct ResBaevEventData {
    ResBaevArray<ResBaevEventParameterArray> parameters;
    float                             start_frame;
    float                             end_frame;
};

struct ResBaevEvent {
    u64                              name;
    ResBaevArray<ResBaevEventData> trigger_array;
    ResBaevArray<ResBaevEventData> hold_array;
    u32                              reserve0;
    u32                              reserve1;
    
    char o_name[] @ name;
};

/* Event node */
struct ResBaevEventNode {
    u64 event;
    u32 count;
    u32 size;
    u32 hash;
    u32 reserve1;
    
    ResBaevEvent o_event[count] @ event;
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