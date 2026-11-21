extends Node2D

@export var Room : RoomRoot

const POLYGON_OUTLINE_COLOR = Color(0, 0, 0, 0.3)
const POLYGON_OUTLINE_WIDTH = 2.0

func _process(_delta: float) -> void:
	Geometry2D.clip_polygons()
	queue_redraw()

func _draw() -> void:
	var current_editing := Room.get_current_polygon_editing()
	if current_editing == null:
		return
	
	
	for polygon_2d : Polygon2D in current_editing.get_children():
		
		var polygon_array := polygon_2d.global_transform * polygon_2d.polygon
		$Polygon2D.polygon = polygon_array
		
		for offset_polygon in Geometry2D.offset_polygon(polygon_array, -3):
			draw_colored_polygon(offset_polygon, POLYGON_OUTLINE_COLOR)
