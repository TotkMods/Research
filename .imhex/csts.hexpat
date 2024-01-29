struct Matrix33 {
    float x1;
    float y1;
    float z1;
    float x2;
    float y2;
    float z2;
    float x3;
    float y3;
    float z3;
};

struct Stats {
    char magic[4]; // CSTS
    u32 reserve;
    u32 count;
    Matrix33 matrices[count];
};

Stats file @ 0x00;