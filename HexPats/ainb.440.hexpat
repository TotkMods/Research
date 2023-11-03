// By Watertoon

#pragma pattern_limit 5000000
#pragma eval_depth    512

#include <std/io.pat>

u32 cNodeSize = 0x38;

u32 g_pool_offset @ 0x24;

using ResAinbParameterImmediate;

u32                       g_immediate_table_offset @ 0x2c;
ResAinbParameterImmediate g_immediate_table @ g_immediate_table_offset;

using ResAinbResidentNodeUpdateArray;

u32 g_resident_update_array_offset @ 0x30;

using ResAinbParameterInputOutput;

u32                         g_reference_table_offset @ 0x34;
ResAinbParameterInputOutput g_output_reference_table @ g_reference_table_offset;

using ResAinbPreconditionNode;

u32 g_precondition_node_count @ 0x14;

fn GetLocalPreconditionNodeCount() {
    
    u32 flags_offset = 0x74 + g_command_count * 0x18 + 0x6;
    u32 sub_i = 0;
    for (u32 i = 0, i < g_node_count, i = i + 1) {
        u16 o_node_flags @ flags_offset + i * cNodeSize;
    
        if ((o_node_flags & 1) && (o_node_flags & 2) != 2) {
            sub_i = sub_i + 1;
        }
    }
    return sub_i;
};

u32 g_precondition_node_offset @ 0x4c;

fn ConvertPreconditionNodeIndexToNodeIndex(u16 precondition_node_index) {

    u32 flags_offset = 0x74 + g_command_count * 0x18 + 0x6;
    u32 sub_i = 0;
    for (u32 i = 0, i < g_node_count, i = i + 1) {
        u16 o_node_flags @ flags_offset + i * cNodeSize;
    
        if ((o_node_flags & 1) && (o_node_flags & 2) != 2) {
            if (sub_i == precondition_node_index) { return i; }
            sub_i = sub_i + 1;
        }
    }
    return -1;
};

using ResAinbNode;

u32 g_command_count @ 0xc;
u32 g_node_count    @ 0x10;

//ResAinbNode g_node_array[g_node_count] @ 0x74 + (g_command_count * 0x18);

using ResAinbGlobalParameterInfo;

u32 g_global_table @ 0x20;
u16 g_global_count @ g_global_table + 0x28;
u16 g_global_base  @ g_global_table + 0x2a;
ResAinbGlobalParameterInfo g_global_info_array[g_global_count + g_global_base] @ g_global_table + 0x30;


struct Guid {
    u32  guid0;
    u16  guid1;
    u16  guid2;
    u16  guid3;
    u8   guid4[6];
};

/* Enum resolve table (appears unused in totk) */
struct ResAinbEnumResolveEntry {
    u32 enum_value_result_offset;
    u32 enum_class_name_offset;
    u32 enum_value_name_offset;
    
    char o_enum_class_name[] @ g_pool_offset + enum_class_name_offset;
    char o_enum_value_name[] @ g_pool_offset + enum_value_name_offset;
};
struct ResAinbEnumResolveTable {
    u32                     entry_count;
    ResAinbEnumResolveEntry entry_array[entry_count];
};

/* Node parameter immediate */
enum AinbBuiltInNode : u16 {
	UserDefined                    = 0,
	Element_S32Selector            = 1,
	Element_Sequential             = 2,
	Element_Simultaneous           = 3,
	Element_F32Selector            = 4,
	Element_StringSelector         = 5,
	Element_RandomSelector         = 6,
	Element_BoolSelector           = 7,
	Element_Fork                   = 8,
	Element_Join                   = 9,
	Element_Alert                  = 10,
	Element_Expression             = 20,
	Element_ModuleIF_Input_S32     = 100,
	Element_ModuleIF_Input_F32     = 101,
	Element_ModuleIF_Input_Vec3f   = 102,
	Element_ModuleIF_Input_String  = 103,
	Element_ModuleIF_Input_Bool    = 104,
	Element_ModuleIF_Input_Ptr     = 105,
	Element_ModuleIF_Output_S32    = 200,
	Element_ModuleIF_Output_F32    = 201,
	Element_ModuleIF_Output_Vec3f  = 202,
	Element_ModuleIF_Output_String = 203,
	Element_ModuleIF_Output_Bool   = 204,
	Element_ModuleIF_Output_Ptr    = 205,
	Element_ModuleIF_Child         = 300,
	Element_StateEnd               = 400,
	Element_SplitTiming            = 500,
};
AinbBuiltInNode c_last_built_in_node_type;

bitfield AinbParamFlags {
    global_or_exb_index : 16;
    reserve0 : 7;
    set_pulse_tls_flag : 1; /* Whenever the variable is set, the AIFactoryMgr's Tls will be pulsed with 0x8000'0001 */
    set_ptr_flag_bit0 : 1;
    reserve3 : 7;
};

/* Note a parent node index of -100 to -8192 is actually a multi param base index */
fn GetMultiParamBaseIndex(u16 parent_node_index) {
    
    if (parent_node_index < 0x7fff || 0xff9c < parent_node_index) {
        return -1;
    }
    return 0xff9c - parent_node_index;
};

struct ResAinbNodeImmediateEntryInt {
    u32 name_offset;
    AinbParamFlags param_flags;
    u32 value;
    
    char o_field_name[] @ name_offset + g_pool_offset;
    
};
struct ResAinbNodeImmediateEntryFloat {
    u32 name_offset;
    AinbParamFlags param_flags;
    float value;
    
    char o_field_name[] @ name_offset + g_pool_offset;
    
};
struct ResAinbNodeImmediateEntryBool {
    u32 name_offset;
    AinbParamFlags param_flags;
    u32 value;
    
    char o_field_name[] @ name_offset + g_pool_offset;
    
};
struct ResAinbNodeImmediateEntryString {
    u32 name_offset;
    AinbParamFlags param_flags;
    u32 value;
    
    char o_field_name[] @ name_offset + g_pool_offset;
    char o_value[] @ value + g_pool_offset;
};

struct ResAinbNodeImmediateEntryVector3f {
    u32   name_offset;
    AinbParamFlags param_flags;
    float value_x;
    float value_y;
    float value_z;
    
    char o_field_name[] @ name_offset + g_pool_offset;
};

struct ResAinbNodeImmediateEntryPointer {
    u32   name_offset;
    u32   class_name_offset;
    AinbParamFlags param_flags;
    
    char o_field_name[] @ name_offset + g_pool_offset;
    char o_class_name[] @ class_name_offset + g_pool_offset;
};

struct ResAinbParameterImmediate {
    u32 offset_s32;
    u32 offset_bool;
    u32 offset_float;
    u32 offset_string;
    u32 offset_vector3f;
    u32 offset_pointer;
};

/* Output parameter */
bitfield ResAinbOutputParameterData {
    name_offset          : 31;
    is_set_ptr_flag_bit0 : 1;
};

struct ResAinbOutputParameter {
    ResAinbOutputParameterData data;
    
    char o_field_name[] @ g_pool_offset + data.name_offset;
};

struct ResAinbOutputParameterPointer {
    ResAinbOutputParameterData data;
    u32                        class_name_offset;

    char o_field_name[] @ g_pool_offset + data.name_offset;
    char o_class_name[] @ g_pool_offset + class_name_offset;
};


/* Input parameter */
struct ResAinbInputParameter {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    u32 reserve4;

    char o_field_name[] @ g_pool_offset + name_offset;
}; /* Template */


struct ResAinbInputParameterS32 {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    s32 default_value;

    char o_field_name[] @ g_pool_offset + name_offset;
};


struct ResAinbInputParameterBool {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    u32 default_value;

    char o_field_name[] @ g_pool_offset + name_offset;
};

struct ResAinbInputParameterF32 {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    float default_value;

    char o_field_name[] @ g_pool_offset + name_offset;
};

struct ResAinbInputParameterString {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    u32 default_value_offset;

    char o_field_name[] @ g_pool_offset + name_offset;
    char o_default_value[] @ g_pool_offset + default_value_offset;
};

struct ResAinbInputParameterVec3f {
    u32 name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    float default_value_x;
    float default_value_y;
    float default_value_z;

    char o_field_name[] @ g_pool_offset + name_offset;
};

struct ResAinbInputParameterPointer {
    u32 name_offset;
    u32 class_name_offset;
    s16 input_node_or_multi_base_index;
    s16 input_output_index_or_multi_count;
    AinbParamFlags param_flags;
    u32 reserve2;

