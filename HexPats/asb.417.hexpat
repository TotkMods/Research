// By dt12345

#pragma pattern_limit 5000000
#pragma eval_depth 256

u32 i = 0;
fn increment() {
    u32 original = i;
    i = i + 1;
    return original;
};

struct String {
    char string[];
};

struct Guid {
    u32 guid0;
    u16 guid1;
    u16 guid2;
    u16 guid3;
    u8 guid4[6];
};

struct Vector3f {
    float x;
    float y;
    float z;
};

struct ResTagEntry {
    u32 count;
    u32 name_offsets[count];
    
    i = 0;
    String tags[while(increment() < count)] @ header.string_pool_offset + name_offsets[i];
};

struct Type0Entry {
    u32 reserve0;
    float reserve1;
    u32 reserve2;
};

struct Type1Entry {
    u32 reserve0;
    float reserve1;
    u32 reserve2;
    float reserve3;
    float reserve4;
    float reserve5;
};

struct ResEntry38 {
    u32 type;
    u32 entry_offset;
    Guid guid;
    
    if (type == 0) {
        Type0Entry entry @ entry_offset;
    } else if (type == 1) {
        Type1Entry entry @ entry_offset;
    }
};

struct ResEntry40 {
    u32 reserve0;
    float reserve1;
    float reserve2;
    float reserve3;
    float reserve4;
    float reserve5;
    float reserve6;
    float reserve7;
};

struct ResEntry2c {
    u16 source_node_index;
    u16 node_index;
    u32 reserve0[23];
};

struct Res2c {
    u32 count;
    ResEntry2c entries[count];
};

struct Values {
    u32 value0;
    u32 value1;
};

struct ValueEntry {
    u32 count;
    u32 offset[count];
    
    i = 0;
    if (count > 0) {
        Values values[while(increment() < count)] @ offset[i] & 0xFFFFFF;
    }
};

struct TriggerEvent {
    u32 name_offset;
    u32 reserve0;
    u32 entry_offset;
    u32 reserve1;
    u32 reserve2;
    float start_frame;
    
    ValueEntry entry @ entry_offset;
};

struct HoldEvent {
    u32 name_offset;
    u32 reserve0;
    u32 entry_offset;
    u32 reserve1;
    u32 reserve2;
    float start_frame;
    float end_frame;
    
    ValueEntry entry @ entry_offset;
};

struct ResEventInfo {
    u32 trigger_count;
    u32 hold_count;
    
    TriggerEvent trigger_events[trigger_count];
    HoldEvent hold_events[hold_count];
};

struct ResEvent {
    u32 event_offset;
    
    ResEventInfo event @ event_offset;
};

struct ResTransitionEntry {
    u32 command_1_offset;
    u32 command_2_offset;
    u32 reserve0;
    u32 parameter_offset;
    u32 reserve1;
    
    char command_1[] @ header.string_pool_offset + command_1_offset;
    char command_2[] @ header.string_pool_offset + command_2_offset;
    char parameter[] @ header.string_pool_offset + parameter_offset;
    
    if (parameter == "__SLOT_SYNC_TARGET__") {
        u32 reserve2;
        u32 reserve3;
        u32 reserve4;
    } else if (parameter == "__INTERPOLATION_TYPE_AT_COMMAND_SET__") {
        u32 reserve3;
        u32 reserve4;
        u32 reserve5;
    } else if (parameter == "CommandUseIK") {
        u32 reserve2;
        u32 reserve3;
        u32 reserve4;
    } else {
        float reserve2;
        float reserve3;
        float reserve4;
    }
};

struct ResTransition {
    u32 transition_count;
    s32 reserve0;
    u32 entry_offset;
    
    ResTransitionEntry transitions[transition_count] @ entry_offset;
};

struct ResAsbTransitions {
    u32 count;
    u32 reserve0;
    
    ResTransition transitions[count];
};

struct Entry64 {
    u32 reserve0;
    u32 name_offset;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct Index64 {
    u32 offset;
    
    Entry64 entry @ offset;
};

struct Section64 {
    u32 count;
    
    Index64 entries[count];
};

struct Entry68 {
    u32 name_offset;
    u32 value;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct Section68 {
    u32 count;
    
    Entry68 entries[count];
};

struct Entry28 {
};

struct Section28 {
    u32 count;
    
    Entry28 entries[count];
};

struct Tag {
    u32 name_offset;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct ResTagList {
    u32 count;
    Tag tags[count];
};

struct StringTriplet {
    u32 name_offset_1;
    u32 name_offset_2;
    u32 name_offset_3;
    
    char parameter[] @ header.string_pool_offset + name_offset_1;
    char parameter_jp[] @ header.string_pool_offset + name_offset_2;
    char value[] @ header.string_pool_offset + name_offset_3;
};

struct ResStringTriplets {
    u32 count;
    
    StringTriplet triplets[count];
};

struct BoneEntry {
    u32 name_offset;
    float weight; // can be negative though so probably not
    
    char bone[] @ header.string_pool_offset + name_offset;
};

struct ResBoneGroup {
    u32 bone_list_offset;
    u32 mask_name_offset;
    u32 bone_count;
    u32 reserve0;
    
    char mask_name[] @ header.string_pool_offset + mask_name_offset;
    BoneEntry bones[bone_count] @ bone_list_offset;
};

struct ResBoneEntry {
    u32 name_offset;
    u16 reserve0;
    u16 reserve1;
    
    char bone_name[] @ header.string_pool_offset + name_offset;
};

struct ResAnimSlot {
    u16 count;
    u16 reserve0;
    
    u32 name_offset_1;
    u32 name_offset_2;
    
    ResBoneEntry bones[count];
    
    char name_1[] @ header.string_pool_offset + name_offset_1;
    char name_2[] @ header.string_pool_offset + name_offset_2;
};

struct ResAsbCommand {
    u32 name_offset;
    u32 tag_offset;
    u32 reserve0;
    float reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    Guid guid;
    u16 left_node_index;
    u16 right_node_idnex; // unsure

    char command_name[] @ header.string_pool_offset + name_offset;
    if (tag_offset != 0) {
        ResTagEntry tags @ tag_offset;
    }
};

struct x2cConnection {
    u32 x2c_index;
    
    ResEntry2c entry @ header.x2c_offset + 4 + 0x60 * x2c_index;
};

struct x2cOffset {
    u32 offset;
    
    x2cConnection x2c @ offset;
};

struct StandardConnection {
    u32 node_index;
};

struct StandardOffset {
    u32 offset;
    
    StandardConnection child_node @ offset;
};

struct FloatConnection {
    u32 reserve0;
    float min;
    u32 reserve1;
    float max;
    u32 node_index;
};

struct RandomConnection {
    u32 reserve0;
    float probability;
    u32 node_index;
};

struct BoolConnection {
    u32 node_index_true;
    u32 node_index_false;
};

struct IntConnection {
    u32 reserve0;
    u32 condition;
    u32 node_index;
};

struct StringConnection {
    u32 reserve0;
    u32 condition_offset;
    u32 node_index;
    
    char condition[] @ header.string_pool_offset + condition_offset;
};

struct TagConnection {
    s32 tag_offset;
    if (tag_offset != -1) {
        ResTagEntry tags @ tag_offset;
    }
    u32 node_index;
};

enum AsbBuiltInNodeType : u16 {
    FloatSelector           = 1,
    StringSelector           = 2,
    SkeletalAnimation     = 3,
    State                       = 4,
    Unknown1           = 5,
    OneDimensionalBlender = 6,
    Sequential                 = 7,
    IntSelector           = 8,
    Simultaneous          = 9,
    Event                 = 10,
    TextureAnimation        = 11,
    FrameController       = 12,
    DummyAnimation        = 13,
    RandomSelector        = 14,
    Unknown2            = 15,
    PreviousTagSelector   = 16,
    BonePositionSelector  = 17,
    BoneAnimation         = 18,
    InitialFrame          = 19,
    BoneBlender           = 20,
    BoolSelector          = 21,
    Message               = 22, // unsure, this is just a guess
    SubtractAnimation     = 23,
    Unknown6            = 24,
    Unknown7            = 25,
};

AsbBuiltInNodeType last_node_type;

struct ConditionalOffset {
    u32 offset;
    if (last_node_type == AsbBuiltInNodeType::FloatSelector) {
        FloatConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::BonePositionSelector) {
        FloatConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::OneDimensionalBlender) {
        FloatConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::RandomSelector) {
        RandomConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::BoolSelector) {
        BoolConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::IntSelector) {
        IntConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::StringSelector) {
        StringConnection child_node @ offset;
    } else if (last_node_type == AsbBuiltInNodeType::PreviousTagSelector) {
        TagConnection child_node @ offset;
    } else {
        StandardConnection child_node @ offset;
    }
};

struct ResConnection {
    u8 standard_count;
    u8 standard_base_index;
    u8 x2c_count;
    u8 x2c_base_index;
    u8 event_count;
    u8 event_index;
    u8 frame_control_count;
    u8 frame_control_base_index;
    
    ConditionalOffset standard_connections[standard_count];
    x2cOffset x2c_connections[x2c_count];
    StandardOffset event_connections[event_count];
    StandardOffset frame_connections[frame_control_count];
};

struct ResFloatSel {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    ResConnection connections;
};

struct ResStrSel {
    u32 reserve0;
    u32 name_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    ResConnection connections;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct ResSkelAnim {
    u32 reserve0;
    u32 name_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    u32 reserve7;
    ResConnection connections;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct ResOneDBlend {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    ResConnection connections;
};

struct ResSeq {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    ResConnection connections;
};

struct ResIntSel {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    ResConnection connections;
};

struct ResSimul {
    u32 reserve0;
    u32 reserve1;
    ResConnection connections;
};

struct ResEvt {
    u32 index;
    u32 reserve0;
    ResConnection connections;
    
    ResEvent event @ header.event_info_index_array_offset + index * 4;
};

struct ResTexAnim {
    u32 reserve0;
    u32 reserve1;
    u32 name_offset;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    ResConnection connections;
};

struct ResFrameCtrl {
    u32 reserve0;
    float animation_rate;
    u32 reserve1;
    float start_frame;
    u32 reserve2;
    float end_frame;
    u32 loop_type;
    u32 reserve3;
    float reserve4;
    float reserve5;
    u32 reserve6;
    float reserve7;
    u32 reserve8;
    float reserve9;
    u32 reserve10;
    float reserve11[16];
    ResConnection connections;
};

struct ResDummyAnim {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    ResConnection connections;
};

struct ResRandSel {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    ResConnection connections;
};

struct ResTagSel {
    u32 reserve0;
    u32 reserve1;
    ResConnection connections;
};

struct ResBonePosSel {
    u32 reserve0;
    u32 name_offset_1;
    u32 reserve1;
    u32 name_offset_2;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    ResConnection connections;
    
    char bone_1[] @ header.string_pool_offset + name_offset_1;
    char bone_2[] @ header.string_pool_offset + name_offset_2;
};

struct ResBoneAnim {
    u32 reserve0;
    u32 name_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    u32 reserve7;
    ResConnection connections;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct ResInitFrame {
    u32 reserve0;
    u32 tag_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 name_offset_1;
    u32 reserve4;
    u32 name_offset_2;
    u32 reserve5[6];
    ResConnection connections;
};

struct ResBoneBlend {
    u32 reserve0;
    u32 mask_name_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    u32 reserve6;
    ResConnection connections;
    
    char mask_name[] @ header.string_pool_offset + mask_name_offset;
};

struct ResBoolSel {
    u32 reserve0;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    u32 reserve4;
    u32 reserve5;
    ResConnection connections;
};

struct ResUnk5 {
    u32 reserve0;
    u32 name_offset;
    u32 reserve1;
    u32 reserve2;
    u32 reserve3;
    ResConnection connections;
    
    char name[] @ header.string_pool_offset + name_offset;
};

struct ResSubAnim {
    u32 reserve0;
    ResConnection connections;
};

struct ResAsbNode {
    AsbBuiltInNodeType node_type;
    last_node_type = node_type;
    u8 x3c_count;
    u8 reserve0;
    u32 tag_offset;
    u32 node_body_offset;
    u16 x40_base_index;
    u16 x40_count;
    u16 x3c_base_index;
    u16 reserve1;
    Guid guid;
    
    if (tag_offset != 0) {
        ResTagEntry tags @ tag_offset;
    }
    u32 x3c_index[x3c_count] @ header.x38_index_array_offset + x3c_base_index * 4;
    i = 0;
    if (x3c_count > 0) {
        ResEntry38 x38_entries[while(increment() < x3c_count)] @ addressof(header.x38_section[x3c_index[i]]);
    }
    i = 0;
    if (x40_count > 0) {
        ResEntry40 x40_entries[while(increment() < x40_count)] @ header.x40_offset + 0x20 * x40_base_index;
    }
    
    if (node_type == AsbBuiltInNodeType::FloatSelector) {
        ResFloatSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::StringSelector) {
        ResStrSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::SkeletalAnimation) {
        ResSkelAnim node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::OneDimensionalBlender) {
        ResOneDBlend node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::Sequential) {
        ResSeq node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::IntSelector) {
        ResIntSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::Simultaneous) {
        ResSimul node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::Event) {
        ResEvt node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::TextureAnimation) {
        ResTexAnim node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::FrameController) {
        ResFrameCtrl node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::DummyAnimation) {
        ResDummyAnim node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::RandomSelector) {
        ResRandSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::PreviousTagSelector) {
        ResTagSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::BonePositionSelector) {
        ResBonePosSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::BoneAnimation) {
        ResBoneAnim node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::InitialFrame) {
        ResInitFrame node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::BoneBlender) {
        ResBoneBlend node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::BoolSelector) {
        ResBoolSel node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::Message) {
        ResUnk5 node_body @ node_body_offset;
    } else if (node_type == AsbBuiltInNodeType::SubtractAnimation) {
        ResSubAnim node_body @ node_body_offset;
    }
};

/* global parameter stuff taken from Watertoon's AINB hexpat */
u32 max_index = 0;

bitfield ResAinbGlobalParameterNameAndFlags {
    name_offset    : 22;
    reserve0       : 1;
    reserve1       : 1; /* Set when referenced by a node output parameter? */
    bgyml_index    : 7;
    is_valid_index : 1;
};

struct ResAinbGlobalParameterInfo {
    ResAinbGlobalParameterNameAndFlags name_flags;
    if (name_flags.is_valid_index == 1) {
        if (name_flags.bgyml_index + 1 > max_index) {
            max_index = name_flags.bgyml_index + 1;
        }
    }

    char name[] @ name_flags.name_offset + header.string_pool_offset;
};

struct ResAinbGlobalParameterEntry {
    u16 count;
    u16 base_index;
    u16 base_offset;
    u16 reserve0;
};

struct ResAinbGlobalParameterBgyml {
    u32 bgyml_path_offset;
    u32 bgyml_path_murmur3_hash;
    u32 hash1;
    u32 hash2;
    
    char filepath[] @ header.string_pool_offset + bgyml_path_offset;
};

struct ResAinbGlobalParameterString {
    u32 string_offset;
    
    char string_value @ header.string_pool_offset + string_offset;
};
struct ResAinbGlobalParameterInt {
    s32 int_value;
};
struct ResAinbGlobalParameterFloat {
    float float_value;
};
struct ResAinbGlobalParameterBool {
    u8 bool_value;
};
struct ResAinbGlobalParameterVector3f {
    float x_value;
    float y_value;
    float z_value;
};

struct ResAsbGlobalParameter {
    ResAinbGlobalParameterEntry entry_string;
    ResAinbGlobalParameterEntry entry_s32;
    ResAinbGlobalParameterEntry entry_float;
    ResAinbGlobalParameterEntry entry_bool;
    ResAinbGlobalParameterEntry entry_vector3f;
    ResAinbGlobalParameterEntry entry_pointer; /* Doesn't store defaults */
    
    u32 param_count = entry_pointer.base_index + entry_pointer.count;

    ResAinbGlobalParameterInfo  parameters[param_count];

    ResAinbGlobalParameterString   o_default_array_string[entry_string.count]     @ entry_string.base_offset + addressof(this) + 0x30 + param_count * 0x4;
    ResAinbGlobalParameterInt      o_default_array_s32[entry_s32.count]           @ entry_s32.base_offset + addressof(this) + 0x30 + param_count * 0x4;
    ResAinbGlobalParameterFloat    o_default_array_float[entry_float.count]       @ entry_float.base_offset + addressof(this) + 0x30 + param_count * 0x4;
    ResAinbGlobalParameterBool     o_default_array_bool[entry_bool.count]         @ entry_bool.base_offset + addressof(this) + 0x30 + param_count * 0x4;
    ResAinbGlobalParameterVector3f o_default_array_vector3f[entry_vector3f.count] @ entry_vector3f.base_offset + addressof(this) + 0x30 + param_count * 0x4;
    
    u32 bgyml_count = max_index;
    
    ResAinbGlobalParameterBgyml o_bgyml_array[bgyml_count] @ addressof(this) + 0x30 + param_count * 0x4 + entry_vector3f.base_offset + entry_vector3f.count * 0xc;
};

/* Exb Table */
u32 g_exb_offset           @ 0x60;
u32 g_exb_pool_offset      @ g_exb_offset + 0x28;
u32 g_exb_parameter_region @ g_exb_offset + 0x24;

u32 g_exb_signature_table_offset @ g_exb_offset + 0x20;

struct ResExbStringOffset {
    u32 string_offset;
    
    char o_string @ g_exb_pool_offset + string_offset;
};

enum ExbCommandType : u8 {
    Terminator          = 0x1, /* Commands run until reaching a terminator */
    Store               = 0x2,
    Negate              = 0x3,
    NegateBool          = 0x4,
    Add                 = 0x5,
    Subtract            = 0x6,
    Multiply            = 0x7,
    Divide              = 0x8,
    Modulus             = 0x9,
    Increment           = 0xa,
    Decrement           = 0xb,
    ScalarMultiplyVec3f = 0xc,
    ScalarDivideVec3f   = 0xd,
    LeftShift           = 0xe,
    RightShift          = 0xf,
    LessThan            = 0x10,
    LessThanEqual       = 0x11,
    GreaterThan         = 0x12,
    GreaterThanEqual    = 0x13,
    Equal               = 0x14,
    NotEqual            = 0x15,
    And                 = 0x16,
    Xor                 = 0x17,
    Or                  = 0x18,
    LogicalAnd          = 0x19,
    LogicalOr           = 0x1a,
    UserFunction        = 0x1b, /* Executes a user registered function */
    JumpIfLhsZero       = 0x1c,
    Jump                = 0x1d, /* Jumps to a different command entry */
};

enum ExbDataType : u8 {
    Bool     = 0x2,
    S32      = 0x3,
    Float    = 0x4,
    String   = 0x5,
    Vector3f = 0x6,
};

enum ExbDataTypeU16 : u16 {
    Bool     = 0x2,
    S32      = 0x3,
    Float    = 0x4,
    String   = 0x5,
    Vector3f = 0x6,
};

enum ExbParamSource : u8 {
    Immediate               = 0x0,
    ImmediateString         = 0x1,
    StaticMemory            = 0x2,
    ParameterTable          = 0x3,
    ParameterTableString    = 0x4,
    OutputValue             = 0x5,
    InputValue              = 0x6,
    ScratchMemoryU32Aligned = 0x7,
    ScratchMemoryU64Aligned = 0x8,
    UserMemoryOutput        = 0x9,
    UserMemoryInput         = 0xa,
};

struct ResExbCommandEntry {
    ExbCommandType commmand_type;
    
    if (commmand_type == ExbCommandType::UserFunction) {
        u8  reserve0;
        u16 static_memory_offset;
        u32 signature_index;
        
        u32  o_signature_offset @ g_exb_offset + g_exb_signature_table_offset + 0x4 + signature_index * 0x4;
        char o_signature[] @ g_exb_offset + g_exb_pool_offset + o_signature_offset;
    } else {
        ExbDataType    data_type;
        ExbParamSource lhs_source;
        ExbParamSource rhs_source;
        u16            arg0; /* usually an lhs offset */
        u16            arg1; /* sometimes an rhs offset, or immediate */
        
        if (lhs_source == 0x3) {
            if (data_type == 0x2) {
                bool o_lhs_bool @ g_exb_offset + g_exb_parameter_region + arg0;
            }
            if (data_type == 0x3) {
                s32  o_lhs_s32 @ g_exb_offset + g_exb_parameter_region + arg0;
            }
            if (data_type == 0x4) {
                float o_lhs_bool @ g_exb_offset + g_exb_parameter_region + arg0;
            }
            if (data_type == 0x6) {
                float o_lhs_vec3f_x @ g_exb_offset + g_exb_parameter_region + arg0 + 0x0;
                float o_lhs_vec3f_y @ g_exb_offset + g_exb_parameter_region + arg0 + 0x4;
                float o_lhs_vec3f_z @ g_exb_offset + g_exb_parameter_region + arg0 + 0x8;
            }
        }
        if (lhs_source == 0x3 && data_type == 0x5) {
            ResExbStringOffset o_lhs_string @ g_exb_offset + g_exb_parameter_region + arg0;
        }
        
        if (rhs_source == 0x3) {
            if (data_type == 0x2) {
                bool o_rhs_bool @ g_exb_offset + g_exb_parameter_region + arg1;
            }
            if (data_type == 0x3) {
                s32  o_rhs_s32 @ g_exb_offset + g_exb_parameter_region + arg1;
            }
            if (data_type == 0x4) {
                float o_rhs_float @ g_exb_offset + g_exb_parameter_region + arg1;
            }
            if (data_type == 0x6) {
                float o_rhs_vec3f_x @ g_exb_offset + g_exb_parameter_region + arg1 + 0x0;
                float o_rhs_vec3f_y @ g_exb_offset + g_exb_parameter_region + arg1 + 0x4;
                float o_rhs_vec3f_z @ g_exb_offset + g_exb_parameter_region + arg1 + 0x8;
            }
        }
        if (rhs_source == 0x3 && data_type == 0x5) {
            ResExbStringOffset o_rhs_string @ g_exb_offset + g_exb_parameter_region + arg1;
        }
    }
};
struct ResExbCommandTable {
    u32                entry_count;
    ResExbCommandEntry entry_array[entry_count];
};

struct ResExbSignature {
    u32 signature_offset;
    
    char o_signature[] @ g_exb_offset + g_exb_pool_offset + signature_offset;
};

struct ResExbSignatureTable {
    u32             signature_count;
    ResExbSignature signature_offset_array[signature_count];
};

struct ResExbCommandInfoEntry {
    u32            base_index_pre_command_entry; /* Runs before main command if valid and stack memory is allowed */
    u32            count_pre_command_entry;
    u32            base_index_main_command_entry;
    u32            count_main_command_entry;
    u32            static_memory_usage;
    u16            scratch_memory_u32_size;
    u16            scratch_memory_u64_size;
    ExbDataTypeU16 output_data_type;
    ExbDataTypeU16 input_data_type;
};
struct ResExbCommandInfoTable {
    u32                    entry_count;
    ResExbCommandInfoEntry entry_array[entry_count];
};

struct ResExb {
    u32 magic;
    u32 version;
    u32 static_memory_size; /* Static work memory */
    u32 reserve1;
    u32 scratch_u32_allocator_size; /* Aligned by u32? */
    u32 scratch_u64_allocator_size; /* Aligned by u64? */
    u32 command_info_offset;
    u32 command_table_offset;
    u32 signature_table_offset;
    u32 parameter_region_offset;
    u32 string_pool_offset;
    
    ResExbCommandInfoTable o_command_info_table @ addressof(this) + command_info_offset;
    ResExbCommandTable     o_command_table      @ addressof(this) + command_table_offset;
    ResExbSignatureTable   o_signature_table    @ addressof(this) + signature_table_offset;
};

struct ResAsbHeader {
    char magic[4];
    u32 version;
    u32 filename_offset;
    u32 command_count;
    u32 node_count;
    u32 event_info_count;
    u32 x34_count;
    u32 x38_count;
    u32 global_parameters_offset;
    u32 string_pool_offset;
    u32 x28_offset;
    u32 x2c_offset;
    u32 event_info_index_array_offset;
    u32 x34_offset;
    u32 x38_offset;
    u32 x38_index_array_offset;
    u32 x40_offset;
    u32 x40_count;
    u32 bone_groups_offset;
    u32 bone_group_count;
    u32 string_pool_size;
    u32 transitions_offset;
    u32 tag_list_offset;
    u32 string_triplets_offset;
    u32 exb_offset;
    u32 x64_offset;
    u32 x68_offset;
    
    char filename[] @ string_pool_offset + filename_offset;
    
    ResEntry38 x38_section[x38_count] @ x38_offset;
    Res2c x2c_section @ x2c_offset;
    
    if (exb_offset != 0) {
        ResExb exb_section @ exb_offset;
    }
};

ResAsbHeader header @ 0x00;
ResAsbCommand commands[header.command_count] @ 0x6c;
ResAsbNode nodes[header.node_count] @ 0x6c + 0x30 * header.command_count;
ResAsbTransitions transitions @ header.transitions_offset;
Section68 x68_section @ header.x68_offset;
Section28 x28_section @ header.x28_offset;
ResTagList tag_list @ header.tag_list_offset;
ResStringTriplets string_triplets @ header.string_triplets_offset;
ResBoneGroup bone_groups[header.bone_group_count] @ header.bone_groups_offset;
ResAnimSlot animation_slots[header.x34_count] @ header.x34_offset;
ResAsbGlobalParameter global_parameters @ header.global_parameters_offset;
Section64 x64_section[u32(header.x64_offset > 0)] @ header.x64_offset;