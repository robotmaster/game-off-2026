@tool
extends CanvasGroup

@export var Room : RoomRoot
const POLYGON_MOVE_SPEED = 100

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	match Room.polygon_editing:
		1:
			_move_polygon($Red, delta)
		2:
			_move_polygon($Blue, delta)
		3:
			_move_polygon($Green, delta)

func _move_polygon(polygon_parent: Node2D, delta: float) -> void:
	polygon_parent.global_position += Input.get_vector("left", "right", "up", "down") * delta * POLYGON_MOVE_SPEED

func _process(delta: float) -> void:
	for polygon in $Red.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.RED
	for polygon in $Blue.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.BLUE
	for polygon in $Green.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.GREEN