    char o_field_name[] @ g_pool_offset + name_offset;
    char o_class_name[] @ g_pool_offset + class_name_offset;
};

struct ResAinbParameterInputOutput {
    u32 input_s32_offset;
    u32 output_s32_offset;
    u32 input_bool_offset;
    u32 output_bool_offset;
    u32 input_float_offset;
    u32 output_float_offset;
    u32 input_string_offset;
    u32 output_string_offset;
    u32 input_vector3f_offset;
    u32 output_vector3f_offset;
    u32 input_pointer_offset;
    u32 output_pointer_offset;
};

/* Inline parameter */
struct ResAinbNodeParameterEntry {
    u32 base_index;
    u32 count;
};

struct ResAinbNodeParameterInlineReserve0 {
    u32 node_index;
    u32 name_offset;
    
    if (c_last_built_in_node_type == AinbBuiltInNode::Element_BoolSelector) {
        u32 reserve1;
        u32 reserve2;
    }
    
    char o_other_output_field_name[] @ g_pool_offset + name_offset;
};
struct ResAinbNodeParameterInlineReserve0Offset {
    u32 inline_offset;
    
    ResAinbNodeParameterInlineReserve0 o_inline @ inline_offset;
}; /* Bool, float, input reflection? */

struct ResAinbNodeParameterInlineResidentUpdate {
    s16 next_node_index;
    u16 reserve0;
    u32 resident_update_index;
    
    ResAinbResidentNodeUpdateArray o_resident_update_entry @ g_resident_update_array_offset + resident_update_index * 0x4;
    if (o_resident_update_entry.o_update_entry.node_update.is_valid == true) {
        /* Circular references are possible */
        //ResAinbNode o_node @ 0x74 + (g_command_count * 0x18) + (next_node_index * 0x38);
    }
};
struct ResAinbNodeParameterInlineResidentUpdateOffset {
    u32 inline_offset;
    
    ResAinbNodeParameterInlineResidentUpdate o_inline @ inline_offset;
};

bitfield AinbSelectorGlobalParameterIndex {
    index    : 16;
    reserve0 : 15;
    is_valid : 1;
};
struct ResAinbNodeParameterInlineChildNode {
    s16 node_index;
    u16 reserve0;
    u32 name_offset;
    
    if (c_last_built_in_node_type == AinbBuiltInNode::Element_S32Selector) {
        AinbSelectorGlobalParameterIndex global_parameter_index; /* Used if valid */
        u32                              reference_value;        /* Selects this child node if equal to input */
    } else if (c_last_built_in_node_type == AinbBuiltInNode::Element_F32Selector) {
        AinbSelectorGlobalParameterIndex min_global_parameter_index; /* Used if valid */
        float                            min_value;                  /* Min value reference (inclusive) */
        AinbSelectorGlobalParameterIndex max_global_parameter_index; /* Used if valid */
        float                            max_value;                  /* Max value reference for selector (exclusive) */
    } else if (c_last_built_in_node_type == AinbBuiltInNode::Element_RandomSelector) {
        AinbSelectorGlobalParameterIndex global_parameter_index; /* Used if valid */
        float                            value;                  /* Used if not global parameter */
    } else if (c_last_built_in_node_type == AinbBuiltInNode::Element_StringSelector) {
        AinbSelectorGlobalParameterIndex global_parameter_index; /* Used if valid */
        u32                              value;                  /* Used if not global parameter */
        
        char o_selector_value[] @ g_pool_offset + value;
    }
    
    char        o_field_name[] @ g_pool_offset + name_offset;
    
    AinbBuiltInNode c_node_guard = c_last_built_in_node_type;
    if (node_index != 0x7fff && -1 < node_index) {
        //ResAinbNode o_node @ 0x74 + (g_command_count * 0x18) + (node_index * cNodeSize);
    }
    c_last_built_in_node_type = c_node_guard;
};

struct ResAinbNodeParameterInlineChildNodeOffset {
    u32 inline_offset;
    
    ResAinbNodeParameterInlineChildNode o_inline @ inline_offset;
};

struct ResAinbNodeParameterInlineReserve3 {
    s16 node_index;
    u16 reserve0;
    u32 name_offset;
    
