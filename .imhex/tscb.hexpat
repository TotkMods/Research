#pragma pattern_limit 1000000

enum Type : u32 {
    HeightMap = 0x0000,
    NormalMap = 0x0100,
    Material = 0x2000,
    Grass = 0x4000,
    Water = 0x4100,
    Bake = 0x5000,
};

struct FileType {
    Type type;
    u32 reserve0[23];
    u32 offset;
    u32 offset1;
    u32 offset2;
    u32 offset3;
    u32 reserve1[4];
    char name[] @ addressof(offset) + offset;
    char file_type[] @ addressof(offset1) + offset1;
    char16 name_jp[] @ addressof(offset2) + offset2;
    if (offset3 != 0) {
        char resource_type[] @ addressof(offset3) + offset3;
    }
};

struct MatInfo {
    u32 index;
    u32 reserve[3];
    float u;
    float v;
    u32 reserve2[2];
    float reserve3;
    float reserve4;
    u32 reserve5[2];
    float reserve6;
    float reserve7;
    float reserve8;
    u32 reserve9;
};

struct FileInfoEntry {
    Type type;
    u32 reserve0[7];
    float min_height;
    float max_height;
    u32 reserve3[6];
};

struct FileInfoArray {
    u32 reserve0; // always 4? maybe the size of the offset or something
    u32 offset0;
    // I think 6 is the maximum number of entries this section can have
    FileInfoEntry file0 @ addressof(offset0) + offset0;
    if (offset0 > 4) {
        u32 offset1;
        FileInfoEntry file1 @ addressof(offset1) + offset1;
    }
    if (offset0 > 8) {
        u32 offset2;
        FileInfoEntry file2 @ addressof(offset2) + offset2;
    }
    if (offset0 > 12) {
        u32 offset3;
        FileInfoEntry file3 @ addressof(offset3) + offset3;
    }
    if (offset0 > 16) {
        u32 offset4;
        FileInfoEntry file4 @ addressof(offset4) + offset4;
    }
    if (offset0 > 20) {
        u32 offset5;
        FileInfoEntry file5 @ addressof(offset5) + offset5;
    }
};

struct Area {
    float x_pos;
    float z_pos;
    float area_size;
    u32 reserve3[21];
    u32 offset;
    
    FileInfoArray file_info_array;
    
    // I think the filename is supposed to be some kind of position?
    char filename[] @ addressof(offset) + offset;
};

struct FileTypeArray {
    u32 offset;
    
    FileType file_type @ addressof(this) + offset;
};

struct MatInfoArray {
    u32 offset;
    
    MatInfo mat_info @ addressof(this) + offset;
};

struct AreaArray {
    u32 offset;
    
    Area area @ addressof(this) + offset;
};

struct Header {
    char magic[4];
    u32 version;
    u32 reserve0;
    u32 offset0;
    u32 string_pool_offset = offset0 + addressof(offset0);
    float world_scale;
    float mesh_max_height;
    u32 reserve1[6];
    u32 file_type_count;
    u32 mat_info_count;
    u32 area_count;
    u32 reserve2;
    u32 reserve3[6];
    float tile_size;
    u32 reserve5[5];
    u32 offset1;
    u32 file_type_offset = offset1 + addressof(offset1);
    u32 offset2;
    u32 mat_info_offset = offset2 + addressof(offset2);
    u32 offset3;
    u32 area_array_offset = offset3 + addressof(offset3);
    
    char string_pool @ string_pool_offset;
    
    FileTypeArray file_type_array[file_type_count] @ file_type_offset;
    MatInfoArray mat_info_array[mat_info_count] @ mat_info_offset;
    AreaArray area_array[area_count] @ area_array_offset;
};

Header tscb @ 0x00;