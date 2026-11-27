extends Node2D
class_name RoomRoot

signal allowed_transformed_changed
signal editing_changed

@export_group("Don't Touch")
@export var color_1_parent : Node2D
@export var color_2_parent : Node2D
@export var color_3_parent : Node2D

enum PolygonTransforms {
	Translate,
	Rotate,
	Scale
}

var allowed_polygon_transforms := []

var transform_editing_index := 0

var is_editing := false

func _ready() -> void:
	ProjectSettings.set_setting("rendering/viewport/hdr_2d", true)
	is_editing = true
	#_set_transform_editing_to_first_valid()
	is_editing = false


func _physics_process(_delta: float) -> void:
	_update_allowed_transforms()
	
	if Input.is_action_just_pressed("toggle_play") and not VisualTools.transitioning:
		if is_editing or (not $Player.is_locked and len(allowed_polygon_transforms) > 0):
			toggle_editing()
	
	%PolygonMoveAreas.update_polygon_lights()
	
	if Input.is_action_just_pressed("switch_edit") and is_editing and not VisualTools.transitioning:
		transform_editing_index += 1
		editing_changed.emit()
	
	if transform_editing_index >= len(allowed_polygon_transforms):
		transform_editing_index = 0
	
	if Input.is_action_just_pressed("reset") and not VisualTools.transitioning:
		reset_room()
	
	%IntersectionArea.do_polygon_collisions()

func _update_allowed_transforms() -> void:
	var saved_allowed := allowed_polygon_transforms.duplicate()
	
	%PolygonMoveAreas.update_allowed_transforms()
	
	
	for saved : Dictionary in saved_allowed:
		var found := false
		for allowed : Dictionary in allowed_polygon_transforms:
			if saved["node"] == allowed["node"] and saved["transform"] == allowed["transform"]:
				found = true
				break
		if not found:
			allowed_transformed_changed.emit()
			return
	
	
	for allowed : Dictionary in allowed_polygon_transforms:
		var found := false
		for saved : Dictionary in saved_allowed:
			if saved["node"] == allowed["node"] and saved["transform"] == allowed["transform"]:
				found = true
				break
		if not found:
			allowed_transformed_changed.emit()
			return

func get_children_polygons(parent: Node2D) -> Array[Polygon2D]:
	var children := []
	
	for child in parent.get_children():
		assert(child is Polygon2D, "Child is not polygon2D")
		children.append(child)
	return children


func get_current_polygon_editing() -> PolygonParent:
	if not is_editing:
		return null
	if transform_editing_index >= len(allowed_polygon_transforms):
		return null
	return allowed_polygon_transforms[transform_editing_index]["node"]

func toggle_editing() -> void:
	is_editing = not is_editing

func reset_room() -> void:
	VisualTools.start_out_transition(true, _reset_room)

func _reset_room() -> void:
	get_tree().reload_current_scene()

func go_to_next_room() -> void:
	VisualTools.start_out_transition(false, _go_to_next_room)

func _go_to_next_room() -> void:
	get_tree().change_scene_to_packed(LevelManager.next_room())