    char        o_field_name[] @ g_pool_offset + name_offset;
    if (node_index != 0x7fff && -1 < node_index) {
        ResAinbNode o_node @ 0x74 + (g_command_count * 0x18) + (node_index * cNodeSize);
    }
}; /* String input reflection? */

struct ResAinbNodeParameterInlineReserve3Offset {
    u32 inline_offset;
    
    ResAinbNodeParameterInlineChildNode o_inline @ inline_offset;
};

struct ResAinbNodeParameterInlineReserve4Node {
    s16 node_index;
    u16 reserve0;
    u32 name_offset;
    
    char        o_field_name[] @ g_pool_offset + name_offset;
    if (node_index != 0x7fff && -1 < node_index) {
        ResAinbNode o_node @ 0x74 + (g_command_count * 0x18) + (node_index * cNodeSize);
    }
};

struct ResAinbNodeParameterInlineReserve4NodeOffset {
    u32 inline_offset;
    
    ResAinbNodeParameterInlineChildNode o_inline @ inline_offset;
}; /* S32 input reflection? */

/* Node parameter */
struct ResAinbNodeParameterImmediate {
    ResAinbNodeParameterEntry entry_s32;
    ResAinbNodeParameterEntry entry_bool;
    ResAinbNodeParameterEntry entry_float;
    ResAinbNodeParameterEntry entry_string;
    ResAinbNodeParameterEntry entry_vector3f;
    ResAinbNodeParameterEntry entry_pointer;
};

struct ResAinbNodeParameterInputOutput {
    ResAinbNodeParameterEntry entry_input_s32;
    ResAinbNodeParameterEntry entry_output_s32;
    ResAinbNodeParameterEntry entry_input_bool;
    ResAinbNodeParameterEntry entry_output_bool;
    ResAinbNodeParameterEntry entry_input_float;
    ResAinbNodeParameterEntry entry_output_float;
    ResAinbNodeParameterEntry entry_input_string;
    ResAinbNodeParameterEntry entry_output_string;
    ResAinbNodeParameterEntry entry_input_vector3f;
    ResAinbNodeParameterEntry entry_output_vector3f;
    ResAinbNodeParameterEntry entry_input_pointer;
    ResAinbNodeParameterEntry entry_output_pointer;
};

struct ResAinbNodeParameterInlineEntry {
    u8  count;
    u8  base_index;
};

struct ResAinbNodeParameterInline {
    ResAinbNodeParameterInlineEntry entry_reserve0;
    ResAinbNodeParameterInlineEntry entry_reserve1;
    ResAinbNodeParameterInlineEntry entry_child_node;
    ResAinbNodeParameterInlineEntry entry_resident_update;
    ResAinbNodeParameterInlineEntry entry_reserve3;
    ResAinbNodeParameterInlineEntry entry_reserve4;
    ResAinbNodeParameterInlineEntry entry_reserve5;
    ResAinbNodeParameterInlineEntry entry_reserve6;
    ResAinbNodeParameterInlineEntry entry_reserve7;
    ResAinbNodeParameterInlineEntry entry_reserve8;
};

struct ResAinbNodeParameter {
    ResAinbNodeParameterImmediate   immediate_parameter;
    ResAinbNodeParameterInputOutput input_output_parameter;
    ResAinbNodeParameterInline      inline_parameter;
    
    
    ResAinbNodeImmediateEntryInt      o_s32_immediate_entry[immediate_parameter.entry_s32.count]           @ g_immediate_table.offset_s32 + (immediate_parameter.entry_s32.base_index * 0xc);
    ResAinbNodeImmediateEntryBool     o_bool_immediate_entry[immediate_parameter.entry_bool.count]         @ g_immediate_table.offset_bool + (immediate_parameter.entry_bool.base_index * 0xc);
    ResAinbNodeImmediateEntryFloat    o_float_immediate_entry[immediate_parameter.entry_float.count]       @ g_immediate_table.offset_float + (immediate_parameter.entry_float.base_index * 0xc);
    ResAinbNodeImmediateEntryString   o_string_immediate_entry[immediate_parameter.entry_string.count]     @ g_immediate_table.offset_string + (immediate_parameter.entry_string.base_index * 0xc);
    ResAinbNodeImmediateEntryVector3f o_vector3f_immediate_entry[immediate_parameter.entry_vector3f.count] @ g_immediate_table.offset_vector3f + (immediate_parameter.entry_vector3f.base_index * 0x14);
    ResAinbNodeImmediateEntryPointer  o_pointer_immediate_entry[immediate_parameter.entry_pointer.count]   @ g_immediate_table.offset_pointer + (immediate_parameter.entry_pointer.base_index * 0xc);
    
