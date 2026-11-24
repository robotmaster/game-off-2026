extends Node2D
class_name PolygonParent

@export var Room : RoomRoot

@export_group("Dont Touch")
@export var color : Color

const POLYGON_MOVE_SPEED = 170
const POLYGON_ROTATION_SPEED = 1.9
const POLYGON_SCALE_SPEED_MULT = 2.4

const SLOW_MOVE_MULT = 0.25

func _physics_process(delta: float) -> void:
	_center_polygon_on_centroid()
	
	if self == Room.get_current_polygon_editing():
		_move_polygon(delta)
	_center_polygon_on_centroid()

func _move_polygon(delta: float) -> void:
	if Room.allowed_polygon_transforms[Room.transform_editing_index]["transform"] == Room.PolygonTransforms.Translate:
		if Input.is_action_pressed("move_slow"):
			global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED * SLOW_MOVE_MULT
		else:
			global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED
	
	elif Room.allowed_polygon_transforms[Room.transform_editing_index]["transform"] == Room.PolygonTransforms.Rotate:
		var axis : float = sign(Input.get_axis("left", "right") + Input.get_axis("down", "up"))
		if Input.is_action_pressed("move_slow"):
		
			global_rotation += POLYGON_ROTATION_SPEED * axis * delta * SLOW_MOVE_MULT
		else:
			global_rotation += POLYGON_ROTATION_SPEED * axis * delta
	
	elif Room.allowed_polygon_transforms[Room.transform_editing_index]["transform"] == Room.PolygonTransforms.Scale:
		if Input.is_action_pressed("move_slow"):
			scale.x *= pow(POLYGON_SCALE_SPEED_MULT, delta * SLOW_MOVE_MULT) ** Input.get_axis("left", "right")
			scale.y *= pow(POLYGON_SCALE_SPEED_MULT, delta * SLOW_MOVE_MULT) ** Input.get_axis("up", "down")
		else:
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
