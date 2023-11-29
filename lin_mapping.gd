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

# for float properties
@export var max_value_float : float
@export var min_value_float : float

# for vector2 properties
@export var max_value_vector2 : Vector2
@export var min_value_vector2 : Vector2

# for int properties
@export var max_value_int : int
@export var min_value_int : int

# for color properties
@export var max_value_color : Color
@export var min_value_color : Color

# for vector3 properties
@export var max_value_vector3 : Vector3
@export var min_value_vector3 : Vector3

# for string properties
@export var max_value_string : String
@export var min_value_string : String

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
	elif typeof(parent.get(desired_property)) == TYPE_INT:
		interpolated_value = lerp(max_value_int, min_value_int, t)
		parent.set(desired_property, interpolated_value)
	elif typeof(parent.get(desired_property)) == TYPE_BOOL:
		if t != 0.0:
			parent.set(desired_property, false)
		else: parent.set(desired_property, true)
	elif typeof(parent.get(desired_property)) == TYPE_STRING:
		if t != 0.0:
			parent.set(desired_property, min_value_string)
		else:
			parent.set(desired_property, max_value_string)