	ResAinbInputParameterS32      o_s32_input_array[input_output_parameter.entry_input_s32.count]             @ g_output_reference_table.input_s32_offset + (input_output_parameter.entry_input_s32.base_index * 0x10);
	ResAinbOutputParameter        o_s32_output_array[input_output_parameter.entry_output_s32.count]           @ g_output_reference_table.output_s32_offset + (input_output_parameter.entry_output_s32.base_index * 0x4);
	ResAinbInputParameterBool     o_bool_input_array[input_output_parameter.entry_input_bool.count]           @ g_output_reference_table.input_bool_offset + (input_output_parameter.entry_input_bool.base_index * 0x10);
	ResAinbOutputParameter        o_bool_output_array[input_output_parameter.entry_output_bool.count]         @ g_output_reference_table.output_bool_offset + (input_output_parameter.entry_output_bool.base_index * 0x4);
	ResAinbInputParameterF32      o_float_input_array[input_output_parameter.entry_input_float.count]         @ g_output_reference_table.input_float_offset + (input_output_parameter.entry_input_float.base_index * 0x10);
	ResAinbOutputParameter        o_float_output_array[input_output_parameter.entry_output_float.count]       @ g_output_reference_table.output_float_offset + (input_output_parameter.entry_output_float.base_index * 0x4);
	ResAinbInputParameterString   o_string_input_array[input_output_parameter.entry_input_string.count]       @ g_output_reference_table.input_string_offset + (input_output_parameter.entry_input_string.base_index * 0x10);
	ResAinbOutputParameter        o_string_output_array[input_output_parameter.entry_output_string.count]     @ g_output_reference_table.output_string_offset + (input_output_parameter.entry_output_string.base_index * 0x4);
	ResAinbInputParameterVec3f    o_vector3f_input_array[input_output_parameter.entry_input_vector3f.count]   @ g_output_reference_table.input_vector3f_offset + (input_output_parameter.entry_input_vector3f.base_index * 0x18);
	ResAinbOutputParameter        o_vector3f_output_array[input_output_parameter.entry_output_vector3f.count] @ g_output_reference_table.output_vector3f_offset + (input_output_parameter.entry_output_vector3f.base_index * 0x4);
	ResAinbInputParameterPointer  o_pointer_input_array[input_output_parameter.entry_input_pointer.count]     @ g_output_reference_table.input_pointer_offset + (input_output_parameter.entry_input_pointer.base_index * 0x14);
	ResAinbOutputParameterPointer o_pointer_output_array[input_output_parameter.entry_output_pointer.count]   @ g_output_reference_table.output_pointer_offset + (input_output_parameter.entry_output_pointer.base_index * 0x8);
    
    ResAinbNodeParameterInlineReserve0Offset       o_reserve0_inline_array[inline_parameter.entry_reserve0.count]               @ addressof(this) + 0xa4 + (inline_parameter.entry_reserve0.base_index * sizeof(u32));
    ResAinbNodeParameterInlineChildNodeOffset      o_child_node_inline_array[inline_parameter.entry_child_node.count]           @ addressof(this) + 0xa4 + (inline_parameter.entry_child_node.base_index * sizeof(u32));
    ResAinbNodeParameterInlineResidentUpdateOffset o_resident_update_inline_array[inline_parameter.entry_resident_update.count] @ addressof(this) + 0xa4 + (inline_parameter.entry_resident_update.base_index * sizeof(u32));
    ResAinbNodeParameterInlineReserve3Offset       o_reserve3_inline_array[inline_parameter.entry_reserve3.count] @ addressof(this) + 0xa4 + (inline_parameter.entry_reserve3.base_index * sizeof(u32)); 
    ResAinbNodeParameterInlineReserve4NodeOffset   o_reserve4_inline_array[inline_parameter.entry_reserve4.count] @ addressof(this) + 0xa4 + (inline_parameter.entry_reserve4.base_index * sizeof(u32)); 
};

