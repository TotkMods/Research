// WIP

#pragma endian big
#include <std/mem.pat>

struct String {
    char string[];
};

bitfield Size {
    flags : 2;
    size : 30;
};

struct Data {
    Size size;
    char magic[4];
    u8 data[size.size - 8];
};

struct Item {
    le u32 flags;
    u32 type_index = flags & 0xFFFFFF;
    le u32 data_offset;
    le u32 count;
};

struct Items {
    Size size_total;
    char magic0[4];
    Size size;
    char magic[4];
    Item items[while($ - addressof(this) <= size.size)];
};

struct Ptch {
    Size size;
    char magic[4];
    u32 patches[while($ - addressof(this) < size.size)];
};

// TPTR is probably written to at runtime
// TST1 seems to be the tag names while FST1 is probably formats
// TNA1 is probably name mapping
// TBDY is the tag body
// TPAD is probably just padding
// THSH is tag hashes, TSHA may be a hash of some data
struct Section {
    Size size;
    char signature[4];
    if (signature == "TPTR") {
        u8 null_bytes[size.size - 8];
    } else if (signature == "TST1" || signature == "FST1") {
        String strings[while($ - addressof(this) <= size.size - 4)];
    } else if (signature == "TNA1" || signature == "TBDY" || signature == "TPAD") {
        u8 data[size.size - 8];
    } else if (signature == "THSH" || signature == "TSHA") {
        u32 hashes[(size.size - 8) / 4];
    } else if (signature == "PTCH") {
        u32 patches[(size.size - 8) / 4];
    }
    std::mem::AlignTo<4>;
};

struct Type {
    Size size;
    char magic[4];
    Section sections[while($ - addressof(this) <= size.size - 4)];
};

struct SDKV {
    Size size;
    char magic[4];
    char sdk_ver[8];
};

struct TagFile {
    Size size;
    char magic[4];
    SDKV sdkv_header;
    Data data_section;
    Type type_section;
    Items item_section;
    Ptch patches_section;
    std::mem::AlignTo<8>;
};

struct Header {
    char magic[5];
    padding[1];
    le u16 reserve0;
    u16 bom;
    u8 major_ver;
    u8 minor_ver;
    le u32 hkt_offset;
    le u32 aamp_offset;
    le u32 file_size;
    le u32 hkt_size;
    le u32 aamp_size;
    
    TagFile hkt @ hkt_offset;
    u8 aamp[aamp_size] @ aamp_offset;
};

Header file @ 0x00;