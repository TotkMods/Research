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
| 0x30   | u32       | First Section Entry Count           |
| 0x34   | u32       | Second Section Entry Count          |
| 0x38   | u32       | Third Section Entry Count           |
| ...    | u32       | Unknown                             |
| 0x58   | float     | Unknown                             |
| ...    | u32       | Unknown                             |
| 0x70   | u32       | First Section Offset                |
| 0x74   | u32       | Second Section Offset               |
| 0x78   | u32       | Third Section Offset                |

# Section One
This section appears to store information about the file reference and resource types.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Type (seems to be an identifier)    |
| ...    | u32       | Unknown                             |
| 0x60   | u32       | Name Offset                         |
| 0x64   | u32       | File Extension Offset               |
| 0x68   | u32       | Japanese Name Offset (Unicode)      |
| 0x6C   | u32       | Resource Type Name Offset           |
| 0x70   | u32[4]    | Unknown                             |

# Section Two
This section appears to be similar to the material information array from *BotW*'s TSCB files.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Index                               |
| ...    | u32       | Unknown                             |
| 0x10   | float     | Unknown                             |
| 0x14   | float     | Unknown                             |
| ...    | u32       | Unknown                             |
| 0x20   | float     | Unknown                             |
| 0x24   | float     | Unknown                             |
| ...    | u32       | Unknown                             |
| 0x30   | float     | Unknown                             |
| 0x34   | float     | Unknown                             |
| 0x38   | float     | Unknown                             |
| 0x3C   | u32       | Unknown                             |

# Section Three
This section appears to be similar to the area array from *BotW*'s TSCB files.

The section begins with an array of u32 offsets to each entry in the section.

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | float     | X Position                          |
| 0x04   | float     | Z Position                          |
| 0x08   | float     | Area Size                           |
| ...    | u32       | Unknown                             |
| 0x60   | u32       | Filename Offset                     |
| 0x64   | u32       | Unknown (Always 4?)                 |
| 0x68   | u32[]     | Array of Extra Info Entry Offsets   |

The extra info entries are structured as follows:

| Offset | Data Type | Value                               |
|--------|-----------|-------------------------------------|
| 0x00   | u32       | Type (from Section One)             |
| ...    | u32       | Unknown                             |
| 0x20   | float     | Unknown                             |
| 0x24   | float     | Unknown                             |
| 0x28   | u32[6]    | Unknown                             |

# String Pool
Array of null-terminated strings - strings must be aligned on four bytes.

Encoding is UTF-8 with the exception of the Japanese name strings.