/* Node */

bitfield ResAinbNodeFlags {
    is_precondition_node    : 1;
    is_external_ainb        : 1;
    is_resident_initialized : 1; /* Node is initialized for ainb duration */
    reserve0                : 5;
};
struct ResAinbNode {
    AinbBuiltInNode  built_in_node_type;
    u16  node_index;
    u16  attachment_count;
    ResAinbNodeFlags node_flags;
    u8   reserve3;
    u32  name_offset;
    u32  reserve4;
    u32  node_parameter_offset;
    u16  exb_field_count;
    u16  exb_value_size;
    u16  multi_param_count;
    u16  reserve8;
    u32  base_attachment;
    u16  base_precondition_node;
    u16  precondition_node_count;
    u16  reserve13;
    u16  reserve14;
    Guid guid;
    
    c_last_built_in_node_type = built_in_node_type;

    char                 o_node_name[]    @ name_offset + g_pool_offset;
    ResAinbNodeParameter o_node_parameter @ node_parameter_offset;
    if (precondition_node_count != 0) {
        ResAinbPreconditionNode o_precondition_node_array[precondition_node_count] @ g_precondition_node_offset + base_precondition_node * 0x4;
    }
};

/* Command */
struct ResAinbCommand {
    u32  name_offset;
    Guid guid;
    u16  left_node_index;
    u16  right_node_index; // note; 0 = invalid, so node_index = right_node_index - 1

    char o_command_name[]   @ name_offset + g_pool_offset;
    ResAinbNode o_left_node @ 0x74 + (g_command_count * 0x18) + (left_node_index * cNodeSize);
    if (right_node_index != 0) {
        ResAinbNode o_right_node @ 0x74 + (g_command_count * 0x18) + ((right_node_index - 1) * cNodeSize);
    }
};

/* Global parameter */
bitfield ResAinbGlobalParameterNameAndFlags {
    name_offset    : 22;
    reserve0       : 1;
    reserve1       : 1; /* Set when referenced by a node output parameter? */
    bgyml_index    : 7;
    is_valid_index : 1;
};
struct ResAinbGlobalParameterInfo {
    ResAinbGlobalParameterNameAndFlags name_flags;
    u32 null_string_offset;

    char o_field_name[] @ name_flags.name_offset + g_pool_offset;
    char o_null_name[] @ null_string_offset + g_pool_offset;
};


using ResAinbGlobalParameterBgyml;

fn findMaxBgymlIndex(u32 count) {

    u32 max = 0;
    for (u32 i = 0, i < count, i = i + 1) {
        u32  index    = g_global_info_array[i].name_flags.bgyml_index;
        bool is_valid = g_global_info_array[i].name_flags.is_valid_index;
        if (is_valid == true && max <= index) {
            max = index + 1;
        }
    }

    return max;
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
    
    char o_file_path[] @ g_pool_offset + bgyml_path_offset;
};

struct ResAinbGlobalParameterString {
    u32 string_offset;
    
    char o_string @ g_pool_offset + string_offset;
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

struct ResAinbGlobalParameter {
    ResAinbGlobalParameterEntry entry_string;
    ResAinbGlobalParameterEntry entry_s32;
    ResAinbGlobalParameterEntry entry_float;
    ResAinbGlobalParameterEntry entry_bool;
    ResAinbGlobalParameterEntry entry_vector3f;
    ResAinbGlobalParameterEntry entry_pointer; /* Doesn't store defaults */
    
    u32 pair_count = entry_pointer.base_index + entry_pointer.count;

    ResAinbGlobalParameterInfo  pair_array[pair_count];

    ResAinbGlobalParameterString   o_default_array_string[entry_string.count]     @ entry_string.base_offset + addressof(this) + 0x30 + pair_count * 0x8;
    ResAinbGlobalParameterInt      o_default_array_s32[entry_s32.count]           @ entry_s32.base_offset + addressof(this) + 0x30 + pair_count * 0x8;
    ResAinbGlobalParameterFloat    o_default_array_float[entry_float.count]       @ entry_float.base_offset + addressof(this) + 0x30 + pair_count * 0x8;
    ResAinbGlobalParameterBool     o_default_array_bool[entry_bool.count]         @ entry_bool.base_offset + addressof(this) + 0x30 + pair_count * 0x8;
    ResAinbGlobalParameterVector3f o_default_array_vector3f[entry_vector3f.count] @ entry_vector3f.base_offset + addressof(this) + 0x30 + pair_count * 0x8;
    
