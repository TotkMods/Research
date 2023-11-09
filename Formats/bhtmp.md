# BHTMP
BHTMP (**B**inary **H**eigh**t** **M**a**p**) is a data format used for storing height map data used in the UI map. It is separate from terrain height map data.

## Header
The file has an eight-byte header structured as follows:
| Offset | Data Type | Value |
| ------ | --------- | ----- |
| 0x00   | u32       | Height |
| 0x04   | u32       | Width |

## Data
Following the header is the file data which is an array of dimensions Height x Width (as specified in the header). The data must be aligned to eight bytes (i.e. it starts at 0x10) and each data entry is eight bytes. Each entry is structured as follows:

| Offset | Data Type | Value |
| ------ | --------- | ----- |
| 0x00   | float     | Value (Y-Coordinate) |
| 0x04   | float     | Has Data (1.0 if has data else 0.0) |

## Maps
BHTMP files form a 12x10 grid for each of the game's maps and are split into three groups for each of the three maps. The letter in the filename specifies the map that file is used for:

| Letter | Layer   |
|  ---   | ---     |
|  S     | Sky (S for Sky)    |
|  G     | Surface (G for Ground) |
|  U     | Depths (U for Underground) |

The first number in the filename is the X grid index of the file while the second number is the Z grid index (postive X is east and positive Z is south). For example, `U_10-06.bhtmp` would be the 11th map grid going from west to east and 7th map grid going from north to south.