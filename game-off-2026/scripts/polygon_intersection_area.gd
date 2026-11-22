extends Polygon2D

const POLYGON_OUTLINE_WIDTH = 2
const OUTLINE_COLOR = Color(0.3, 0.3, 0.3)

func _ready() -> void:
	%SubViewport.size = get_viewport().get_visible_rect().size
	%SubViewport/Poly.position = get_viewport().get_visible_rect().size / 2
	
func _process(_delta: float) -> void:

	%SubViewport/Poly.polygon = global_transform * polygon
	
	
	var viewport_texture : ViewportTexture = %SubViewport.get_texture()
	%Light.texture = viewport_texture.get_image()
	
	%Light.offset = -%Light.global_position
	
	print(%Light.offset)
	
	queue_redraw()

func _draw() -> void:
	#draw_texture(%SubViewport.get_texture(), -get_viewport().get_visible_rect().size / 2)
	
	return
	#var polygon_array := global_transform * polygon
		
	#var polygon_outline := PolygonTools.make_inwawrd_outline_of_polygon(polygon_array, POLYGON_OUTLINE_WIDTH)
	
	#draw_colored_polygon(polygon_outline, OUTLINE_COLOR)