    u32 bgyml_count = findMaxBgymlIndex(pair_count);
    
    ResAinbGlobalParameterBgyml o_bgyml_array[bgyml_count] @ addressof(this) + 0x30 + pair_count * 0x8 + entry_vector3f.base_offset + entry_vector3f.count * 0xc;
};

/* Arbiter */
struct ResAinbAttachmentParameter {
    u8                            is_updatable;
    u8                            reserve0;
    u16                           reserve1;
    ResAinbNodeParameterImmediate immediate;
    
    ResAinbNodeImmediateEntryInt      o_s32_immediate_entry[immediate.entry_s32.count]           @ g_immediate_table.offset_s32 + (immediate.entry_s32.base_index * 0xc);
    ResAinbNodeImmediateEntryBool     o_bool_immediate_entry[immediate.entry_bool.count]         @ g_immediate_table.offset_bool + (immediate.entry_bool.base_index * 0xc);
    ResAinbNodeImmediateEntryFloat    o_float_immediate_entry[immediate.entry_float.count]       @ g_immediate_table.offset_float + (immediate.entry_float.base_index * 0xc);
    ResAinbNodeImmediateEntryString   o_string_immediate_entry[immediate.entry_string.count]     @ g_immediate_table.offset_string + (immediate.entry_string.base_index * 0xc);
    ResAinbNodeImmediateEntryVector3f o_vector3f_immediate_entry[immediate.entry_vector3f.count] @ g_immediate_table.offset_vector3f + (immediate.entry_vector3f.base_index * 0x14);
    ResAinbNodeImmediateEntryPointer  o_pointer_immediate_entry[immediate.entry_pointer.count]   @ g_immediate_table.offset_pointer + (immediate.entry_pointer.base_index * 0xc);
};

struct ResAinbAttachment {
    u32 name_offset;
    u32 attachment_parameter_offset;
    u16 exb_field_count;
    u16 exb_value_size;
    
    char                       o_attachment_name[] @ g_pool_offset + name_offset;
    ResAinbAttachmentParameter o_attachment_parameter @ attachment_parameter_offset;
};

/* Exb Table */
u32 g_exb_offset           @ 0x44;
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

/* Child replacement */
enum AinbReplacementType : u8 {
    RemoveChildParameter  = 0, /* Removes a single child node */
    ReplaceChildParameter = 1, /* Replaces a single child node */
    RemoveAttachment      = 2, /* Removes a single attachment */
};
struct ResAinbReplacementEntry {
    AinbReplacementType type;
    u8  reserve0;
    u16 replace_node_index;
    
    if (type == AinbReplacementType::RemoveChildParameter) {
        u16 base_index_inline_child_node;
        u16 reserve1;
    } else if (type == AinbReplacementType::ReplaceChildParameter) {
        u16 base_index_inline_child_node;
        u16 new_node_index;
    } else if (type == AinbReplacementType::RemoveAttachment) {
        u16 base_index_attachment;
        u16 reserve1;
    } else { /* Should not exist */
        u16 reserve1;
        u16 reserve2;
    }
};
struct ResAinbChildReplacementTable {
    u8  init_guard;
    u8  reserve0;
    u16 replacement_count;
    u16 override_node_count;
    s16 override_arbiter_count;
    ResAinbReplacementEntry entry_array[replacement_count];
};

/* Precondition node */
struct ResAinbPreconditionNode {
    u16 precondition_node_index;
    u16 reserve0;
    
    s32 c_node_index = ConvertPreconditionNodeIndexToNodeIndex(precondition_node_index);
    if (c_node_index != -1) {
        /* Circular references are possible */
        //ResAinbNode o_node @ 0x74 + g_command_count * 0x18 + c_node_index * 0x38;
    }
};

/* Embed ainb */
struct ResAinbEmbedAinb {
    u32 file_path_offset;
    u32 category_offset;
    u32 ainb_count;
    
