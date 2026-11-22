extends Node2D
class_name PolygonParent

@export var Room : RoomRoot
@export var moving_allowed := false
@export var rotating_allowed := false
@export var scaling_allowed := false

@export_group("Dont Touch")
@export var color : Color

const POLYGON_MOVE_SPEED = 100
const POLYGON_ROTATION_SPEED = 1.9
const POLYGON_SCALE_SPEED_MULT = 1.7

var allowed = []

func _ready() -> void:
	if moving_allowed:
		allowed.append(Room.PolygonTransforms.Translate)
	if rotating_allowed:
		allowed.append(Room.PolygonTransforms.Rotate)
	if scaling_allowed:
		allowed.append(Room.PolygonTransforms.Scale)

func _physics_process(delta: float) -> void:
	_center_polygon_on_centroid()
	
	if self == Room.get_current_polygon_editing():
		_move_polygon(delta)
	_center_polygon_on_centroid()

func _move_polygon(delta: float) -> void:
	if Room.polygon_transform_editing == Room.PolygonTransforms.Translate and moving_allowed:
		global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED
	
	elif Room.polygon_transform_editing == Room.PolygonTransforms.Rotate and rotating_allowed:
		global_rotation += POLYGON_ROTATION_SPEED * Input.get_axis("left", "right") * delta
	
	elif Room.polygon_transform_editing == Room.PolygonTransforms.Scale and scaling_allowed:
		scale.x *= pow(POLYGON_SCALE_SPEED_MULT, delta) ** Input.get_axis("left", "right")
		scale.y *= pow(POLYGON_SCALE_SPEED_MULT, delta) ** Input.get_axis("up", "down")


func _center_polygon_on_centroid() -> void:
	var centroid := get_centroid()
	var position_difference := global_position - centroid
	
	for polygon in Room.get_children_polygons(self):
		
		var global_translate := PolygonTools.translate_polygon(polygon.global_transform * polygon.polygon, position_difference)
		polygon.polygon = polygon.global_transform.affine_inverse() * global_translate
	
	
	global_position = centroid

func get_centroid() -> Vector2:
	var all_children_polygons : Array[PackedVector2Array] = []
	for polygon in Room.get_children_polygons(self):
		all_children_polygons.append(polygon.global_transform * polygon.polygon)
	return PolygonTools.get_polygon_centroid(all_children_polygons)
	#return Vector2(-100, 100)
