#pragma array_limit 1000000
#pragma pattern_limit 10000000

struct ResHashEntry {
    u32 hash_crc32;
    u32 resource_size;
};

struct ResStringEntry { // for hash collisions
    char name[header.string_size];
    u32 resource_size;
};

struct ResHeader {
    char magic[6];
    u32 version;
    u32 string_size;
    u32 hash_count;
    u32 string_count;
};

ResHeader header @ 0x00;
ResHashEntry hash_entries[header.hash_count] @ sizeof(header);
ResStringEntry hash_collision_entries[header.string_count] @ addressof(hash_entries) + sizeof(hash_entries);