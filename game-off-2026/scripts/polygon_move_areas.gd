extends Node2D

@export var Room : RoomRoot
@export var Player : PlayerClass

func update_allowed_transforms() -> void:
	Room.allowed_polygon_transforms = []
	
	for child in get_children():
		assert(child is PolygonMoveArea, "child of polygonmoveeareas is not a polygonmovearea")
		child.update_move_areas(Room, Player)

func update_polygon_lights() -> void:
	for child in get_children():
		assert(child is PolygonMoveArea, "child of polygonmoveeareas is not a polygonmovearea")
		child.update_polygon_light(Room)