    char o_file_path[] @ file_path_offset + g_pool_offset;
    char o_category[] @ category_offset + g_pool_offset;
};
struct ResAinbEmbedAinbArray {
    u32              embed_ainb_count;
    ResAinbEmbedAinb embed_ainb_array[embed_ainb_count];
};

/* Enter string? */
struct ResAinbNodeEnter {
    u32 node_index;
    u32 string0;
    u32 string1;
    
    char o_string0[] @ g_pool_offset + string0;
    char o_string1[] @ g_pool_offset + string1;
    ResAinbNode o_node @ addressof(g_node_array[node_index]);
};
struct ResAinbNodeEnterString {
    u32 entry_count;
    ResAinbNodeEnter entry_array[entry_count];
};

/* Resident Node */
bitfield ResAinbResidentNodeUpdate {
    is_valid            : 8;
    reserve0            : 23;
    is_update_post_calc : 1; /* Changes the node post current command calc instead of before next command calc */
};
struct ResAinbResidentNodeUpdateEntry {
    ResAinbResidentNodeUpdate node_update;
    
    if (node_update.is_valid == false) {
        u32 name_offset;
        char o_name @ g_pool_offset + name_offset;
    }
};

struct ResAinbResidentNodeUpdateArray {
    u32 entry_offset;
    
    ResAinbResidentNodeUpdateEntry o_update_entry @ entry_offset;
};

/* Multi param array */
struct ResAinbMultiParamArray {
    u32 reserve0;
    u32 reserve1;
};

/* Header */
struct ResAinb {
    u32            magic;
    u32            version;
    u32            file_name_offset;
    u32            command_count;
    u32            node_count;
    u32            precondition_node_count;
    u32            attachment_count;
    u32            output_node_count; /* Count of 0x200 - 0x2ff built in nodes */
    u32            global_parameter_offset;
    u32            string_pool_offset;
    u32            enum_resolve_array_offset;
    u32            immediate_parameter_offset;
    u32            resident_update_array_offset;
    u32            input_output_parameter_offset;
    u32            multi_param_array_offset;
    u32            attachment_array_offset;
    u32            attachment_index_array_offset;
    u32            exb_offset;
    u32            child_replacement_table_offset;
    u32            precondition_node_table_offset;
    u32            reserve11;
    u32            reserve12;
    u32            reserve13;
    u32            embed_ainb_array_offset;
    u32            category_offset;
    u32            reserve15;
    u32            enter_string_offset;
    u32            reserve17;
    u32            reserve18;
    ResAinbCommand command_array[command_count];
    ResAinbNode    node_array[node_count];

    char                        o_file_name[]                  @ addressof(this) + file_name_offset + string_pool_offset;
    char                        o_category[]                   @ addressof(this) + category_offset + string_pool_offset;
    ResAinbGlobalParameter      o_global_parameter             @ addressof(this) + global_parameter_offset;
    ResAinbEnumResolveTable     o_enum_resolve_table           @ addressof(this) + enum_resolve_array_offset;
    ResAinbParameterImmediate   o_immediate_parameter_table    @ addressof(this) + immediate_parameter_offset;
    ResAinbParameterInputOutput o_input_output_parameter_table @ addressof(this) + input_output_parameter_offset;
    
    ResAinbAttachment           o_attachment_array[attachment_count]       @ addressof(this) + attachment_array_offset;
    u32                         o_attachment_index_array[attachment_count] @ addressof(this) + attachment_index_array_offset;
    
    if (exb_offset != 0) {
        ResExb                  o_exb @ addressof(this) + exb_offset;
    }
    if (child_replacement_table_offset != 0) {
        ResAinbChildReplacementTable o_child_replacement_table @ addressof(this) + child_replacement_table_offset;
    }
    ResAinbPreconditionNode     o_precondition_node_table[GetLocalPreconditionNodeCount()] @ addressof(this) + precondition_node_table_offset;
    
    ResAinbEmbedAinbArray       o_embed_ainb @ addressof(this) + embed_ainb_array_offset;
    ResAinbNodeEnterString      o_enter_string @ addressof(this) + enter_string_offset;
};

ResAinb head @ 0x0;