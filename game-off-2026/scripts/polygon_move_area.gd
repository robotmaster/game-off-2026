extends Polygon2D
class_name PolygonMoveArea

const PLAYING_LIGHT_ENERGY = 0.5;
const EDITING_LIGHT_ENERGY = 0.2;
const LIGHT_FADE_MULT = 0.95;

@export_group("Red Editing")
@export var red_translate_allowed := false
@export var red_rotate_allowed := false
@export var red_scale_allowed := false
@export_group("Green Editing")
@export var green_translate_allowed := false
@export var green_rotate_allowed := false
@export var green_scale_allowed := false
@export_group("Blue Editing")
@export var blue_translate_allowed := false
@export var blue_rotate_allowed := false
@export var blue_scale_allowed := false

var time := 0.0

func _ready() -> void:
	polygon = global_transform * polygon
	
	global_transform = Transform2D()
	
	$CollisionArea/Polygon.polygon = polygon

func update_move_areas(Room : RoomRoot, Player : PlayerClass) -> void:
	var space_state := get_world_2d().direct_space_state
	
	if not PolygonTools.is_colliding_with_area_currently(space_state, Player.hitbox, $CollisionArea):
		return
	
	var allowed_transforms := []
	if red_translate_allowed:
		allowed_transforms.append({"node": Room.color_1_parent, "transform": Room.PolygonTransforms.Translate})
	if red_rotate_allowed:
		allowed_transforms.append({"node": Room.color_1_parent, "transform": Room.PolygonTransforms.Rotate})
	if red_scale_allowed:
		allowed_transforms.append({"node": Room.color_1_parent, "transform": Room.PolygonTransforms.Scale})
	
	if green_translate_allowed:
		allowed_transforms.append({"node": Room.color_2_parent, "transform": Room.PolygonTransforms.Translate})
	if green_rotate_allowed:
		allowed_transforms.append({"node": Room.color_2_parent, "transform": Room.PolygonTransforms.Rotate})
	if green_scale_allowed:
		allowed_transforms.append({"node": Room.color_2_parent, "transform": Room.PolygonTransforms.Scale})
	
	if blue_translate_allowed:
		allowed_transforms.append({"node": Room.color_3_parent, "transform": Room.PolygonTransforms.Translate})
	if blue_rotate_allowed:
		allowed_transforms.append({"node": Room.color_3_parent, "transform": Room.PolygonTransforms.Rotate})
	if blue_scale_allowed:
		allowed_transforms.append({"node": Room.color_3_parent, "transform": Room.PolygonTransforms.Scale})
	
	Room.allowed_polygon_transforms = allowed_transforms

func update_polygon_light(Room : RoomRoot) -> void:
	if Room.is_editing:
		VisualTools.add_polygon_light([polygon], EDITING_LIGHT_ENERGY, LIGHT_FADE_MULT)
	else:
		VisualTools.add_polygon_light([polygon], PLAYING_LIGHT_ENERGY, LIGHT_FADE_MULT)

func _process(delta: float) -> void:
	
	time += delta
	material.set_shader_parameter("time", time)
