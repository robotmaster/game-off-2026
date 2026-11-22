extends Node2D

@export var Room : RoomRoot
@export var moving_allowed := false
@export var rotating_allowed := false
@export var scaling_allowed := false

const POLYGON_MOVE_SPEED = 100

func _physics_process(delta: float) -> void:
	if self == Room.get_current_polygon_editing():
		_move_polygon(delta)

func _move_polygon(delta: float) -> void:
	
	global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED

func _process(delta: float) -> void:
	if self == Room.get_current_polygon_editing():
		queue_redraw()

func _draw() -> void:
	var all_children_polygons : Array[PackedVector2Array]= []
	for polygon in Room.get_children_polygons(self):
		all_children_polygons.append(polygon.global_transform * polygon.polygon)
	
	var centroid := PolygonTools.get_polygon_centroid(all_children_polygons)
	
	draw_circle(global_transform.affine_inverse() * centroid, 10, Color.GRAY)
