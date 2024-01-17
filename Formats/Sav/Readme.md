# SAV
SAV (**Sav**e) files store data about save files. Each save file contains multiple of SAV files; in *Tears of the Kingdom*, the majority of GameData flags are stored in the file named `progress.sav`. The file contains three primary sections: a header, an array of entries, and a save data array for array entries.

## Header

| Offset | Data Type | Value                    |
|--------|-----------|--------------------------|
| 0x00   | u32       | Magic (0x01020304)       |
| 0x04   | u32       | Format Version (from `GameDataList.Product.100.revision.txt` in 1.0.0 and `GameDataList.Product.110.revision.txt` in other versions)|
| 0x08   | u32       | Save Data Offset         |

## Entry Array
The entry array starts at offset 0x20 despite the header being only 12 bytes. Each entry is eight bytes:

| Offset | Data Type | Value                    |
|--------|-----------|--------------------------|
| 0x00   | u32       | Hash                     |
| 0x04   |           | Value/Offset             |

The section is divided into subsections by data type. The hash in the first entry in each section is empty while the value is an enum specifying the data type for that subsection.

| Value | Type           |
|-------|----------------|
| 0x00  | Bool           |
| 0x01  | BoolArray      |
| 0x02  | Int            |
| 0x03  | IntArray       |
| 0x04  | Float          |
| 0x05  | FloatArray     |
| 0x06  | Enum           |
| 0x07  | EnumArray      |
| 0x08  | Vector2        |
| 0x09  | Vector2Array   |
| 0x0A  | Vector3        |
| 0x0B  | Vector3Array   |
| 0x0C  | String16       |
| 0x0D  | String16Array  |
| 0x0E  | String32       |
| 0x0F  | String32Array  |
| 0x10  | String64       |
| 0x11  | String64Array  |
| 0x12  | Binary         |
| 0x13  | BinaryArray    |
| 0x14  | UInt           |
| 0x15  | UIntArray      |
| 0x16  | Int64          |
| 0x17  | Int64Array     |
| 0x18  | UInt64         |
| 0x19  | UInt64Array    |
| 0x1A  | WString16      |
| 0x1B  | WString16Array |
| 0x1C  | WString32      |
| 0x1D  | WString32Array |
| 0x1E  | WString64      |
| 0x1F  | WString64Array |
| 0x20  | Bool64bitKey   |

The value in each subsequent entry depends on what data type section the entry belongs to. For Bool, Int, Float, Enum, and UInt, the value is the value of the flag (Enum is a hash of the Enum value). For other data types, the value is an offset to the save data section. For array types, the first four bytes at the offset is a u32 count of the number of entries followed by the data. For Bool64bitKey, the data is an array of 64-bit hash keys that runs until it reaches a terminator (eight null bytes). For both types of binary data, the binary data begins with a u32 that specifies the size of the data.

## Notes
- Bool64bitKey only contains hashes for flags that are active and all other entries will be omitted
  - Old data is not overwritten each time the game is saved so it may still exist past the section terminator
- Save files allocate the necessary space to store all possible flags even if that space is not used which is why the second half of the file is usually empty

## GameDataList Notes
GameData is a system used in *Tears of the Kingdom* to store flags, usually for the save file. A list of such flags is found in `romfs/GameData/GameDataList.Product.110.byml.zs` (`romfs/GameData/GameDataList.Product.100.byml.zs` on version 1.0.0). GameData flags are organized by data type; the following types exist:

* Bool
* BoolArray
    * Is a bit array where each bit is a bool
* Int
* IntArray
* Float
* FloatArray
* Enum
* EnumArray
* Vector2
* Vector2Array
* Vector3
* Vector3Array
* String16
* String16Array (Unused)
* String32
* String32Array (Unused)
* String64
* String64Array
* Binary
* BinaryArray
* UInt
* UIntArray
* Int64 (unused)
* Int64Array (unused)
* UInt64
* UInt64Array
* WString16
* WString16Array
* WString32 (unused)
* WString32Array (unused)
* WString64 (unused)
* WString64Array (unused)
* Struct
    * Organizes Bool64bitKey values into structs
