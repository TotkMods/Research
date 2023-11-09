# PTCL
PTCL (**P**ar**t**i**cl**e) files store information about various particle and visual effects. This version of the format is for use with the nn::vfx2 library.

The file is split into multiple sections each with their own sub-sections. Offsets in a section are relative to the start of that section's header. Main sections must be aligned to eight bytes.

Some of this is based on [Deep Sea Knowledge's PTCL article](https://wiki.oatmealdome.me/PTCL_(File_Format))

# Header
| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | char[8]   | Magic ("VFXB    ")                  |
| 0x08   | u8        | Unknown                             |
| 0x09   | u8        | Graphics API Version                |
| 0x0A   | u16       | VFX API Version                     |
| 0x0C   | u16       | Byte Order Mark                     |
| 0x0E   | u16       | Unknown                             |
| 0x10   | u32       | Filename Offset                     |
| 0x14   | u16       | Unknown                             |
| 0x16   | u16       | First Section Offset (usually ESTA) |
| 0x18   | u32       | Unknown                             |
| 0x1C   | u32       | File Size                           |

# Section Header Base

All section headers share a similar structure for the first 20 bytes, offset will be -1 if not applicable.

| Offset | Data Type | Value                                |
|--------|-----------|--------------------------------------|
| 0x00   | char[4]   | Magic                                |
| 0x04   | u32       | Size (what the size is of can vary)  |
| 0x08   | s32       | Subsection Array Offset              |
| 0x0C   | s32       | Next Section/Subsection Offset       |
| 0x10   | s32       | Next Sub-Subsection Offset           |

# ESTA Section
> **E**mitter **S**e**t** **A**rray

This section contains a section header followed by an array of ESET subsections.

| Offset | Data Type | Value                  |
|--------|-----------|------------------------|
| ...    | ...       | ...                    |
| 0x14   | u32       | Unknown                |
| 0x18   | u32       | Unknown                |
| 0x1C   | u32       | ESET Count             |

# ESET Subsection
> **E**mitter **SET**

This section contains a section header followed by an array of EMTR sub-subsections.

| Offset | Data Type | Value                   |
|--------|-----------|-------------------------|
| ...    | ...       | ...                     |
| 0x14   | u32       | Unknown                 |
| 0x18   | u32       | Unknown                 |
| 0x1C   | u32       | EMTR Count              |
| 0x20   | char[16]  | Unknown (usually empty) |
| 0x30   | char[]    | Emitter SET Name        |

# EMTR Sub-Subsection
> **Em**i**t**te**r**

This section contains a section header followed by data followed by subsections.

| Offset | Data Type | Value                                           |
|--------|-----------|-------------------------------------------------|
| ...    | ...       | ...                                             |
| 0x14   | u32       | Emitter Name Offset (relative to header + 0x10) |
| 0x18   | ???       | Unknown                                         |
|        | char[]    | Emitter Name                                    |

# File Structure
Not all sections may be present

- PTCL
  - ESTA
    - ESET
      - EMTR
      - CSDP
      - CADP
      - FCSF
      - FRND
  - PRMA
    - PRIM
  - TRMA
  - GRTF (haven't seen this in *TotK*)
    - GTNT // contains BNTX
  - G3PR
    - G3NT // contains BFRES
  - GRSN
    - GRSR // contains BNSH
    - GRRI
    - GRSC
    - GRRE
    - GRCE
    - GRCI