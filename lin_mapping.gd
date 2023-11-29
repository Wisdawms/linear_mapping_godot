# FOR POINTERS: max_value is near, min_value is far

extends Node
var parent
var vector_parent
@export var desired_property : String
@export var max_distance_to_min_value: float = 200.0  # max distance in which the value will reach min_value_float, in pixels

# this is basically to get the bounding box of the sprite, right now it uses the width only, couldn't find a way to use both width and height
var origin_gap : float # change to a custom value if you'd like, defaulted to object's width
@export var additional_gap : float = 5.0

@export_category("min_max property types")
#region min_max property types
@export_subgroup("Int")
# for int properties
@export var max_value_int : int
@export var min_value_int : int

@export_subgroup("Float")
# for float properties
@export var max_value_float : float
@export var min_value_float : float

@export_subgroup("Vector2")
# for vector2 properties
@export var max_value_vector2 : Vector2
@export var min_value_vector2 : Vector2

@export_subgroup("Vector3")
# for vector3 properties
@export var max_value_vector3 : Vector3
@export var min_value_vector3 : Vector3

@export_subgroup("Vector4")
# for vector4 properties
@export var max_value_vector4 : Vector4
@export var min_value_vector4 : Vector4

@export_subgroup("Color")
# for color properties
@export var max_value_color : Color
@export var min_value_color : Color

@export_subgroup("Color_array")
# for Color_Array properties
@export var max_value_color_array : PackedColorArray 
@export var min_value_color_array : PackedColorArray

@export_subgroup("color_without_alpha")
# for color_without_alpha_path properties
@export_color_no_alpha var max_value_color_without_alpha
@export_color_no_alpha  var min_value_color_without_alpha

@export_subgroup("String")
# for string properties
@export var max_value_string : String
@export var min_value_string : String

@export_subgroup("Multi_line_String")
# for multi-line properties
@export_multiline var max_value_multi_line_string
@export_multiline var min_value_multi_line_string

@export_subgroup("Bool")
# for bool properties
@export var max_value_bool : bool
@export var min_value_bool : bool

@export_subgroup("Resource")
# for resource properties
@export var max_value_resource : Resource
@export var min_value_resource : Resource

@export_subgroup("Quaternion")
# for quaternion properties
@export var max_value_quaternion : Quaternion = Quaternion(0.0, 0.0, 0.0, 1.0)
@export var min_value_quaternion : Quaternion = Quaternion(0.0, 0.0, 0.0, 1.0)

@export_subgroup("Physics_Layers_2D")
# for 2d layers properties
@export_flags_2d_physics var max_value_physics_layer_2d
@export_flags_2d_physics var min_value_physics_layer_2d

@export_subgroup("Physics_Layers_3D")
# for 3d layers properties
@export_flags_3d_physics var max_value_physics_layer_3d
@export_flags_3d_physics var min_value_physics_layer_3d

@export_subgroup("Node_Path")
# for node_path properties
@export_node_path() var max_value_node_path
@export_node_path() var min_value_node_path

@export_subgroup("Global_File")
# for global_file_path properties
@export_global_file() var max_value_global_file
@export_global_file()  var min_value_global_file 

@export_subgroup("Global_Folder")
# for global_file_path properties
@export_global_dir() var max_value_global_folder
@export_global_dir()  var min_value_global_folder

@export_subgroup("exp_easing")
# for exp_easign properties
@export_exp_easing() var max_value_exp_easing
@export_exp_easing() var min_value_exp_easing

@export_subgroup("local_file")
# for local_file properties
@export_file var max_value_local_file
@export_file var min_value_local_file

@export_subgroup("local_folder")
# for local_folder properties
@export_dir var max_value_local_folder
@export_dir var min_value_local_folder

@export_subgroup("navigation_2d")
# for navigation_2d properties
@export_flags_2d_navigation var max_value_navigation_2d
@export_flags_2d_navigation var min_value_navigation_2d

