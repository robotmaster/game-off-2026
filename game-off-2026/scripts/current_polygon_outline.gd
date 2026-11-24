extends Node2D

@export var Room : RoomRoot

#const POLYGON_OUTLINE_COLOR_MULT = Color(0.6, 0.6, 0.6, 0.4)
#const POLYGON_OUTLINE_COLOR_ADD = Color(0.3, 0.3, 0.3, 0)
const POLYGON_OUTLINE_WIDTH = 2.0

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var current_editing := Room.get_current_polygon_editing()
	if current_editing == null:
		return
	
	
	for polygon_2d : Polygon2D in current_editing.get_children():
			
		var polygon_array := polygon_2d.global_transform * polygon_2d.polygon
		
		var polygon_outline := PolygonTools.make_inwawrd_outline_of_polygon(polygon_array, POLYGON_OUTLINE_WIDTH)
		draw_colored_polygon(polygon_outline, polygon_2d.color)
		
		#draw_colored_polygon(polygon_outline, POLYGON_OUTLINE_COLOR_MULT * polygon_2d.color + POLYGON_OUTLINE_COLOR_ADD)
