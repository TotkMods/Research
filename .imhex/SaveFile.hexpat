// By SuperSpazzy, updated by dt12345

#pragma pattern_limit 1000000
#include <std/mem.pat>

enum StructType : u32 {
    Bool = 0x00,
    BoolArray = 0x01,
    Int = 0x02,
    IntArray = 0x03,
    Float = 0x04,
    FloatArray = 0x05,
    Enum = 0x06,
    EnumArray = 0x07,
    Vector2 = 0x08,
    Vector2Array = 0x09,
    Vector3 = 0x0A,
    Vector3Array = 0x0B,
    String16 = 0x0C,
    String16Array = 0x0D,
    String32 = 0x0E,
    String32Array = 0x0F,
    String64 = 0x10,
    String64Array = 0x11,
    Binary = 0x12,
    BinaryArray = 0x13,
    UInt = 0x14,
    UIntArray = 0x15,
    Int64 = 0x16,
    Int64Array = 0x17,
    UInt64 = 0x18,
    UInt64Array = 0x19,
    WString16 = 0x1A,
    WString16Array = 0x1B,
    WString32 = 0x1C,
    WString32Array = 0x1D,
    WString64 = 0x1E,
    WString64Array = 0x1F,
    Bool64bitKey = 0x20,
};

StructType mCurrentStruct = StructType::Bool;

struct Vector2 {
    float x;
    float y;
};

struct Vector3 : Vector2 {
    float z;
};

struct String<auto size> {
    char string[];
    padding[size - sizeof(string)];
};

struct Binary {
    u32 size;
    u8 data[size];
};

struct WString<auto size> {
    char16 string[];
    padding[size * 2 - sizeof(string)];
};

struct SaveEntry {
    u32 mHash;
    
    match(mHash) {
        (u32(0)):{ StructType mStructType; mCurrentStruct = mStructType; }
        (_): {
            match(mCurrentStruct) {
                (StructType::Bool): { bool mData; padding[3]; }
                (StructType::BoolArray): { u32 mOffset; u32 mCount @ mOffset; u8 mBitFlags[mCount / 8 < 4 ? 4 : mCount / 8] @ mOffset + 4;  }
                (StructType::Int): { s32 mValue; }
                (StructType::IntArray): { u32 mOffset; u32 mCount @ mOffset; s32 mValue[mCount] @ mOffset + 4; }
                (StructType::Float): { float mFloat; }
                (StructType::FloatArray): { u32 mOffset; u32 mCount @ mOffset; float mFloat[mCount] @ mOffset + 4; }
                (StructType::Enum): { u32 mEnumHash; }
                (StructType::EnumArray): { u32 mOffset; u32 mCount @ mOffset; u32 mEnumHash[mCount] @ mOffset + 4; }
                (StructType::Vector2): { u32 mOffset; Vector2 mVector2 @ mOffset; }
                (StructType::Vector2Array): { u32 mOffset; u32 mCount @ mOffset; Vector2 mVector2[mCount] @ mOffset + 4;}
                (StructType::Vector3): {  u32 mOffset; Vector3 mVector3 @ mOffset; }
                (StructType::Vector3Array): { u32 mOffset; u32 mCount @ mOffset; Vector3 mVector3[mCount] @ mOffset + 4; }
                (StructType::String16): { u32 mOffset; String<16> sString16 @ mOffset; }
                (StructType::String16Array): { u32 mOffset; u32 mCount @ mOffset; String<16> sString16[mCount] @ mOffset + 4; }
                (StructType::String32): { u32 mOffset; String<32> sString32 @ mOffset; }
                (StructType::String32Array): { u32 mOffset; u32 mCount @ mOffset; String<32> sString32[mCount] @ mOffset + 4; }
                (StructType::String64): { u32 mOffset; String<64> sString64 @ mOffset; }
                (StructType::String64Array): { u32 mOffset; u32 mCount @ mOffset; String<64> sString64[mCount] @ mOffset + 4; }
                (StructType::Binary): { u32 mOffset; Binary mData @ mOffset; }
                (StructType::BinaryArray): { u32 mOffset; u32 mCount @ mOffset; Binary mData[mCount] @ mOffset + 4;  }
                (StructType::UInt): { u32 mValue; }
                (StructType::UIntArray): { u32 mOffset; u32 mCount @ mOffset; u32 mValue[mCount] @ mOffset + 4; }
                (StructType::Int64): { u32 mOffset; s64 mValue @ mOffset; }
                (StructType::Int64Array): { u32 mOffset; u32 mCount @ mOffset; s64 mValue[mCount] @ mOffset + 4; }
                (StructType::UInt64): { u32 mOffset; u64 mValue @ mOffset; }
                (StructType::UInt64Array): { u32 mOffset; u32 mCount @ mOffset; u64 mValue[mCount] @ mOffset + 4; }
                (StructType::WString16): { u32 mOffset; WString<16> sWString16 @ mOffset; }
                (StructType::WString16Array): { u32 mOffset; u32 mCount @ mOffset; WString<16> sWString16[mCount] @ mOffset + 4; }
                (StructType::WString32): { u32 mOffset; WString<32> sWString32 @ mOffset; }
                (StructType::WString32Array): { u32 mOffset; u32 mCount @ mOffset; WString<32> sWString32[mCount] @ mOffset + 4; }
                (StructType::WString64): { u32 mOffset; WString<64> sWString64 @ mOffset; }
                (StructType::WString64Array): { u32 mOffset; u32 mCount @ mOffset; WString<64> sWString64[mCount] @ mOffset + 4; }
                (StructType::Bool64bitKey): { u32 mOffset; if (mOffset != 0) { u64 mKeys[while(std::mem::read_unsigned($, 8))] @ mOffset; } }
                (_): padding[4];
            }
          }       
        }
};

