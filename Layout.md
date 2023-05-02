# TOTK File Layout
Tears of the Kingdom uses a much different file structure than Breath of the 
Wild, so this document is intended to show where you can find what you're
looking for.

## Textures
All textures for all assets appear to be in the `/TexToGo` folder, in `.txtg`
files. See `formats/TexToGo.md` for formatting details. In BOTW you would have
1 BFRES file with all of the albedo, normal map, specular maps, and dyes for a 
model. In TOTK, all of these are separate files. This means 2 mods can edit 
textures on the same model without conflicting, and you don't need to distribute
all of a model's textures to change just one.

## Inventory Thumbnails
Icons for weapons and other inventory items seem to be in `/UI/Tex/Icon`. They 
are ZSTD-compressed BNTX textures. No ZSTD dictionary is needed.

## Compendium Entries
We think these are in `/UI/Tex/PictureBook`. Unconfirmed.

## Inventory Sorting
This file is presumed to control the sorting order of the inventory:
`/UI/PouchSortTable/PouchSortTable.game__ui__PouchSortTable.bgyml`

## Map and Dungeon Textures
ZSTD-compressed BNTX files with the dungeon and map textures can be found in
`/UI/Map`.
