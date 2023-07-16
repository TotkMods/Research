# Bhtmp
This file format stores some height related data. It does not include a complete height map of
the mesh world, but rather data used in the ui.

## Header
The header is the first 16 bytes in the file. In all the files in TOTK this header is.
```hex
64 00 00 00 64 00 00 00 00 00 00 00 00 00 00 00
```

## Data
After the header starts the data. The data continues until the end of the file. 
Each segment of data consists of 8 bytes. There are 1000 of these records per file.

Each file is a 100x100 2d array. The data starts in the top left corner of the array 
and ends in the bottom right.


## Combining
The files in totk are split up in files G_00-00.bhtmp to G_12-9.bhtmp. The letter signifies what 
map layer it is for.

| Letter | Layer   |
|  ---   | ---     |
|  S     | Sky     |
|  G     | Surface |
|  U     | Depths  |


The first number is the x coordinate of the map. The second is the y coordinate. Positive y goes south.