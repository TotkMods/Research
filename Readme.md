# TOTK Research

File research for Tears of the Kingdom

---

## .zs (Compression)

***Files can be decompressed with [Totk.ZStd Tool](https://github.com/TotkMods/Totk.ZStdTool)***

Dictionaries found in `romfs/Pack/ZsDic.pack.zs`

## .aamp

Parameter files (same as *BotW*)

Relatively rare and mostly exist under other extensions (also found embedded in Phive files)

Extensions:
- .baglblm - **B**inary **agl** **Bl**oo**m**
  - Stores bloom data
- .baglccr - 
- .baglclwd - 
- .baglcube - 
- .bagldof - 
- .baglenv - **B**inary **agl** **Env**ironment
- .baglenvset - **B**inary **agl** **Env**ironment **Set**ting
- .baglfila - 
- .bagllmap - 
- .baglmf - 
  - Stores filter data
- .baglshpp - 
- .baglsky - **B**inary **agl** **Sky** (???)
- .bgapkginfo - 
- .bgapkglist - 
- .bgenv - 
- .bglght - 
- .bgmsconf - 
- .bgsdw - 
- .bphhb - **B**inary **Ph**ive **H**elper **B**one
  - Stores helper bone data
- .bptcl - **B**inary **P**ar**t**i**cl**e
- .bptclconf - **B**inary **P**ar**t**i**cl**e **Conf**iguration

## .ainb
> **AI** **N**ode **B**inary

Node-based AI and logic format

Files themselves serve as nodes in larger file trees (.root.ainb vs .module.ainb)

[Documentation here](Formats/ainb.md)

Python library available here:
https://github.com/dt-12345/ainb

## .asb
> **A**nimation **S**equence **B**inary

Node-based animation sequence format

[Format Notes](https://docs.google.com/document/d/1iAgTwK0otUaDvb_0Si0TJYiQa7BeI4qNWAX54WUiXTo/edit)

## .baatarc
> **B**inary **A**udio **At**tenuation **Arc**hive

## .baev
> **B**inary **A**nimation **Ev**ent

Format for storing data about animation events

## .bagst
> **B**inary **A**udio **G**roup **S**e**t**tings

## .bars
> **B**inary **A**udio **R**e**s**ource

Audio resource archive (unknown changes from *BotW*)

## .bcul
> **B**inary **Cul**ling

Stores area culling data

## .beco
> **B**inary **Eco**system

Stores per-coordinate data

[ZeldaMods Article](https://zeldamods.org/wiki/Beco)

## .belnk
> **B**inary **EL**i**n**k2

XLink2 file format for ELink2 (similar to the XLink2 Thunder format from *Splatoon 3*)

[Shadow's XLink2 Library Recreation](https://github.com/shadowninja108/WoomLink)

## .bfarc
> **B**inary **F**ont **Arc**hive

SARC font archive

## .bfcpx

Font format

## .bfevfl
> **B**inary Ca**f**é **Ev**ent **Fl**ow

Event flow and event timeline format (minor changes from *BotW*, [PR pending for EVFL library](https://github.com/zeldamods/evfl/pull/5))

## .bflan
> **B**inary Ca**f**é **L**ayout **An**imation

Layout animation format

## .bfres
> **B**inary Ca**f**é **Res**ource

Archive format for animations, textures, and models

BFRES v10

## .bfsha
> **B**inary Ca**f**é **Sha**der

## .bgyml
> **B**inary **G**enerated **Y**A**ML** (???)

BYML v7, several new node types added

## .bhtmp
> **B**inary **H**eigh**t** **M**a**p**

Height related data. Explanation on structure [here](Formats/bhtmp.md).

## .bkres
> **B**a**k**e **Res**ource (???)

SARC archive with one (?) BYML file inside of it, stores bake info

## .blal
> **B**inary **L**ooped **A**sset **L**ist

Stores hashes of looped audio assets

[Python Library from *BotW*](https://github.com/GingerAvalanche/blal)

## .blarc
> **B**inary **L**ayout **Arc**hive

SARC layout archive

## .blwp

Stores forest and tree data, multipe types exist under the same extension (shared 8 byte header)

### BLWP Header

| Offset | Type    | Value          |
|--------|---------|----------------|
| 0x00   | u16     | Unknown        |
| 0x02   | u16     | Unknown        |
| 0x04   | u32     | Section 1 Entry Count    |

## .bnsh
> **B**inary **N**X **Sh**ader

## .bntx
> **B**inary **N**X **T**e**x**ture

Texture archive (unknown changes from Botw 1.6.0)

## .bnvib
> **B**inary **Vib**ration

HD Rumble data format

[SwitchBrew Documentation](https://switchbrew.org/wiki/BNVIB)

## .bofx
> **B**inary **O**cclusion **FX**

BFRES archive for occlusion effects

## .bphcl
> **B**inary **Ph**ive **Cl**oth

Phive cloth physics format (Phive is a library that extends Havok)

## .bphnm
> **B**inary **Ph**ive **N**av **M**esh

Phive NavMesh format (Phive is a library that extends Havok)

## .bphsc
> **B**inary **Ph**ive **S**tatic **C**ompound

Phive format for static compounds (Phive is a library that extends Havok)

## .bphsh
> **B**inary **Ph**ive **Sh**ape

Phive format for rigid bodies (Shapes) (Phive is a library that extends Havok)

## .bslnk
> **B**inary **SL**i**nk**2

XLink2 file format for SLink2 (similar to the XLink2 Thunder format from *Splatoon 3*)

[Shadow's XLink2 Library Recreation](https://github.com/shadowninja108/WoomLink)

## .bstar

Stores strings (purpose unknown, found in `romfs/Preload`)

| Offset | Type    | Value          |
|--------|---------|----------------|
| 0x00   | char[4] | Magic ("STAR") |
| 0x04   | u32     | Version        |
| 0x08   | u32     | Entry Count    |
| 0x0c   | u32[]   | Array of entries|

## .bushvt

Some type of shader format

## .bwav
> **B**inary **WAV**

Audio resource format

[Documentation](https://gota7.github.io/Citric-Composer/specs/binaryWav.html)

Most bwav files seem to play fine in [foobar2000](https://www.foobar2000.org/) (with the [vgmStream](https://github.com/vgmstream/vgmstream) plugin), however some files (notably in the `Voice/Resource/XXcc/EventFlowMsg` folders) fail to play. The headers of these files appear to have an incorrect sample count.

```
Unable to open item for playback (Unsupported format or corrupted file):
"F:\Games\Totk\Voice\Resource\USen\EventFlowMsg\Dm_BZ_0007_Stream\Dm_BZ_0007_Text_002_b.bwav"
```

## .byaml
> **B**inary **YAML**

See [.byml](#.byml)

## .byml
> **B**inary **Y**A**ML**

BYML v4 or v7 (.esetb.byml is v5 and contains an embedded .ptcl file)

[ZeldaMods Article](https://zeldamods.org/wiki/BYML)

#### v7 Node Types (courtesy of Watertoon)

Note: v7 root nodes can be 0x20, 0x21, 0xC0, or 0xC1 (warning: this breaks a lot of BYML tools)

```c
enum class ByamlDataType : u8 {
    HashArrayU32_1           = 0x20,
    HashArrayU32_2           = 0x21,
    ...
    HashArrayU32_16          = 0x2f,
    HashArrayWithRemapU32_1  = 0x30,
    HashArrayWithRemapU32_2  = 0x31,
    ...
    HashArrayWithRemapU32_16 = 0x3f,
    StringIndex              = 0xa0,
    BinaryData               = 0xa1,
    BinaryDataWithAlignment  = 0xa2,
    Array                    = 0xc0,
    Dictionary               = 0xc1,
    KeyTable                 = 0xc2,
    DictionaryWithRemap      = 0xc4,
    RelocatedKeyTable        = 0xc5,
    MonoTypedArray           = 0xc8,
    Bool                     = 0xd0,
    S32                      = 0xd1,
    F32                      = 0xd2,
    U32                      = 0xd3,
    S64                      = 0xd4,
    U64                      = 0xd5,
    F64                      = 0xd6,
    Null                     = 0xff,
};
```

## .cai
> **C**ombined **A**ctor **I**nfo

Stores position and rotation data for Autobuild constructions

.totkab also exists which is the same format but with an additional header

[Graphical CAI Editor](http://dev.ssmvc.org:8080/bleh.html)

## .chunk

Cave chunked mesh info

## .crbin

Cave-related info

## .cutinfo
> **Cut**scene **Info**

## .dpi
> **D**estructible **P**iece **I**nfo

## .extm

Material data

## .genvb
> **G**ame **Env**ironment **B**inary (???)

SARC archive for environmental effects

## .genvres
> **G**ame **Env**ironment **Res**ource (???)

BFRES archive for environmental effects

## .gsh
> **G**X2 **Sh**ader

Shader format

## .glsl
> Open**GL** **S**hading **L**anguage (???)

Shader format

[Documentation](https://github.com/kinnay/Nintendo-File-Formats/wiki/Gfx2-File-Format)

## .hght
> **H**ei**ght**

Height map format (no noted changes since *BotW*)

[Documentation](https://github.com/handsomematt/botw-modding/blob/master/docs/file_formats/hght.md)

## .jpg

Digital image format

## .mate
> **Mate**rial

Material data format (no noted changes since *BotW*)

[Documentation](https://github.com/handsomematt/botw-modding/blob/master/docs/file_formats/mate.md)

## .mc
> **M**esh**C**odec

MCPK

MeshCodec, an archive/compression format wrapped around the model fles (bfres v10)

## .msbt
> **M**essage **S**tudio **B**inary **T**ext

Stores text data and localization info

[Documentation](https://acmods.org/wiki/New_Horizons:MSBT) and [Functions](https://acmods.org/wiki/New_Horizons:MSBT_functions)

## .pack

SARC archives, no noted changes from Botw

## .png

I don't think I need to explain this one

## .ptcl
> **P**ar**t**i**cl**e

Stores particle effects data, only found embedded in .esetb.byml files

## .quad

```
...
```

## .raw

Only used by one file (`arrow.raw`)

## .rsizetable
> **R**esource **Size Table**

Updated RSTB table (RESTBL), spec can be found in [Totk.Analyze/src/Formats/RESTBL.cs](https://github.com/TotkMods/Totk.Analyze/blob/master/Totk.Analyze/Formats/RESTBL.cs)

## .sarc
> **S**tandard **Arc**hive (???)

SARC archives (see [.pack](#pack))

## .sav
> **Sav**e

Save data file format

[Save Game Editor](https://www.marcrobledo.com/savegame-editors/zelda-totk/)

## .sharcb
> **Sh**ader **Arc**hive **B**inary

Shader archive format

[Documentation](https://github.com/kinnay/Nintendo-File-Formats/wiki/SHARCFB-File-Format)

## .skybin
> **Sky** **Bin**ary 

## .ta
> **T**errain **A**rchive (???)

SARC archive for terrain data

## .tscb
> **T**errain **Sc**ene **B**inary

[ZeldaMods Documentation](https://zeldamods.org/wiki/TSCB)

## .txt

I think you can manage this one

## .txtg
> **T**e**x** **T**o **G**o

TexToGo texture format

## .vsts
> **V**olume **St**at**s**

Exists in two variants: volume stats (magic = VSTS) and grass stats (magic = GSTS)

## .wbr
> **W**eapon **B**lu**r**

Weapon blur file format

## .webm

Pre-rendered cutscenes (compressed)
