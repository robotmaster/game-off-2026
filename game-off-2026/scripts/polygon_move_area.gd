extends Polygon2D
class_name PolygonMoveArea

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

func _ready() -> void:
	polygon = global_transform * polygon
	
	global_transform = Transform2D()
	
	$CollisionArea/Polygon.polygon = polygon
	
	#VisualTools.setup_polygon_light($Light)

func update_move_areas(Room : RoomRoot, Player : PlayerClass) -> void:
	#VisualTools.update_polygon_light($Light, [polygon], LIGHT_FADE_MULT)

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
