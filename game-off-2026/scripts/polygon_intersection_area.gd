extends Polygon2D

const POLYGON_OUTLINE_WIDTH = 2
const OUTLINE_COLOR = Color(0.3, 0.3, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	return
	var polygon_array := global_transform * polygon
		
	var polygon_outline := PolygonTools.make_inwawrd_outline_of_polygon(polygon_array, POLYGON_OUTLINE_WIDTH)
	
	draw_colored_polygon(polygon_outline, OUTLINE_COLOR)
