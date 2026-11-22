extends Node2D

@export var Room : RoomRoot

const CENTER_LINE_LENGTH = 5
const CENTER_LINE_WIDTH = 2
const CENTER_LINE_COLOR_MULT = Color(0.5, 0.5, 0.5, 0.8)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var polygons_to_draw = [Room.color_1_parent, Room.color_2_parent, Room.color_3_parent]
	
	for polygon_parent : PolygonParent in polygons_to_draw:
		var centroid_global := polygon_parent.get_centroid()
		
		var up := centroid_global + Vector2(0, CENTER_LINE_LENGTH)
		var down := centroid_global + Vector2(0, -CENTER_LINE_LENGTH)
		var left := centroid_global + Vector2(-CENTER_LINE_LENGTH, 0)
		var right := centroid_global + Vector2(CENTER_LINE_LENGTH, 0)
		
		draw_line(up, down, polygon_parent.color * CENTER_LINE_COLOR_MULT, CENTER_LINE_WIDTH)
		draw_line(left, right, polygon_parent.color * CENTER_LINE_COLOR_MULT, CENTER_LINE_WIDTH)
