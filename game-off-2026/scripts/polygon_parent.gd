extends Node2D

@export var Room : RoomRoot
@export var moving_allowed := false
@export var rotating_allowed := false
@export var scaling_allowed := false

const POLYGON_MOVE_SPEED = 100
const POLYGON_ROTATION_SPEED = 0.1

func _physics_process(delta: float) -> void:
	_center_polygon_on_centroid()
	
	if self == Room.get_current_polygon_editing():
		_move_polygon(delta)
	_center_polygon_on_centroid()

func _move_polygon(delta: float) -> void:
	global_rotation += POLYGON_ROTATION_SPEED * Input.get_axis("left", "right")
	#global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED

func _process(delta: float) -> void:
	if self == Room.get_current_polygon_editing():
		queue_redraw()

func _draw() -> void:
	
	var centroid := _get_centroid()
	
	draw_circle(global_transform.affine_inverse() * centroid, 10, Color.GRAY)


func _center_polygon_on_centroid() -> void:
	var centroid := _get_centroid()
	var position_difference := global_position - centroid
	
	for polygon in Room.get_children_polygons(self):
		
		var global_translate := PolygonTools.translate_polygon(polygon.global_transform * polygon.polygon, position_difference)
		polygon.polygon = polygon.global_transform.affine_inverse() * global_translate
	
	
	global_position = centroid

func _get_centroid() -> Vector2:
	var all_children_polygons : Array[PackedVector2Array] = []
	for polygon in Room.get_children_polygons(self):
		all_children_polygons.append(polygon.global_transform * polygon.polygon)
	return PolygonTools.get_polygon_centroid(all_children_polygons)
	#return Vector2(-100, 100)
