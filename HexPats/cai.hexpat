// By SuperSpazzy

struct Matrix4x4 {
    float r1, r2, r3, t1, r4, r5, r6, t2, r7, r8, r9, t3;
    float a1, a2, a3, a4;
};

struct OtherData {  // possibly state information
    u32 a;
    u32 b;
    u16 c;
    u16 d;  
};

struct Actor {
    Matrix4x4 mMatrix1; // primary matrix
    Matrix4x4 mMatrix2; // secondary matrix? not all have values

    float mMatrix3[0x06]; // some other matrix.
    char mName[128];
};

struct Header {
    char mMagic[6]; // CmbAct
    padding[2];
    u8 mVersion;
    u8 mCount;
};

struct File {
    Header mHeader;
    padding[2];
    Actor mActors[21];
    OtherData mData[21];
    float mMiscFloat[6]; // maybe the camera coordinates for image
    u8 mMiscData[520];
};

File file_at_0x0A @ 0x00;