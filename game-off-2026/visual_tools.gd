extends Node

var shader_material : ShaderMaterial
var polygons_to_draw : Array

var color_rect : ColorRect

func _ready() -> void:
	process_physics_priority = -1000
	process_priority = 1000
	shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/polygon_glow.gdshader")
	
	var viewport_size := get_viewport().get_visible_rect().size
	
	color_rect = ColorRect.new()
	color_rect.position = -viewport_size / 2
	color_rect.size = viewport_size
	color_rect.material = shader_material
	color_rect.z_index = 1000
	
	var back_buffer_copy := BackBufferCopy.new()
	back_buffer_copy.z_index = 1000
	back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	
	back_buffer_copy.add_child(color_rect)
	get_node("/root").add_child.call_deferred(back_buffer_copy)
	
func _physics_process(delta: float) -> void:
	polygons_to_draw = []

func add_polygon_light(polygon: PackedVector2Array, light_energy: float, light_fade_mult: float) -> void:
	polygons_to_draw.append(
		{
			"polygon": polygon,
			"energy": light_energy,
			"fade": light_fade_mult
		}
	)
	

func _process(_delta: float) -> void:
	
	var polygon_edges : PackedVector4Array = []
	
	for polygon_info : Dictionary in polygons_to_draw:
		var polygon : PackedVector2Array = polygon_info["polygon"]
		for point_index in range(len(polygon)):
			var point_pos := polygon[point_index] + get_viewport().get_visible_rect().size / 2
			polygon_edges.append(Vector4(point_pos.x, point_pos.y, polygon_info["energy"], polygon_info["fade"]))
		polygon_edges.append(Vector4(99999999999999, 99999999999999, 0, 0))
	
	var texture_width := 1 * 2
	var height : int = (len(polygon_edges) / texture_width) + 1
	
	while len(polygon_edges) < texture_width * height:
		polygon_edges.append(Vector4(99999999999999, 999999999999, 0, 0))
	
	var new_image := Image.create_from_data(
		texture_width, height, false, Image.FORMAT_RGBAF, polygon_edges.to_byte_array()
	)
	
	
	var texture := ImageTexture.create_from_image(new_image)
	
	
	color_rect.material.set_shader_parameter("polygon_edges", texture)
