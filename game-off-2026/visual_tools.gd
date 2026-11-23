extends Node

var light_to_subviewport := {
}

var subviewport_to_texture := {
	
}

var shader_material : ShaderMaterial

func _ready() -> void:
	shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/polygon_glow.gdshader")

func setup_polygon_light(light: PointLight2D) -> SubViewport:
	
	light.global_transform = Transform2D()
	var new_subviewport := SubViewport.new()
	
	new_subviewport.size = get_viewport().get_visible_rect().size
	
	
	var image : Image = new_subviewport.get_texture().get_image()
	
	var light_texture := ImageTexture.create_from_image(image)
	light_texture.set_size_override(get_viewport().get_visible_rect().size)
	
	light.texture = light_texture
	
	light_to_subviewport[light] = new_subviewport
	subviewport_to_texture[new_subviewport] = light_texture
	
	new_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	var filled_polygons_parent := Node2D.new()
	filled_polygons_parent.name = "Polygon Parent"
	
	var new_color_rect := ColorRect.new()
	new_color_rect.name = "Glow Shader"
	new_color_rect.material = shader_material
	new_color_rect.size = get_viewport().get_visible_rect().size
	
	new_subviewport.add_child(new_color_rect)
	new_subviewport.add_child(filled_polygons_parent)
	
	get_tree().current_scene.add_child.call_deferred(new_subviewport)
	
	return new_subviewport


func update_polygon_light(light: PointLight2D, polygons: Array[PackedVector2Array], light_fade_mult: float) -> void:
	var subviewport : SubViewport = light_to_subviewport[light]
	
	var children := subviewport.get_node("Polygon Parent").get_children()
	for child in children:
		child.queue_free()
	
	var node_with_shader : CanvasItem = subviewport.get_node("Glow Shader")
	
	var polygon_edges : PackedVector2Array = []
	
	for polygon in polygons:
		var new_polygon_2d := Polygon2D.new()
		
		new_polygon_2d.polygon = polygon
		new_polygon_2d.position = get_viewport().get_visible_rect().size / 2
		
		subviewport.get_node("Polygon Parent").add_child(new_polygon_2d)
		
		for point_index in range(len(polygon)):
			var next_index := point_index + 1
			if next_index >= len(polygon):
				next_index = 0
			polygon_edges.append(polygon[point_index] + get_viewport().get_visible_rect().size / 2)
			polygon_edges.append(polygon[next_index] + get_viewport().get_visible_rect().size / 2)
	
	var texture_width := 32 * 2
	var height : int = (len(polygon_edges) / texture_width) + 1
	
	while len(polygon_edges) < texture_width * height:
		polygon_edges.append(Vector2(9999999, 9999999))
		polygon_edges.append(Vector2(9999999, 9999999))
	
	var new_image := Image.create_from_data(
		texture_width, height, false, Image.FORMAT_RGF, polygon_edges.to_byte_array()
	)
	
	var texture := ImageTexture.create_from_image(new_image)
	
	node_with_shader.material.set_shader_parameter("polygon_edges", texture)
	node_with_shader.material.set_shader_parameter("light_fade_mult", light_fade_mult)

func _process(_delta: float) -> void:
	for light : PointLight2D in light_to_subviewport.keys():
		var subviewport = light_to_subviewport[light]
		if not is_instance_valid(light) or not is_instance_valid(subviewport):
			subviewport_to_texture.erase(subviewport)
			light_to_subviewport.erase(light)
	
	for subviewport in subviewport_to_texture.keys():
		var light_texture = subviewport_to_texture[subviewport]
		
		var image : Image = subviewport.get_texture().get_image()
		image.save_png("user://a.png")
		
		light_texture.set_image(image)