* BoolExp
    * Bool values that are dependent on other GameData flags (hence the **Exp**ression)
* Bool64bitKey
    * Array of 64-bit hash keys (usually correspond to HashId values from Banc files) that essentially act as state flag
        * If the key is a map object’s HashId ^ 1 (^ being bitwise XOR), then the flag controls that object’s equipment respawning
        * If the key is a map object’s HashId ^ 2 (^ being bitwise XOR), then the flag controls that object’s drops respawning
    * Always false by default, only the flags that are set are present in the save file

There are various parameters each GameData flag can have, these are explained below:


<table>
  <tr>
   <td><strong>Field Name</strong>
   </td>
   <td><strong>Purpose</strong>
   </td>
  </tr>
  <tr>
   <td>DefaultValue
   </td>
   <td>Default value of the flag
   </td>
  </tr>
  <tr>
   <td>Hash
   </td>
   <td>32-bit Murmur3 hash of the flag’s name (64-bit in Bool64bitKey)
   </td>
  </tr>
  <tr>
   <td>ResetTypeValue
   </td>
   <td>Bitfield determining when the flag’s value is reset (see below)
   </td>
  </tr>
  <tr>
   <td>SaveFileIndex
   </td>
   <td>File where the flag is written to when the game is saved (see below)
   </td>
  </tr>
  <tr>
   <td>ArraySize
   </td>
   <td>Number of entries in the array
   </td>
  </tr>
  <tr>
   <td>OriginalSize
   </td>
   <td>Unknown (usually either 1 or the size of the array, maybe dimensions?)
   </td>
  </tr>
  <tr>
   <td>ExtraByte
   </td>
   <td>Specifies no-reset zone for an object (see below)
   </td>
  </tr>
  <tr>
   <td>Values
   </td>
   <td>Array of values
   </td>
  </tr>
  <tr>
   <td>RawValues
   </td>
   <td>Array of unhashes values
   </td>
  </tr>
</table>

### ResetTypeValue Table

<table>
  <tr>
   <td><strong>Bit Index</strong>
   </td>
   <td><strong>Description</strong>
   </td>
  </tr>
  <tr>
   <td>0
   </td>
   <td>Resets to stored value when the area is loaded in (on BancChange)
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Reset to default on a new day (at midnight)
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Resets to default when reverting to default options (for settings)
   </td>
  </tr>
  <tr>
   <td>3
   </td>
   <td>Resets to default with a Blood Moon
   </td>
  </tr>
  <tr>
   <td>4
   </td>
   <td>Resets to stored value/defaults when loading a save/starting a new game
   </td>
  </tr>
  <tr>
   <td>5
   </td>
   <td>Unknown, resets to default on a new day but only sometimes?
   </td>
  </tr>
  <tr>
   <td>6
   </td>
   <td>Unknown, used on boot-up when SkipChangeSceneGameDataReset is false
   </td>
  </tr>
  <tr>
   <td>7
   </td>
   <td>Resets at midnight on Zonai respawn days
   </td>
  </tr>
  <tr>
   <td>8
   </td>
   <td>Resets using material respawning
   </td>
  </tr>
  <tr>
   <td>9
   </td>
   <td>Is not reset when starting a new game
   </td>
  </tr>
  <tr>
   <td>10+
   </td>
   <td>Unused
   </td>
  </tr>
</table>


### SaveFileIndex

At the end of the GameDataList file, there is a list of save file types - SaveFileIndex is an index into this list and the indexed file is where that flag is written (-1 mean the flag is not written to the save).

### ExtraByte

ExtraByte is a value from 1 to 80 that specifies the no-revival grid for an object. It only exists when ResetTypeValue bit 8 (material respawning) is set and the flag is part of Bool64bitKey. The value corresponds to map units, with 1 being A1, going from West to East then North to South. If the map object is not in the overworld, then ExtraByte will be 46 (F5) - usually.