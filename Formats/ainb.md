# AINB

AINB (**A**rtificial **I**ntelligence **N**ode **B**inary) is a binary file format for AI parameters used in _Tears of the Kingdom_ (as well as a handful of other Nintendo EPD games). This document is primarily aimed at the version that appears in _Tears of the Kingdom_ (0x407). They are located in the AI, Logic, and Sequence folders of the romfs. Additionally, AINB files appear in AI folders in the actor packs.

# Structure

AINB is a little endian format similar to most Switch file formats. The file contains a series of interconnected notes and even references to other AINB files. When a command from the file is run, it pushes the corresponding root node onto a run array, adding that node’s linked child nodes and updating each one in order as it iterates through the array.

Name offsets are relative to the start of the string pool. Name hashes are 32-bit Murmur3 hashes. There are six data types referenced in the file: int, bool, float, string, vector3f, and user-defined type. When parameters are listed or referenced, they always come in this order. User-defined types do not have value definitions unlike the other types and values written to them are pointers to the corresponding object.

# Section Order



1. [0x74-Byte File Header](#Header)
2. [Commands](#Commands)
3. [Nodes](#Nodes)
4. [Global Parameter Section](#Global-Parameters)
5. [Node Body](#Node-Body)
6. [Attachments Section](#Attachments)
7. [Immediate Parameters](#Immediate-Parameters)
8. [Input/Output Parameters](#Input/Output-Parameters)
9. [Multi-Parameters Array Section](#Multi-Parameters)
10. [Resident Update Array](#Resident-Update-Array)
11. [0x50 Section (Unused in TotK)](#0x50-Section)
12. [Precondition Nodes Section](#Precondition-Nodes)
13. [EXB/Functions Section](#EXB)
14. [Embedded AINB Files Section](#Embedded-AINB)
15. [Entry Strings Section](#Entry-Strings)
16. [File Hashes](#File-Hashes)
17. [Child Replacement Table](#Child-Replacement-Table)
18. [0x6C Section](#0x6C-Section)
19. [Resolve Array](#Resolve-Array)
20. [String Pool](#String-Pool)

# Sections

## Header

All AINB files begin with a 0x74 byte header structured as follows (note: if a section offset is 0, that section does not exist):


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>char[4]
   </td>
   <td>Magic - “AIB “
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Version (0x407 in TotK, 0x404 in S3 and NSS)
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Filename Offset
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Command Count
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Node Count
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>Precondition Node Count
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u32
   </td>
   <td>Attachment Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>u32
   </td>
   <td>Output Node Count
   </td>
  </tr>
  <tr>
   <td>0x20
   </td>
   <td>u32
   </td>
   <td>Global Parameter Offset
   </td>
  </tr>
  <tr>
   <td>0x24
   </td>
   <td>u32
   </td>
   <td>String Pool Offset
   </td>
  </tr>
  <tr>
   <td>0x28
   </td>
   <td>u32
   </td>
   <td>Resolve Array Offset
   </td>
  </tr>
  <tr>
   <td>0x2C
   </td>
   <td>u32
   </td>
   <td>Immediate Parameters Offset
   </td>
  </tr>
  <tr>
   <td>0x30
   </td>
   <td>u32
   </td>
   <td>Resident Update Array Offset
   </td>
  </tr>
  <tr>
   <td>0x34
   </td>
   <td>u32
   </td>
   <td>Input/Output Parameters Offset
   </td>
  </tr>
  <tr>
   <td>0x38
   </td>
   <td>u32
   </td>
   <td>Multi-Parameters Array Offset
   </td>
  </tr>
  <tr>
   <td>0x3C
   </td>
   <td>u32
   </td>
   <td>Attachment Parameters Offset
   </td>
  </tr>
  <tr>
   <td>0x40
   </td>
   <td>u32
   </td>
   <td>Attachment Parameters Index List Offset
   </td>
  </tr>
  <tr>
   <td>0x44
   </td>
   <td>u32
   </td>
   <td>EXB Section Offset (Functions Offset)
   </td>
  </tr>
  <tr>
   <td>0x48
   </td>
   <td>u32
   </td>
   <td>Child Replacement Table Offset
   </td>
  </tr>
  <tr>
   <td>0x4C
   </td>
   <td>u32
   </td>
   <td>Precondition Node Array Offset
   </td>
  </tr>
  <tr>
   <td>0x50
   </td>
   <td>u32
   </td>
   <td>Unknown (unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x54
   </td>
   <td>u32
   </td>
   <td>Unknown (always 0)
   </td>
  </tr>
  <tr>
   <td>0x58
   </td>
   <td>u32
   </td>
   <td>Unknown (always 0, used in <em>Splatoon 3</em>/<em>Nintendo Switch Sports</em>)
   </td>
  </tr>
  <tr>
   <td>0x5C
   </td>
   <td>u32
   </td>
   <td>Embedded AINB Files Offset
   </td>
  </tr>
  <tr>
   <td>0x60
   </td>
   <td>u32
   </td>
   <td>File Category Name Offset
   </td>
  </tr>
  <tr>
   <td>0x64
   </td>
   <td>u32
   </td>
   <td>File Category (0 = AI, 1 = Logic, 2 = Sequence) - only TotK
   </td>
  </tr>
  <tr>
   <td>0x68
   </td>
   <td>u32
   </td>
   <td>Entry Strings Offset (purpose unknown)
   </td>
  </tr>
  <tr>
   <td>0x6C
   </td>
   <td>u32
   </td>
   <td>Unknown (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x70
   </td>
   <td>u32
   </td>
   <td>File Identification Hashes Offset (Purpose Unknown)
   </td>
  </tr>
</table>


# Commands

This section is a list of commands with entries as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td rowspan="5" >0x04
   </td>
   <td>u32
   </td>
   <td rowspan="5" >Global Unique Identifier
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u8[6]
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u16
   </td>
   <td>Left Node Index
   </td>
  </tr>
  <tr>
   <td>0x16
   </td>
   <td>u16
   </td>
   <td>Right Node Index (one greater than the corresponding node index)
   </td>
  </tr>
</table>


The node index is the index of the root node connected directly to the command. GUIDs are only used for debugging messages and have no effect in-game.

## Nodes

This section is a list of file nodes with entries as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u16
   </td>
   <td>Node Type
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u16
   </td>
   <td>Node Index
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u16
   </td>
   <td>Attachment Parameters Count
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>bitfield
   </td>
   <td>Node Flags
   </td>
  </tr>
  <tr>
   <td>0x07
   </td>
   <td>u8
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Name Hash (version 0x407 only)
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>Node Body Offset
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u16
   </td>
   <td>EXB Function Count
   </td>
  </tr>
  <tr>
   <td>0x1A
   </td>
   <td>u16
   </td>
   <td>EXB Input/Output Field Size
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>u16
   </td>
   <td>Multi-Param Count
   </td>
  </tr>
  <tr>
   <td>0x1E
   </td>
   <td>u16
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x20
   </td>
   <td>u32
   </td>
   <td>Base Attachment Parameter Index
   </td>
  </tr>
  <tr>
   <td>0x24
   </td>
   <td>u16
   </td>
   <td>Base Precondition Node
   </td>
  </tr>
  <tr>
   <td>0x26
   </td>
   <td>u16
   </td>
   <td>Precondition Node Count
   </td>
  </tr>
  <tr>
   <td>0x28
   </td>
   <td>u16
   </td>
   <td>0x58 Section Entry Address (Purpose Unknown)
   </td>
  </tr>
  <tr>
   <td>0x2A
   </td>
   <td>u16
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td rowspan="5" >0x2C
   </td>
   <td>u32
   </td>
   <td rowspan="5" >Global Unique Identifier
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u16
   </td>
  </tr>
  <tr>
   <td>u8[6]
   </td>
  </tr>
</table>


GUIDs are only used for debugging messages and have no effect in-game.

The node types are as follows:


<table>
  <tr>
   <td><strong>Value (Hex)</strong>
   </td>
   <td><strong>Value (Dec)</strong>
   </td>
   <td><strong>Type</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>0
   </td>
   <td>UserDefined
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>1
   </td>
   <td>Element_S32Selector
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>2
   </td>
   <td>Element_Sequential
   </td>
  </tr>
  <tr>
   <td>0x03
   </td>
   <td>3
   </td>
   <td>Element_Simultaneous
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>4
   </td>
   <td>Element_F32Selector
   </td>
  </tr>
  <tr>
   <td>0x05
   </td>
   <td>5
   </td>
   <td>Element_StringSelector
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>6
   </td>
   <td>Element_RandomSelector
   </td>
  </tr>
  <tr>
   <td>0x07
   </td>
   <td>7
   </td>
   <td>Element_BoolSelector
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>8
   </td>
   <td>Element_Fork (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x09
   </td>
   <td>9
   </td>
   <td>Element_Join (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x0A
   </td>
   <td>10
   </td>
   <td>Element_Alert
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>20
   </td>
   <td>Element_Expression
   </td>
  </tr>
  <tr>
   <td>0x64
   </td>
   <td>100
   </td>
   <td>Element_ModuleIF_Input_S32
   </td>
  </tr>
  <tr>
   <td>0x65
   </td>
   <td>101
   </td>
   <td>Element_ModuleIF_Input_F32
   </td>
  </tr>
  <tr>
   <td>0x66
   </td>
   <td>102
   </td>
   <td>Element_ModuleIF_Input_Vec3f
   </td>
  </tr>
  <tr>
   <td>0x67
   </td>
   <td>103
   </td>
   <td>Element_ModuleIF_Input_String
   </td>
  </tr>
  <tr>
   <td>0x68
   </td>
   <td>104
   </td>
   <td>Element_ModuleIF_Input_Bool
   </td>
  </tr>
  <tr>
   <td>0x69
   </td>
   <td>105
   </td>
   <td>Element_ModuleIF_Input_Ptr
   </td>
  </tr>
  <tr>
   <td>0xC8
   </td>
   <td>200
   </td>
   <td>Element_ModuleIF_Output_S32
   </td>
  </tr>
  <tr>
   <td>0xC9
   </td>
   <td>201
   </td>
   <td>Element_ModuleIF_Output_F32
   </td>
  </tr>
  <tr>
   <td>0xCA
   </td>
   <td>202
   </td>
   <td>Element_ModuleIF_Output_Vec3f
   </td>
  </tr>
  <tr>
   <td>0xCB
   </td>
   <td>203
   </td>
   <td>Element_ModuleIF_Output_String
   </td>
  </tr>
  <tr>
   <td>0xCC
   </td>
   <td>204
   </td>
   <td>Element_ModuleIF_Output_Bool
   </td>
  </tr>
  <tr>
   <td>0xCD
   </td>
   <td>205
   </td>
   <td>Element_ModuleIF_Output_Ptr
   </td>
  </tr>
  <tr>
   <td>0x012C
   </td>
   <td>300
   </td>
   <td>Element_ModuleIF_Child
   </td>
  </tr>
  <tr>
   <td>0x0190
   </td>
   <td>400
   </td>
   <td>Element_StateEnd
   </td>
  </tr>
  <tr>
   <td>0x01F4
   </td>
   <td>500
   </td>
   <td>Element_SplitTiming
   </td>
  </tr>
</table>


For UserDefined nodes, node definitions can be found in a node definitions file. This file is located at NodeDefinition/Node.Product.[ver].aidefn.byml.zs in the corresponding file category folder. Other nodes are defined as follows:


<table>
  <tr>
   <td><strong>Type</strong>
   </td>
   <td><strong>Notes</strong>
   </td>
  </tr>
  <tr>
   <td>UserDefined
   </td>
   <td>Custom node type, definition in NodeDefinition
   </td>
  </tr>
  <tr>
   <td>Element_S32Selector
   </td>
   <td>Conditionally links to a node depending on the value of a signed int
   </td>
  </tr>
  <tr>
   <td>Element_Sequential
   </td>
   <td>Links to nodes sequentially in the order listed
   </td>
  </tr>
  <tr>
   <td>Element_Simultaneous
   </td>
   <td>Links simultaneously to multiple nodes
   </td>
  </tr>
  <tr>
   <td>Element_F32Selector
   </td>
   <td>Conditionally links to a node depending on the value of 32-bit float
   </td>
  </tr>
  <tr>
   <td>Element_StringSelector
   </td>
   <td>Conditionally links to a node depending on the value of a string
   </td>
  </tr>
  <tr>
   <td>Element_RandomSelector
   </td>
   <td>Links to a node randomly
   </td>
  </tr>
  <tr>
   <td>Element_BoolSelector
   </td>
   <td>Conditionally links to a node depending on the value of a bool
   </td>
  </tr>
  <tr>
   <td>Element_Fork (Unused in TotK)
   </td>
   <td>See <a href="#bookmark=id.da0axw3ub1bz">Resident Update Array</a>
   </td>
  </tr>
  <tr>
   <td>Element_Join (Unused in TotK)
   </td>
   <td>See <a href="#bookmark=id.da0axw3ub1bz">Resident Update Array</a>
   </td>
  </tr>
  <tr>
   <td>Element_Alert
   </td>
   <td>Displays a debug message
   </td>
  </tr>
  <tr>
   <td>Element_Expression
   </td>
   <td>Passes values to and from EXB commands
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_S32
   </td>
   <td>Passes a signed int as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_F32
   </td>
   <td>Passes a 32-bit float as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_Vec3f
   </td>
   <td>Passes a vector3f as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_String
   </td>
   <td>Passes a string as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_Bool
   </td>
   <td>Passes a boolean int as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Input_Ptr
   </td>
   <td>Passes a pointer to a user-defined type as output to another node as input
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_S32
   </td>
   <td>Passes a signed int as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_F32
   </td>
   <td>Passes a 32-bit float as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_Vec3f
   </td>
   <td>Passes a vector3f as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_String
   </td>
   <td>Passes a string as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_Bool
   </td>
   <td>Passes a boolean int as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Output_Ptr
   </td>
   <td>Passes a pointer to a user-defined type as output to another node as output
   </td>
  </tr>
  <tr>
   <td>Element_ModuleIF_Child
   </td>
   <td>Unsure, appears to just be a node connected to a ModuleIF node as a child node
   </td>
  </tr>
  <tr>
   <td>Element_StateEnd
   </td>
   <td>Termination node
   </td>
  </tr>
  <tr>
   <td>Element_SplitTiming
   </td>
   <td>Changes when child nodes are run (Enter - first time visiting a node, Update - every frame, Leave - ran upon leaving the node)
   </td>
  </tr>
</table>


The node flag bit field is mapped as follows:


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Precondition Node
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is External AINB File
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Resident Node
   </td>
  </tr>
  <tr>
   <td>5
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


## Global Parameters

The global parameters section contains a list of parameters, many of which are from source files referenced later in the section. The section begins with a 0x30 byte header with one entry per data type (six entries total). The header section is followed by a list of parameters, a list of the default values of those parameters, and then a list of source file references. Note that the type order is different in this section: string, int, float, bool, vector3f, and user-defined. The structure of the header entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u16
   </td>
   <td>Number of Entries of the Corresponding Data Type
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u16
   </td>
   <td>Parameter Index of the First Entry of the Corresponding Data Type
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u16
   </td>
   <td>Relative Offset of the First Entry of the Corresponding Data Type
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>u16
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


The structure of the parameter entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>bitfield
   </td>
   <td>Name Offset and Flags
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>String Offset (Notes)
   </td>
  </tr>
</table>


The name offset and flags bit field is mapped as follows:


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>22
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Does Not Have File Reference
   </td>
  </tr>
  <tr>
   <td>7
   </td>
   <td>File Reference Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is File Reference Valid
   </td>
  </tr>
</table>


Entries in the parameter value list vary based on the data type. int, float, and string entries take up four bytes each. bool entries take up one byte and vector3f entries take up 12 bytes (four bytes for each of the x, y, and z values). Parameters of user-defined types do not store default values. The structure of the file references is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Name Hash
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Unknown (possibly another hash)
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Unknown (possibly another hash)
   </td>
  </tr>
</table>


## Node Body

The node body section is made up of two parts: a 0x90-byte parameter section and a 0x14 child node header. The child node header contains information about each of the 10 child node types  that are linked to that node. The structure of the node body is as follows (base index is into the parameter array for that specific data type):


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Int Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Int Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Bool Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Bool Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Float Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>Float Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u32
   </td>
   <td>String Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>u32
   </td>
   <td>String Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x20
   </td>
   <td>u32
   </td>
   <td>Vector3f Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x24
   </td>
   <td>u32
   </td>
   <td>Vector3f Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x28
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x2C
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x30
   </td>
   <td>u32
   </td>
   <td>Int Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x34
   </td>
   <td>u32
   </td>
   <td>Int Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x38
   </td>
   <td>u32
   </td>
   <td>Int Output Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x3C
   </td>
   <td>u32
   </td>
   <td>Int Output Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x40
   </td>
   <td>u32
   </td>
   <td>Bool Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x44
   </td>
   <td>u32
   </td>
   <td>Bool Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x48
   </td>
   <td>u32
   </td>
   <td>Bool Output Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x4C
   </td>
   <td>u32
   </td>
   <td>Bool Output Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x50
   </td>
   <td>u32
   </td>
   <td>Float Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x54
   </td>
   <td>u32
   </td>
   <td>Float Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x58
   </td>
   <td>u32
   </td>
   <td>Float Output Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x5C
   </td>
   <td>u32
   </td>
   <td>Float Output Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x60
   </td>
   <td>u32
   </td>
   <td>String Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x64
   </td>
   <td>u32
   </td>
   <td>String Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x68
   </td>
   <td>u32
   </td>
   <td>String Output Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x6C
   </td>
   <td>u32
   </td>
   <td>String Output Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x70
   </td>
   <td>u32
   </td>
   <td>Vector3f Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x74
   </td>
   <td>u32
   </td>
   <td>Vector3f Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x78
   </td>
   <td>u32
   </td>
   <td>Vector3f Output Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x7C
   </td>
   <td>u32
   </td>
   <td>Vector3f Output Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x80
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Input Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x84
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Input Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x88
   </td>
   <td>u32
   </td>
   <td>User-Defined TypeOutput Reference Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x8C
   </td>
   <td>u32
   </td>
   <td>User-Defined TypeOutput Reference Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x90
   </td>
   <td>u8
   </td>
   <td>Bool/float Input Source Node/Output Source Node Count
   </td>
  </tr>
  <tr>
   <td>0x91
   </td>
   <td>u8
   </td>
   <td>Bool/float Input Source Node/Output Source Node Base Index
   </td>
  </tr>
  <tr>
   <td>0x92
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Count (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x93
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Base Index (Unused TotK)
   </td>
  </tr>
  <tr>
   <td>0x94
   </td>
   <td>u8
   </td>
   <td>Standard Child Node Count
   </td>
  </tr>
  <tr>
   <td>0x95
   </td>
   <td>u8
   </td>
   <td>Standard Child Node Base Index
   </td>
  </tr>
  <tr>
   <td>0x96
   </td>
   <td>u8
   </td>
   <td>Resident Update Node Count
   </td>
  </tr>
  <tr>
   <td>0x97
   </td>
   <td>u8
   </td>
   <td>Resident Update Base Index
   </td>
  </tr>
  <tr>
   <td>0x98
   </td>
   <td>u8
   </td>
   <td>String Input Source Node Count
   </td>
  </tr>
  <tr>
   <td>0x99
   </td>
   <td>u8
   </td>
   <td>String Input Source Node Base Index
   </td>
  </tr>
  <tr>
   <td>0x9A
   </td>
   <td>u8
   </td>
   <td>Int Input Source Node Count
   </td>
  </tr>
  <tr>
   <td>0x9B
   </td>
   <td>u8
   </td>
   <td>Int Input Source Node Base Index
   </td>
  </tr>
  <tr>
   <td>0x9C
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Count (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x9D
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Base Index (Unused TotK)
   </td>
  </tr>
  <tr>
   <td>0x9E
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Count (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0x9F
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Base Index (Unused TotK)
   </td>
  </tr>
  <tr>
   <td>0xA0
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Count (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0xA1
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Base Index (Unused TotK)
   </td>
  </tr>
  <tr>
   <td>0xA2
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Count (Unused in TotK)
   </td>
  </tr>
  <tr>
   <td>0xA3
   </td>
   <td>u8
   </td>
   <td>Unknown Connection Type Base Index (Unused TotK)
   </td>
  </tr>
</table>


The child nodes section is a list of the addresses of each entry followed by the array of entries. Each entry is eight bytes and contains a node index and a value. The interpretation of the value depends on the specific connection type. For input/output sources, the value is a string reference for the relevant parameter. For standard connections, this value is also a string reference for the connection. For resident update nodes, this value is the index of the node entry in the resident update array. The other connection types are unused in TotK and poorly understood. The length of each entry can also be extended for selector nodes to store the condition under which it will connect to each child node. Bool selectors store their condition in the normal value position, but other selectors add an eight-byte entry (four eight-byte entries in the case of F32Selector) to store the condition value while changing the string reference to a null string. Note the last two entries for F32Selector appear to be unused in TotK. Input nodes to nodes that are selectors will also have an extra eight bytes (purpose unknown). Element_Expression nodes have an additional eight bytes per input node as well as an additional 16 bytes for vector3f entries (purpose of these bytes is unknown). The structure of each entry is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Global Parameter Index + Flags
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Condition Check Value
   </td>
  </tr>
</table>


The first two bytes of the global parameter index + flags are the global parameter index while the last bit is whether or not the index is valid and used. The first entry for F32Selector is the minimum value while the second entry is the maximum value of the conditional range for that child node. Note that the last listed child node represents the default node and the stored check value will instead be a string list reference to その他 (other) for F32Selector and StringSelector nodes. The value for S32Selector nodes is 0.

## Attachments

The attachment parameters section contains entries for certain parameters (predominantly LookIKControllerArbiter-related parameters) which have many sub-parameters and serve as “attachments” to nodes. This section begins with an index array that is a list of four-byte indices into the main attachment parameters section. It is the section that nodes will reference when they need to reference an attachment parameter. It appears to have a four-byte index entry for every parameter entry in the section. This section is followed by a parameter entries section and then a list of the sub-parameters for each parameter. Each entry is structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Sub-Parameters Entry Offset
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u16
   </td>
   <td>EXB Function Count
   </td>
  </tr>
  <tr>
   <td>0x0A
   </td>
   <td>u16
   </td>
   <td>EXB Input/Output Field Size
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Name Hash (version 0x407 only)
   </td>
  </tr>
</table>


The structure of the sub-parameters entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Unknown (possibly related to debug)
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>int Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>int Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>bool Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>bool Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>float Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u32
   </td>
   <td>float Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>u32
   </td>
   <td>string Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x20
   </td>
   <td>u32
   </td>
   <td>string Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x24
   </td>
   <td>u32
   </td>
   <td>vector3f Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x28
   </td>
   <td>u32
   </td>
   <td>vector3f Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x2C
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Immediate Parameter Base Index
   </td>
  </tr>
  <tr>
   <td>0x30
   </td>
   <td>u32
   </td>
   <td>User-Defined Type Immediate Parameter Count
   </td>
  </tr>
  <tr>
   <td>0x34
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x38
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
  <tr>
   <td>0x3C
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x40
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
  <tr>
   <td>0x44
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x48
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
  <tr>
   <td>0x4C
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x50
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
  <tr>
   <td>0x54
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x58
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
  <tr>
   <td>0x5C
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x60
   </td>
   <td>u32
   </td>
   <td>Unknown (contains address to next entry)
   </td>
  </tr>
</table>


## Immediate Parameters

The immediate parameters section is composed of a 24-byte header followed by an array of immediate parameters. The header is composed of six four-byte entries, one for each data type. Each entry contains the offset to the first parameter entry for that data type. The structure of the entries in the array of parameters varies based on the data type. The structure of the int, bool, float, and string entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>s32
   </td>
   <td>Value (u32 string offset for string entries)
   </td>
  </tr>
</table>


The structure of vector3f entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>X Value
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Y Value
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Z Value
   </td>
  </tr>
</table>


The structure of user-defined type entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Class Name Offset
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
</table>


The parameter flags are mapped as follows:


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>16
   </td>
   <td>Global/EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Use Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Not Global Parameters Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Pulse Thread Local Storage
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Set Pointer Flag Bit Zero
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


## Input/Output Parameters

This section is structured similarly to the immediate parameters section. It begins with a 48-byte header split into 12 four-byte sections (two for each data type in the order of input followed by output). That is to say, the order is int input, int output, bool input, bool output, etc. The entries in this header are identical to the ones in the immediate parameters header. Similarly, this header is followed by an array of the parameters. The entries once again vary both on the data type and the parameter type (input or output). Input parameter entries for int, bool, float, and string entries is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>s16
   </td>
   <td>Input Child Node Index / Multi-Parameter Array Base Index
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>s16
   </td>
   <td>Input/Output Source Node Index
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>s32
   </td>
   <td>Default Value (u32 string reference for string)
   </td>
  </tr>
</table>


The entries for vector3f parameters is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>s16
   </td>
   <td>Input Child Node Index / Multi-Parameter Array Base Index
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>s16
   </td>
   <td>Input/Output Source Parameter Index
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Default X Value
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Default Y Value
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>Default Z Value
   </td>
  </tr>
</table>


The entries for parameters of a user-defined type are as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Class Name Offset
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>s16
   </td>
   <td>Input Child Node Index / Multi-Parameter Array Base Index
   </td>
  </tr>
  <tr>
   <td>0x0A
   </td>
   <td>s16
   </td>
   <td>Input/Output Source Parameter Index
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


The parameter flags are mapped as follows (identical to flags for immediate parameters):


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>16
   </td>
   <td>Global/EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Use Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Not Global Parameters Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Pulse Thread Local Storage
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Set Pointer Flag Bit Zero
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


Output parameter entries are mapped as follows:


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>31
   </td>
   <td>Name Offset
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Set Pointer Flag Bit Zero
   </td>
  </tr>
</table>


User-Defined Type entries also have an additional four bytes to store the class name offset.

## Multi Parameters

This section is composed of eight-byte entries for node input parameters that require multiple values. These values are referenced by the child node index of input parameter entries where the entry index is equal to the absolute value of -100 - the child node index. The structure of each entry is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u16
   </td>
   <td>Node Index
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u16
   </td>
   <td>Input/Output Source Node Index
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Flags
   </td>
  </tr>
</table>


The parameter flags are mapped as follows (identical to the immediate/input parameter flags):


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>16
   </td>
   <td>Global/EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Use Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is Not Global Parameters Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Is EXB Index
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Pulse Thread Local Storage
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Set Pointer Flag Bit Zero
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>2
   </td>
   <td>Unknown
   </td>
  </tr>
</table>


## Resident Update Array

The resident update array is an array of entries for resident nodes that are updated mid-node update sequence. When a node has a child resident update node, it’ll schedule the resident node’s update. The section begins with a list of four-byte offsets for the entries in the section. Each entry is four bytes for flags. The flags are mapped as follows:


<table>
  <tr>
   <td><strong>Bits</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>8
   </td>
   <td>Is Valid Update
   </td>
  </tr>
  <tr>
   <td>23
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>1
   </td>
   <td>Update Post Current Command Calculation
   </td>
  </tr>
</table>


If the first byte of the flags is set to false, then the entry contains another four bytes with a string offset (purpose unknown). By default, the node is scheduled to update pre-next command calculation, however, this can change depending on the flags set. Additionally, Fork and Join nodes behave differently. Fork nodes will append the node to the run array while Join nodes will update the node post-current command calculation. [add more later]

## 0x50 Section

(Unused in TotK, used in 0x404)

## Precondition Nodes

This section contains node indices to precondition nodes that run before the referring node does. Each entry in this section is four bytes, with the first two bytes being the node index and the next two’s purpose being unknown.

## EXB

The EXB section is essentially a self-contained file within a file - all references within this section are local with the exception to references to memory. It is believed EXB stands for **EX**pression **B**inary. This section is shared with .asb (**A**nimation **S**equence **B**inary) files and contains functions that modify various node parameters. The file begins with a 0x30 byte header structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>char[4]
   </td>
   <td>Magic - “EXB “
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Version (0x02)
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Static Memory Allocation Size
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Parameter EXB Field Entry Count
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>32-bit Scratch Allocation Size
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u32
   </td>
   <td>64-bit Scratch Allocation Size
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u32
   </td>
   <td>Command Info Offset
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>u32
   </td>
   <td>Command Table Offset
   </td>
  </tr>
  <tr>
   <td>0x20
   </td>
   <td>u32
   </td>
   <td>Signature Table Offset
   </td>
  </tr>
  <tr>
   <td>0x24
   </td>
   <td>u32
   </td>
   <td>Parameter Region Offset
   </td>
  </tr>
  <tr>
   <td>0x28
   </td>
   <td>u32
   </td>
   <td>String Pool Offset
   </td>
  </tr>
</table>


The header is followed immediately by the command info table which contains information about a specific function in the command table. The first four bytes of the command info table specify the number of entries. The structure of each entry is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>s32
   </td>
   <td>Base Index Pre-Command Entry
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Pre-Entry Static Memory Usage
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Instruction Base Index
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>u32
   </td>
   <td>Instruction Count
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>u32
   </td>
   <td>Static Memory Size
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>u16
   </td>
   <td>32-bit Scratch Memory Size
   </td>
  </tr>
  <tr>
   <td>0x16
   </td>
   <td>u16
   </td>
   <td>64-bit Scratch Memory Size
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>u16
   </td>
   <td>Output Data Type Enum
   </td>
  </tr>
  <tr>
   <td>0x1A
   </td>
   <td>u16
   </td>
   <td>Input Data Type Enum
   </td>
  </tr>
</table>


The data type enum in the command info entries appears to be different from the one used in the command table.

The next section is the command table which is an array of simple instructions, reminiscent of assembly instructions. The first four bytes of this section are the instruction count which is followed by the array of instructions. Each instruction is eight bytes and is structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u8
   </td>
   <td>Instruction Type
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>u8
   </td>
   <td>Data Type Enum
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u8
   </td>
   <td>Left-Hand Side Parameter Source Enum
   </td>
  </tr>
  <tr>
   <td>0x03
   </td>
   <td>u8
   </td>
   <td>Right-Hand Side Parameter Source Enum
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u16
   </td>
   <td>Left-Hand Side Parameter
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>u16
   </td>
   <td>Right-Hand Side Parameter
   </td>
  </tr>
</table>


For UserDefined functions, bytes 0x02-0x04 become a u16 static memory index and 0x04-0x08 become an EXB string pool index. For Jump and JumpIfLHSZero, there is no data type enum value.

The command types are as follows:


<table>
  <tr>
   <td><strong>Value (Hex)</strong>
   </td>
   <td><strong>Value (Dec)</strong>
   </td>
   <td><strong>Type</strong>
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>1
   </td>
   <td>Terminator
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>2
   </td>
   <td>Store
   </td>
  </tr>
  <tr>
   <td>0x03
   </td>
   <td>3
   </td>
   <td>Negate
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>4
   </td>
   <td>NegateBool
   </td>
  </tr>
  <tr>
   <td>0x05
   </td>
   <td>5
   </td>
   <td>Add
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>6
   </td>
   <td>Subtract
   </td>
  </tr>
  <tr>
   <td>0x07
   </td>
   <td>7
   </td>
   <td>Multiply
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>8
   </td>
   <td>Divide
   </td>
  </tr>
  <tr>
   <td>0x09
   </td>
   <td>9
   </td>
   <td>Modulus
   </td>
  </tr>
  <tr>
   <td>0x0A
   </td>
   <td>10
   </td>
   <td>Increment
   </td>
  </tr>
  <tr>
   <td>0x0B
   </td>
   <td>11
   </td>
   <td>Decrement
   </td>
  </tr>
  <tr>
   <td>0x0C
   </td>
   <td>12
   </td>
   <td>ScalarMultiplyVec3f
   </td>
  </tr>
  <tr>
   <td>0x0D
   </td>
   <td>13
   </td>
   <td>ScalarDivideVec3f
   </td>
  </tr>
  <tr>
   <td>0x0E
   </td>
   <td>14
   </td>
   <td>LeftShift
   </td>
  </tr>
  <tr>
   <td>0x0F
   </td>
   <td>15
   </td>
   <td>RightShift
   </td>
  </tr>
  <tr>
   <td>0x10
   </td>
   <td>16
   </td>
   <td>LessThan
   </td>
  </tr>
  <tr>
   <td>0x11
   </td>
   <td>17
   </td>
   <td>LessThanEqual
   </td>
  </tr>
  <tr>
   <td>0x12
   </td>
   <td>18
   </td>
   <td>GreaterThan
   </td>
  </tr>
  <tr>
   <td>0x13
   </td>
   <td>19
   </td>
   <td>GreaterThanEqual
   </td>
  </tr>
  <tr>
   <td>0x14
   </td>
   <td>20
   </td>
   <td>Equal
   </td>
  </tr>
  <tr>
   <td>0x15
   </td>
   <td>21
   </td>
   <td>NotEqual
   </td>
  </tr>
  <tr>
   <td>0x16
   </td>
   <td>22
   </td>
   <td>AND
   </td>
  </tr>
  <tr>
   <td>0x17
   </td>
   <td>23
   </td>
   <td>XOR
   </td>
  </tr>
  <tr>
   <td>0x18
   </td>
   <td>24
   </td>
   <td>OR
   </td>
  </tr>
  <tr>
   <td>0x19
   </td>
   <td>25
   </td>
   <td>LogicalAND
   </td>
  </tr>
  <tr>
   <td>0x1A
   </td>
   <td>26
   </td>
   <td>LogicalOR
   </td>
  </tr>
  <tr>
   <td>0x1B
   </td>
   <td>27
   </td>
   <td>UserFunction
   </td>
  </tr>
  <tr>
   <td>0x1C
   </td>
   <td>28
   </td>
   <td>JumpIfLHSZero
   </td>
  </tr>
  <tr>
   <td>0x1D
   </td>
   <td>29
   </td>
   <td>Jump
   </td>
  </tr>
</table>


UserFunctions are defined in the executable and are matched using the function signature and an index set at runtime. There are two types of these functions: direct and object. Direct functions are straightforward functions that take up to two arguments and are matched using the function signature. Function objects can take additional arguments and are indexed at runtime.

The data type enums are as follows:


<table>
  <tr>
   <td><strong>Value (Hex)</strong>
   </td>
   <td><strong>Value (Dec)</strong>
   </td>
   <td><strong>Type</strong>
   </td>
  </tr>
  <tr>
   <td>0x0
   </td>
   <td>0
   </td>
   <td>No Data
   </td>
  </tr>
  <tr>
   <td>0x1
   </td>
   <td>1
   </td>
   <td>Immediate Value/From User
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>2
   </td>
   <td>bool
   </td>
  </tr>
  <tr>
   <td>0x03
   </td>
   <td>3
   </td>
   <td>int
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>4
   </td>
   <td>float
   </td>
  </tr>
  <tr>
   <td>0x05
   </td>
   <td>5
   </td>
   <td>string
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>6
   </td>
   <td>vector3f
   </td>
  </tr>
</table>


The parameter source enums are as follows:


<table>
  <tr>
   <td><strong>Value (Hex)</strong>
   </td>
   <td><strong>Value (Dec)</strong>
   </td>
   <td><strong>Type</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>0
   </td>
   <td>Immediate Parameters
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>1
   </td>
   <td>Immediate Parameters (String)
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>2
   </td>
   <td>Static Memory
   </td>
  </tr>
  <tr>
   <td>0x03
   </td>
   <td>3
   </td>
   <td>Parameters Region
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>4
   </td>
   <td>Parameters Region (String)
   </td>
  </tr>
  <tr>
   <td>0x05
   </td>
   <td>5
   </td>
   <td>Output Value
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>6
   </td>
   <td>Input Value
   </td>
  </tr>
  <tr>
   <td>0x07
   </td>
   <td>7
   </td>
   <td>32-bit Scratch
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>8
   </td>
   <td>64-bit Scratch
   </td>
  </tr>
  <tr>
   <td>0x09
   </td>
   <td>9
   </td>
   <td>UserOutput
   </td>
  </tr>
  <tr>
   <td>0x0A
   </td>
   <td>10
   </td>
   <td>UserInput
   </td>
  </tr>
</table>


UserCallback is a class that contains virtual functions providing memory allocation.

Following the command table is the function signatures section. The first four bytes of the section are the number of signatures present in the string pool. Following this is a list of four byte offsets to each of the signatures in the pool relative to the start of the string pool. After the offsets is the parameter region which is used as a parameter source for commands. Finally, the section ends with the string pool which is an array of null-terminated strings for each function signature and other strings used in the section. These signatures are used to match UserDefined commands with the corresponding function (found in the main executable).

## Embedded AINB

This section contains a list of AINB files referenced by various nodes and starts with four bytes that contain the number of entries. This is followed by the entries which are structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>File Path String Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>File Category Offset
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>AINB File Count
   </td>
  </tr>
</table>


## Entry Strings

The purpose of this section is unknown. It appears to detail possible entry point states for different nodes. This section begins with four bytes which contain the number of entries in the section. This is followed by the entries which are structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Node Index
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>String 1 Offset (always “メインステート” [Main State])
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>String 2 Offset (state)
   </td>
  </tr>
</table>


## File Hashes

This section contains two hashes that appear to be unused (removing them has no effect in-game). The first hash seems to be some sort of file identification hash while the second hash is some sort of root file identification hash and is only used in _LocalModule files. The second hash for these files is always the first hash of another AINB file. These likely serve some sort of debug purpose.

## Child Replacement Table

This section replaces or removes specified child nodes or attachments when an AINB file is initialized. This section is generally used to toggle off debug features for release versions. It begins with an eight-byte header that is structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u8
   </td>
   <td>Is Replaced (0x00 but set at runtime)
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>u8
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u16
   </td>
   <td>Replacement Count
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>s16
   </td>
   <td>Override Node Count
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>s16
   </td>
   <td>Override Attachment Parameter Count
   </td>
  </tr>
</table>


The header is followed by a list of entries which are structured as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u8
   </td>
   <td>Type (0 = removes a child node, 1 = replaces a child node index, 2 = removes an attachment parameter)
   </td>
  </tr>
  <tr>
   <td>0x01
   </td>
   <td>u8
   </td>
   <td>Unknown
   </td>
  </tr>
  <tr>
   <td>0x02
   </td>
   <td>u16
   </td>
   <td>Node Index
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u16
   </td>
   <td>Depends, see below
   </td>
  </tr>
  <tr>
   <td>0x06
   </td>
   <td>u16
   </td>
   <td>Depends, see below
   </td>
  </tr>
</table>


If the replacement type is 0 or 1, 0x04 is the base index of the child node to remove/replace. If the replacement type is 2, 0x04 is the base index of the attachment parameter to remove. If the replacement type is 0 or 2, 0x06 is empty. If the replacement type is 1, 0x06 is the node index to replace the old index with.

## 0x6C Section

The structure and purpose of this section are unknown.

## Resolve Array

This section is unused in TotK but used extensively in games such as Splatoon 3 to resolve enum values at runtime. These values are not written to in TotK as they are already statically there. In games that do use this section, the section is used to write enum values to the specified offset. The first four bytes of this section are the entry count followed by a list of entries. The structure of each entry is as follows:


<table>
  <tr>
   <td><strong>Offset</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Value</strong>
   </td>
  </tr>
  <tr>
   <td>0x00
   </td>
   <td>u32
   </td>
   <td>Enum Value Offset
   </td>
  </tr>
  <tr>
   <td>0x04
   </td>
   <td>u32
   </td>
   <td>Enum Class Name Offset
   </td>
  </tr>
  <tr>
   <td>0x08
   </td>
   <td>u32
   </td>
   <td>Enum Value Name Offset
   </td>
  </tr>
</table>


## String Pool

The string pool is an array of null-terminated strings that are used in the file. References to the string pool are relative to the beginning of the string pool. Strings are encoded with UTF-8 and occasionally contain Japanese text.

# Notes



* _Splatoon 3_ has a few custom file categories and additional sections unused in _Tears of the Kingdom_ (purpose of these sections is unknown)

## Credits

Written by dt12345

Special thanks to Watertoon for their work labeling the relevant functions
