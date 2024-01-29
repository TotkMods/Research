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
    padding[size.size - 8];
};

// Logic taken from ReadPackedInt function in BinaryReaderEx.cs
// https://github.com/blueskythlikesclouds/TagTools/blob/havoc
struct PackedInt {
    u8 byte0;
    if (byte0 & 0x80 != 0) {
        match (byte0 >> 3) {
            (0x10 ... 0x17): u8 bytes[1];
            (0x18 ... 0x1B): u8 bytes[2];
            (0x1C): u8 bytes[3];
            (0x1D): u8 bytes[4];
            (0x1E): u8 bytes[7];
            (0x1F): u8 bytes[13];
        }
    }
};

fn unpack(PackedInt i) {
    if (i.byte0 & 0x80 == 0) {
        return i.byte0;
    }
    match (i.byte0 >> 3) {
        (0x10 ... 0x17):
            return ((i.byte0 << 8) | i.bytes[0]) & 0x3FFF;
        (0x18 ... 0x1B):
            return (
                (i.byte0 << 16) |
                (i.bytes[0] << 8) |
                i.bytes[1]
            ) & 0x1FFFFF;
        (0x1C):
            return (
               ( i.byte0 << 24 ) |
               ( i.bytes[0] << 16 ) |
               ( i.bytes[1] << 8 ) |
               i.bytes[2]
            ) & 0x7FFFFFF;
        (0x1D):
            return (
                ( i.byte0 << 32 ) |
                ( i.bytes[0] << 24 ) |
                ( i.bytes[1] << 16 ) |
                ( i.bytes[2] << 8 ) |
                i.bytes[3]
            )  & 0x7FFFFFFFFFFFFFF;
        (0x1E):
            return ( ( i.byte0 << 56 ) |
                ( i.bytes[0] << 48 ) |
                ( i.bytes[1] << 40 ) |
                ( i.bytes[2] << 32 ) |
                ( i.bytes[3] << 24 ) |
                ( i.bytes[4] << 16 ) |
                ( i.bytes[5] << 8 ) |
                i.bytes[6]
            ) & 0x7FFFFFFFFFFFFFF;
        (0x1F):
            return ( i.byte0 & 7 ) == 0
                ? (
                  ( i.byte0 << 40 ) |
                  ( i.bytes[0] << 32 ) |
                  ( i.bytes[1] << 24 ) |
                  ( i.bytes[2] << 16 ) |
                  ( i.bytes[3] << 8 ) |
                  i.bytes[4]
                ) & 0xFFFFFFFFFF
                :
                  ( i.byte0 & 7 ) == 1
                  ? (
                     i.bytes[0] << 56 ) |
                     ( i.bytes[1] << 48 ) |
                     ( i.bytes[2] << 40 ) |
                     ( i.bytes[3] << 32 ) |
                     ( i.bytes[4] << 24 ) |
                     ( i.bytes[5] << 16 ) |
                     ( i.bytes[6] << 8 ) |
                     i.bytes[7]
                  : 0;
    }
};

struct TNAParameter {
    PackedInt index;
    PackedInt value;
    
    char parameter[] @ addressof(tag_strings.strings[unpack(index)]);
    
    if (parameter[0] == 't') {
        char value_string[] @ addressof(tag_strings.strings[unpack(value) - 1]);
    }
};

struct TNAType {
    PackedInt index;
    PackedInt template_count;
    TNAParameter parameters[unpack(template_count)];
    
    char tag[] @ addressof(tag_strings.strings[unpack(index)]);
};

struct TNATypes {
    PackedInt size;
    TNAType types[unpack(size)];
};

struct TBDYField {
    PackedInt name_index;
    PackedInt flags;
    PackedInt byte_offset;
    PackedInt type_index;
    
    char name[] @ addressof(field_strings.strings[unpack(name_index)]);
    TNAType type @ addressof(types.types.types[unpack(type_index) - 1]); // lol types.types.types
};

struct TBDYInterface {
    PackedInt type_index;
    PackedInt flags;
    
    TNAType type @ addressof(types.types.types[unpack(type_index) - 1]);
};

struct TBDY {
    PackedInt type_index;
    if (unpack(type_index) != 0) {
        TNAType type @ addressof(types.types.types[unpack(type_index) - 1]);
        PackedInt parent_type_index;
        if (unpack(parent_type_index) != 0) {
            TNAType parent_type @ addressof(types.types.types[unpack(parent_type_index) - 1]);
        }
        PackedInt packed_flags;
        
        u32 flags = unpack(packed_flags);
        if (flags & 1 << 0) {
            PackedInt format_info;
        }
        if (flags & 1 << 1) {
            PackedInt subtype;
        }
        if (flags & 1 << 2) {
            PackedInt version;
        }
        if (flags & 1 << 3) {
            PackedInt byte_size;
            PackedInt alignment;
        }
        if (flags & 1 << 4) {
            PackedInt unknown_flags;
        }
        if (flags & 1 << 5) {
            PackedInt field_count;
            TBDYField fields[unpack(field_count)];
        }
        if (flags & 1 << 6) {
            PackedInt interface_count;
            TBDYInterface interfaces[unpack(interface_count)];
        }
    }
};

// TPTR is probably written to at runtime
// TST1 seems to be the tag names while FST1 is probably formats
// TNA1 is probably name mapping
// TBDY is the tag body
// TPAD is probably just padding
// THSH is tag hashes
struct Section {
    Size size;
    char signature[4];
    match(signature) {
        ("TPTR" | "TPAD"):
            u8 pad[size.size - 8];
        ("TST1" | "FST1"):
            String strings[while($ - addressof(this) <= size.size - 4)];
        ("TNA1" | "TNAM"):
            TNATypes types;
        ("TBDY" | "TBOD"):
            TBDY body[while($ - addressof(this) <= size.size - 4)];
        ("THSH"):
            u32 hashes[(size.size - 8) / 4];
    }
    std::mem::AlignTo<4>;
};

struct Item {
    le u32 flags;
    u32 type_index = flags & 0xFFFFFF;
    le u32 data_offset;
    le u32 count;
    
    if (type_index != 0) {
        TNAType type @ addressof(types.types.types[type_index - 1]);
    }
    
    u8 data @ data_section + data_offset;
};

struct Items {
    Size size_total;
    char magic0[4];
    Size size;
    char magic[4];
    Item items[while($ - addressof(this) <= size.size - 4)];
    std::mem::AlignTo<8>;
};

fn FindSection(char magic0, char magic1, char magic2, char magic3) {
    return std::mem::find_sequence(0, magic0, magic1, magic2, magic3) - 4;
};

struct Type {
    Size size;
    char magic[4];
    Section sections[while($ - addressof(this) < size.size - 4)];
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
};

struct Header {
    char magic[5];
    padding[1];
    le u16 reserve0;
    u16 bom;
    u8 major_ver;
    u8 minor_ver;
    le u32 hkt_offset;
    le u32 table0_offset;
    le u32 table1_offset;
    le u32 file_size;
    le u32 hkt_size;
    le u32 table0_size;;
    le u32 table1_size;
    le u32 reserve3;
    le u32 reserve4;
    
    TagFile hkt @ hkt_offset;
    u8 table0[table0_size] @ table0_offset;
    u8 table1[table1_size] @ table1_offset;
};

Section tag_strings @ FindSection('T', 'S', 'T', '1');
Section field_strings @ FindSection('F', 'S', 'T', '1');
Section types @ FindSection('T', 'N', 'A', '1');
u32 data_section = FindSection('D', 'A', 'T', 'A') + 8;
Header file @ 0x00;