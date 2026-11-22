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
	for 
	print(PolygonTools.get_polygon_centroid())
	global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED
