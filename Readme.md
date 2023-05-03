# TOTK Research

File research for Tears of the Kingdom

---

## .zs (Compression)

***Files can be decompressed with [Totk.ZStd Tool](https://github.com/TotkMods/Totk.ZStdTool)***

## .bwav (Sound)

Most bwav file file seem to play fine in [foobar2000](https://www.foobar2000.org/) (with the [vgmStream](https://github.com/vgmstream/vgmstream) plugin), however some files (notably in the `Voice/Resource/XXcc/EventFlowMsg` folders) fail to play.

```
Unable to open item for playback (Unsupported format or corrupted file):
"F:\Games\Totk\Voice\Resource\USen\EventFlowMsg\Dm_BZ_0007_Stream\Dm_BZ_0007_Text_002_b.bwav"
```

## .bgyml (Params, BYML)

A lot of files seem to be just uncompressed BYML v7 files, with the .bgyml extension. I haven't tried editing them yet, but I can read them with [Switch Toolbox](https://github.com/KillzXGaming/Switch-Toolbox) just fine.

## .bkres (compressed)

Bkres files are just SARC archives with a single(?) BYML file inside of them.

## .bphsh
> **B**inary **Ph**ive **Sh**ape

Updated havok file format (Phive) used for RigidBodies (Shapes)

## .bphsc
> **B**inary **Ph**ive **S**tatic **C**ompound

Updated havok file format (Phive) used for StaticCompound

## .bphnm
> **B**inary **Ph**ive **N**av **M**esh

Updated havok file format (Phive) used for NavMesh
