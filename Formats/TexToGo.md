# TexToGo File Format
> (romfs/TexToGo/*.txtg)

## Updated Format from [zoeysaurusrex](https://gist.github.com/zoeysaurusrex)

https://gist.github.com/zoeysaurusrex/0c8a1ae2e218d1c76959765bf9e9c408

## Header (outdated)

> | Position | Data Type | Description |
> |:--------:|:---------:|:---------------|
> | 0x00     | char[8]   | `P◇◇◇6PK0`/`50 00 11 00 36 50 4B 30` Magic? |
> | 0x08     | UInt16    | Texture Height |
> | 0x0A     | UInt16    | Texture Width |
> | 0x0C     | UInt16    | `01 00` (1, always 1?) |
> | 0x0E     | UInt16    | `0A 02` (522, 521) |
> | 0x10     | UInt16    | `01 00` (1, always 1?) |
> | 0x12     | UInt16    | `00 01` (256, sometimes 0 - could be `padding[1] bool[1]`) |
> | 0x14     | UInt16    | `08 09` (2312, sometimes `00 00` - could be two enums) |
> | 0x16     | UInt16    | `0A 03` (778, 1280, varies) |
> | 0x18     | UInt16    | `00 01` (1, sometimes 0 - could be `padding[1] bool[1]`) |
> | 0x1A     | UInt16    | `02 03` (522, 1280, varies) |
