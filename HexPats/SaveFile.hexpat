// By SuperSpazzy

#pragma pattern_limit 300000

enum StructType : u32 {
    Bool = 0,
    BoolArray = 1,
    Int32 = 2,
    Int32Array = 3,
    Float = 4,
    FloatArray = 5,
    Enum = 6,
    EnumArray = 7,
    Vector2 = 8, // Probably
    Vector2Array = 9,
    Vector3 = 10,
    Vector3Array = 11,
    String16 = 12, // Maybe
    String16Array = 13, // A guess, doesn't exist in GameDataList
    String32 = 14,
    String32Array = 15, // Probably
    String64 = 16,
    String64Array = 17,
    Binary = 18,
    BinaryArray = 19,
    UInt32 = 20,
    UInt32Array = 21,
    StructType22 = 22,
    StructType23 = 23,
    UInt64 = 24,
    UInt64Array = 25,
    WString16 = 26, // Probably
    WString16Array = 27,
    StructType28 = 28,
    StructType29 = 29,
    StructType30 = 30,
    StructType31 = 31,
    UnknownData = 32, // bytes that have some kind of sequence
};

struct Vector3 { 
    float X;
    float Y;
    float Z;
};

struct Vector2 { 
    float X;
    float Y;
};

struct StringObject<auto T> {
    char mString[];
    padding[T - sizeof(mString)];
};

struct WStringObject<auto T> {
    char16 mWString[];
    padding[(T * 2) - sizeof(mWString)];
};

struct BinaryObject {
    u32 mSize;
    u8 mData[mSize];
};

struct SaveEntry {
    u32 mHash;
    
    match(mHash) {
        (u32(0)):{ StructType mStructType; mCurrentStruct = mStructType; }
        (_): {
            match(mCurrentStruct) {
                (StructType::Bool): { bool mData; padding[3]; }
                (StructType::BoolArray): { u32 mOffset; u32 mCount @ mOffset; u8 mBitFlags[mCount / 8 < 4 ? 4 : mCount / 8] @ mOffset + 4;  }
                (StructType::Int32): { s32 mValue; }
                (StructType::Int32Array): { u32 mOffset; u32 mCount @ mOffset; s32 mValue[mCount] @ mOffset + 4; }
                (StructType::Float): { float mFloat; }
                (StructType::FloatArray): { u32 mOffset; u32 mCount @ mOffset; float mFloat[mCount] @ mOffset + 4; }
                (StructType::Enum): { u32 mEnumHash; }
                (StructType::EnumArray): { u32 mOffset; u32 mCount @ mOffset; u32 mEnumHash[mCount] @ mOffset + 4; }
                (StructType::Vector2): { u32 mOffset; Vector2 mVector2 @ mOffset; }
                (StructType::Vector2Array): { u32 mOffset; u32 mCount @ mOffset; Vector2 mVector2[mCount] @ mOffset + 4;}
                (StructType::Vector3): {  u32 mOffset; Vector3 mVector3 @ mOffset; }
                (StructType::Vector3Array): { u32 mOffset; u32 mCount @ mOffset; Vector3 mVector3[mCount] @ mOffset + 4; }
                (StructType::String16): { u32 mOffset; char sString16[16] @ mOffset; }
                (StructType::String16Array): { u32 mOffset; u32 mCount @ mOffset; StringObject<16> sString16[mCount] @ mOffset + 4; }
                (StructType::String32): { u32 mOffset; char sString32[32] @ mOffset; }
                (StructType::String32Array): { u32 mOffset; u32 mCount @ mOffset; StringObject<32> sString32[mCount] @ mOffset + 4; }
                (StructType::String64): { u32 mOffset; char sString64[64] @ mOffset; }
                (StructType::String64Array): { u32 mOffset; u32 mCount @ mOffset; StringObject<64> sString64[mCount] @ mOffset + 4; }
                (StructType::Binary): { u32 mOffset; BinaryObject mObject @ mOffset; }
                (StructType::BinaryArray): { u32 mOffset; u32 mCount @ mOffset; BinaryObject mObject[mCount] @ mOffset + 4;  }
                (StructType::UInt32): { u32 mValue; }
                (StructType::UInt32Array): { u32 mOffset; u32 mCount @ mOffset; u32 mValue[mCount] @ mOffset + 4; }
                
                (StructType::StructType22): { u32 mOffset; u32 mUnknownPos22 @ mOffset; }
                (StructType::StructType23): { u32 mOffset; u32 mUnknownPos23 @ mOffset; }
                
                (StructType::UInt64): { u32 mOffset; u64 mValue @ mOffset; }
                (StructType::UInt64Array): { u32 mOffset; u32 mCount @ mOffset; u64 mValue[mCount] @ mOffset + 4; }
                (StructType::WString16): { u32 mOffset; char16 sString16[16] @ mOffset; }
                (StructType::WString16Array): { u32 mOffset; u32 mCount @ mOffset; WStringObject<16> sWString16[mCount] @ mOffset + 4; }
                
                (StructType::StructType28): { u32 mOffset; u32 mUnknownPos28 @ mOffset; }
                (StructType::StructType29): { u32 mOffset; u32 mUnknownPos29 @ mOffset; }
                (StructType::StructType30): { u32 mOffset; u32 mUnknownPos30 @ mOffset; }
                (StructType::StructType31): { u32 mOffset; u32 mUnknownPos21 @ mOffset; }
                
                (StructType::UnknownData): { u32 mOffset; u32 mUnknownPosData @ mOffset; }
                (_): padding[4];
            }
          }       
        }                
};

struct Header {
    u32 mMagic; /* 0x01020304 */
    u32 mVersion;
    u32 mMetaDataOffsetPos;
};

struct File {
    Header mHeader;
    padding[0x20 - $];
    SaveEntry BoolEntries[while(mCurrentStruct == StructType::Bool)];
    SaveEntry BoolArrayEntries[while(mCurrentStruct == StructType::BoolArray)];
    SaveEntry Int32Entries[while(mCurrentStruct == StructType::Int32)];
    SaveEntry Int32ArrayEntries[while(mCurrentStruct == StructType::Int32Array)];
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
    SaveEntry UInt32Entries[while(mCurrentStruct == StructType::UInt32)];
    SaveEntry UInt32ArrayEntries[while(mCurrentStruct == StructType::UInt32Array)];
    
    SaveEntry StructType22Entries[while(mCurrentStruct == StructType::StructType22)];
    SaveEntry StructType23Entries[while(mCurrentStruct == StructType::StructType23)];
    
    SaveEntry UInt64Entries[while(mCurrentStruct == StructType::UInt64)];
    SaveEntry UInt64ArrayEntries[while(mCurrentStruct == StructType::UInt64Array)];
    SaveEntry WString16Entries[while(mCurrentStruct == StructType::WString16)];
    SaveEntry WString16ArrayEntries[while(mCurrentStruct == StructType::WString16Array)];
    
    SaveEntry StructType28Entries[while(mCurrentStruct == StructType::StructType28)];
    SaveEntry StructType29Entries[while(mCurrentStruct == StructType::StructType29)];
    SaveEntry StructType30Entries[while(mCurrentStruct == StructType::StructType30)];
    SaveEntry StructType31Entries[while(mCurrentStruct == StructType::StructType31)];
    
    SaveEntry UnknownDataEntries[while(mCurrentStruct == StructType::UnknownData && $ < mHeader.mMetaDataOffsetPos)];
    
   // SaveEntry Remainder[while($ < Header.mMetaDataOffsetPos)];

};

StructType mCurrentStruct = StructType::Bool;
File file_at_0x0A @ 0x00;