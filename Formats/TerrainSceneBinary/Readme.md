# TSCB
TSCB (**T**errain **Sc**ene **B**inary) files store and reference data about the game's terrain. The version found in *Tears of the Kingdom* is not the same as that of *Breath of the Wild*. These files reference data from `.hght`, `.water.extm`, `.grass.extm`, `.bake.extm`, and `.mate` files.

The file contains a 0x7C byte header, three sections, and a string pool. Offsets are relative to the first byte of the offset.

# Header
| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | char[4]   | Magic ("TSCB")                      |
| 0x04   | u32       | Version (0x70C)                     |
| 0x08   | u32       | Unknown                             |
| 0x0C   | u32       | String Pool Offset                  |
| 0x10   | float     | World Scale                         |
| 0x14   | float     | Maximum Mesh Height                 |
| ...    | u32       | Unknown                             |
| 0x30   | u32       | File Types Array Entry Count        |
| 0x34   | u32       | Material Info Array Entry Count     |
| 0x38   | u32       | Area Array Entry Count              |
| ...    | u32       | Unknown                             |
| 0x58   | float     | Tile Size                           |
| ...    | u32       | Unknown                             |
| 0x70   | u32       | File Types Array Offset             |
| 0x74   | u32       | Material Info Array Offset          |
| 0x78   | u32       | Area Array Offset                   |

# File Types Array
This section contains info about the file types referenced in later sections.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Type                                |
| ...    | u32       | Unknown                             |
| 0x60   | u32       | Name Offset                         |
| 0x64   | u32       | File Extension Offset               |
| 0x68   | u32       | Japanese Name Offset (Unicode)      |
| 0x6C   | u32       | Resource Type Name Offset           |
| 0x70   | u32[4]    | Unknown                             |

### File Types

| Type        | Value  |
|-------------|--------|
| Height Map  | 0x0000 |
| Normal Map  | 0x0100 |
| Material    | 0x2000 |
| Grass       | 0x4000 |
| Water       | 0x4100 |
| Bake        | 0x5000 |  

# Material Information Array
This section stores data about different material types.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Index                               |
| ...    | u32       | Unknown                             |
| 0x10   | float     | u-Axis                              |
| 0x14   | float     | v-Axis                              |
| ...    | u32       | Unknown                             |
| 0x20   | float     | Unknown                             |
| 0x24   | float     | Unknown                             |
| ...    | u32       | Unknown                             |
| 0x30   | float     | Unknown                             |
| 0x34   | float     | Unknown                             |
| 0x38   | float     | Unknown                             |
| 0x3C   | u32       | Unknown                             |

# Area Array
This section stores data about the area tiles that make up the terrain.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | float     | X Position                          |
| 0x04   | float     | Z Position                          |
| 0x08   | float     | Area Size                           |
| ...    | u32       | Unknown                             |
| 0x60   | u32       | Filename Offset (no extension)      |
| 0x64   | u32       | Unknown (Always 4?)                 |
| 0x68   | u32[]     | File Info Array                     |

The file info entries are structured as follows:

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Type (from Section One)             |
| ...    | u32       | Unknown                             |
| 0x20   | float     | Minimum Height                      |
| 0x24   | float     | Maximum Height                      |
| 0x28   | u32[6]    | Unknown                             |

# String Pool
Array of null-terminated strings - strings must be aligned on four bytes.

Encoding is UTF-8 with the exception of the Japanese name strings which use Unicode.