# TOTK Research

File research for Tears of the Kingdom

---

## .zs (Compression)

The compresion used for TOTK seems to be an modification of Facebooks [zStandard](http://facebook.github.io/zstd/) compression algorithm. Using an extension of [7-Zip](https://github.com/mcmilk/7-Zip-zstd/releases) I was able to see the an entry for the decompressed file, but it registers as a 0 byte file and can't be extracted.

![image](https://user-images.githubusercontent.com/80713508/235522067-ef258a58-7eed-4bf3-8d07-2e47d1879201.png)

## .bwav (Sound)

Most bwav file file seem to play fine in [foobar2000](https://www.foobar2000.org/) (with the [vgmStream](https://github.com/vgmstream/vgmstream) plugin), however some files (notably in the `Voice/Resource/XXcc/EventFlowMsg` folders) fail to play.

```
Unable to open item for playback (Unsupported format or corrupted file):
"F:\Games\Totk\Voice\Resource\USen\EventFlowMsg\Dm_BZ_0007_Stream\Dm_BZ_0007_Text_002_b.bwav"
```

## .bgyml (Params, BYML)

A lot of files seem to be just uncompressed BYML files, with the .bgyml extension. I haven't tried editing them yet, but I can read them with [Switch Toolbox](https://github.com/KillzXGaming/Switch-Toolbox) just fine.
