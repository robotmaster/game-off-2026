extends Polygon2D

const POLYGON_OUTLINE_WIDTH = 2
const OUTLINE_COLOR = Color(0.3, 0.3, 0.3)

	
func _process(_delta: float) -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var image := Image.create_empty(viewport_size.x, viewport_size.y, false, Image.FORMAT_L8)
	
	image.fill_rect(Rect2(0, 0, 100, 100), Color.WHITE)
	
	%Light.texture = ImageTexture.create_from_image(image)
	
	queue_redraw()

func _draw() -> void:
	#draw_texture(%SubViewport.get_texture(), -get_viewport().get_visible_rect().size / 2)
	
	return
	#var polygon_array := global_transform * polygon
		
	#var polygon_outline := PolygonTools.make_inwawrd_outline_of_polygon(polygon_array, POLYGON_OUTLINE_WIDTH)
	
	#draw_colored_polygon(polygon_outline, OUTLINE_COLOR)