@export_subgroup("render_2d")
# for render_2d properties
@export_flags_2d_render var max_value_render_2d
@export_flags_2d_render var min_value_render_2d

@export_subgroup("render_3d")
# for render_3d properties
@export_flags_3d_render var max_value_render_3d
@export_flags_3d_render var min_value_render_3d

@export_subgroup("flags_avoidance")
# for flags_avoidance properties
@export_flags_avoidance var max_value_flags_avoidance
@export_flags_avoidance var min_value_flags_avoidance

@export_subgroup("array")
# for array properties
@export var max_value_array : Array
@export var min_value_array : Array

@export_subgroup("bounding_box_Rect2d")
# for Rect2D properties
@export var max_value_Rect2d : Rect2
@export var min_value_Rect2d : Rect2


@export_subgroup("bounding_box_Rect3D")
# for Rect3D properties
@export var max_value_AAB_Rect3D : AABB
@export var min_value_AABB_Rect3D : AABB

@export_subgroup("basis")
# for Basis properties
@export var max_value_basis : Basis
@export var min_value_basis : Basis


@export_subgroup("Callable")
# for Basis properties
@export var max_value_callable : Callable 
@export var min_value_callable : Callable

@export_subgroup("Scene")
# for scene properties
@export var max_value_scene : PackedScene 
@export var min_value_scene : PackedScene

#endregion

func _ready() -> void:
	if get_parent() is Node2D or get_parent() is Control:
		parent = get_parent()
		vector_parent = get_parent()
		if get_parent().get_parent() is MarginContainer:
			vector_parent = get_parent().get_parent()
	else: # for a non-vector parent
		parent = get_parent()
		vector_parent = get_parent().get_parent()
	

func _process(_delta: float) -> void:
	
	if vector_parent is Node2D:
		origin_gap = vector_parent.get_rect().size.x / 2 * vector_parent.scale.x
	elif vector_parent is Control:
		print(vector_parent.size)
		origin_gap = vector_parent.get_rect().size.x / 2 * vector_parent.scale.x
		vector_parent.get_child(0).pivot_offset = vector_parent.get_child(0).size / 2
		vector_parent.pivot_offset = vector_parent.size / 2

	# Get the mouse position
	var mouse_position: Vector2 = vector_parent.get_global_mouse_position()
	# Calculate the distance to the mouse
	var distance: float = vector_parent.position.distance_to(mouse_position) - (origin_gap + additional_gap)
	# we use the parent's functions because it inherits from node2d, while this audio node does not belong in 2d space

	#linear mapping
	var t: float = distance / max_distance_to_min_value
	t = clamp(t, 0.0, 1.0) # to be used for lerp weight (can only be between 0.0 and 1.0)
	var interpolated_value
	if typeof(parent.get(desired_property)) == TYPE_FLOAT:
		interpolated_value = lerp(max_value_float, min_value_float, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_COLOR:
		interpolated_value = lerp(max_value_color, min_value_color, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_VECTOR2:
		interpolated_value = lerp(max_value_vector2, min_value_vector2, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_VECTOR3:
		interpolated_value = lerp(max_value_vector3, min_value_vector3, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_VECTOR4:
		interpolated_value = lerp(max_value_vector4, min_value_vector4, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_INT:
		interpolated_value = lerp(max_value_int, min_value_int, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_QUATERNION:
		interpolated_value = lerp(max_value_quaternion, min_value_quaternion, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_BOOL:
		if t != 0.0:
			parent.set(desired_property, min_value_bool)
		else: parent.set(desired_property, max_value_bool)
	elif typeof(parent.get(desired_property)) == TYPE_STRING:
		if t != 0.0:
			parent.set(desired_property, min_value_string)
		else:
			parent.set(desired_property, max_value_string)
	elif typeof(parent.get(desired_property)) == TYPE_OBJECT:
		if t != 0.0:
			parent.set(desired_property, min_value_resource)
		else:
			parent.set(desired_property, max_value_resource)