struct Header {
    u32 magic; // 0x01020304
    u32 format_version; // found in romfs/GameData/GameDataList.Product.[ver].revision.txt
    u32 save_data_offset; // for arrays
    std::mem::AlignTo<0x20>;
    
    SaveEntry BoolEntries[while(mCurrentStruct == StructType::Bool)];
    SaveEntry BoolArrayEntries[while(mCurrentStruct == StructType::BoolArray)];
    SaveEntry IntEntries[while(mCurrentStruct == StructType::Int)];
    SaveEntry IntArrayEntries[while(mCurrentStruct == StructType::IntArray)];
    SaveEntry FloatEntries[while(mCurrentStruct == StructType::Float)];
    SaveEntry FloatArrayEntries[while(mCurrentStruct == StructType::FloatArray)];
    SaveEntry EnumEntries[while(mCurrentStruct == StructType::Enum)];
    SaveEntry EnumArrayEntries[while(mCurrentStruct == StructType::EnumArray)];
    SaveEntry Vector2Entries[while(mCurrentStruct == StructType::Vector2)];
    SaveEntry Vector2ArrayEntries[while(mCurrentStruct == StructType::Vector2Array)];
    SaveEntry Vector3Entries[while(mCurrentStruct == StructType::Vector3)];
    SaveEntry Vector3ArrayEntries[while(mCurrentStruct == StructType::Vector3Array)];
    SaveEntry String16Entries[while(mCurrentStruct == StructType::String16)];
    SaveEntry String16ArrayEntries[while(mCurrentStruct == StructType::String16Array)];
    SaveEntry String32Entries[while(mCurrentStruct == StructType::String32)];
    SaveEntry String32ArrayEntries[while(mCurrentStruct == StructType::String32Array)];
    SaveEntry String64Entries[while(mCurrentStruct == StructType::String64)];
    SaveEntry String64ArrayEntries[while(mCurrentStruct == StructType::String64Array)];
    SaveEntry BinaryEntries[while(mCurrentStruct == StructType::Binary)];
    SaveEntry BinaryArrayEntries[while(mCurrentStruct == StructType::BinaryArray)];
    SaveEntry UIntEntries[while(mCurrentStruct == StructType::UInt)];
    SaveEntry UIntArrayEntries[while(mCurrentStruct == StructType::UIntArray)];
    SaveEntry Int64Entries[while(mCurrentStruct == StructType::Int64)];
    SaveEntry Int64ArrayEntries[while(mCurrentStruct == StructType::Int64Array)];
    SaveEntry UInt64Entries[while(mCurrentStruct == StructType::UInt64)];
    SaveEntry UInt64ArrayEntries[while(mCurrentStruct == StructType::UInt64Array)];
    SaveEntry WString16Entries[while(mCurrentStruct == StructType::WString16)];
    SaveEntry WString16ArrayEntries[while(mCurrentStruct == StructType::WString16Array)];
    SaveEntry WString32Entries[while(mCurrentStruct == StructType::WString32)];
    SaveEntry WString32ArrayEntries[while(mCurrentStruct == StructType::WString32Array)];
    SaveEntry WString64Entries[while(mCurrentStruct == StructType::WString64)];
    SaveEntry WString64ArrayEntries[while(mCurrentStruct == StructType::WString64Array)];
    SaveEntry Bool64bitKeyEntries[while($ < save_data_offset)];
};

Header save_file @ 0x00;