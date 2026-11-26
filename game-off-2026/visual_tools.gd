extends Node

var polygons_to_draw : Array

var color_rect : ColorRect

var transition_effect : ColorRect

var transition_timer := 0.0

var transitioning_out := true
var transitioning := false

var automatically_start_in_transition := false
var to_run_on_transition : Callable

const TRANSITION_WAIT_TIME = 0.07

func _ready() -> void:
	process_physics_priority = -1000
	process_priority = 1000
	
	var polygon_light_shader_material := ShaderMaterial.new()
	polygon_light_shader_material.shader = load("res://shaders/polygon_glow.gdshader")
	
	var transition_shader := ShaderMaterial.new()
	transition_shader.shader = load("res://shaders/transition.gdshader")
	
	var viewport_size := get_viewport().get_visible_rect().size
	
	color_rect = ColorRect.new()
	color_rect.position = -viewport_size / 2
	color_rect.size = viewport_size
	color_rect.material = polygon_light_shader_material
	color_rect.z_index = 1000
	
	var back_buffer_copy := BackBufferCopy.new()
	back_buffer_copy.z_index = 1000
	back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	
	back_buffer_copy.add_child(color_rect)
	get_node("/root").add_child.call_deferred(back_buffer_copy)
	
	
	transition_effect = ColorRect.new()
	#transition_effect.position = -viewport_size / 2
	transition_effect.position = Vector2(0, 0)
	transition_effect.size = viewport_size
	transition_effect.material = transition_shader
	transition_effect.z_index = 2000
	
	#var transition_back_buffer_copy := BackBufferCopy.new()
	#transition_back_buffer_copy.z_index = 2000
	#transition_back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	
	#transition_back_buffer_copy.add_child(transition_effect)
	var new_canvas_layer := CanvasLayer.new()
	new_canvas_layer.layer = 1000
	
	new_canvas_layer.add_child(transition_effect)
	get_node("/root").add_child.call_deferred(new_canvas_layer)
	
func _physics_process(delta: float) -> void:
	polygons_to_draw = []

func add_polygon_light(polygon: Array[PackedVector2Array], light_energy: float, light_fade_mult: float) -> void:
	polygons_to_draw.append(
		{
			"polygons": polygon,
			"energy": light_energy,
			"fade": light_fade_mult
		}
	)

func _process(delta: float) -> void:
	_handle_transitioning(delta)
	
	var polygon_edges : PackedVector4Array = []
	
	for polygon_info : Dictionary in polygons_to_draw:
		var polygons : Array[PackedVector2Array] = polygon_info["polygons"]
		for polygon in polygons:
			for point_index in range(len(polygon)):
				var point_pos := polygon[point_index] + get_viewport().get_visible_rect().size / 2
				polygon_edges.append(Vector4(point_pos.x, point_pos.y, polygon_info["energy"], polygon_info["fade"]))
			polygon_edges.append(Vector4(99999999999999, 99999999999999, 0, 0))
		polygon_edges.append(Vector4(-99999999999999, -99999999999999, 0, 0))
	
	var texture_width := 1 * 2
	var height : int = (len(polygon_edges) / texture_width) + 1
	
	while len(polygon_edges) < texture_width * height:
		polygon_edges.append(Vector4(-99999999999999, -999999999999, 0, 0))
	
	var new_image := Image.create_from_data(
		texture_width, height, false, Image.FORMAT_RGBAF, polygon_edges.to_byte_array()
	)
	
	
	var texture := ImageTexture.create_from_image(new_image)
	
	
	color_rect.material.set_shader_parameter("polygon_edges", texture)

func _handle_transitioning(delta: float) -> void:
	transition_timer += delta
	
	var converted_time : float
	if transitioning_out:
		converted_time = transition_timer ** 4 * 1.9
	else:
		converted_time = (0.8477 + TRANSITION_WAIT_TIME - transition_timer) ** 4 * 1.9
	
	if transition_timer > 0.8477 + TRANSITION_WAIT_TIME:
		transitioning = false
		if transitioning_out and to_run_on_transition.is_valid():
			to_run_on_transition.call()
		if automatically_start_in_transition:
			start_in_transition()
	
	if transitioning or automatically_start_in_transition:
		transition_effect.material.set_shader_parameter("time", converted_time)
	else:
		transition_effect.material.set_shader_parameter("time", 0)

func start_out_transition(start_in_transition: bool, to_run: Callable = Callable()) -> void:
	if transitioning:
		return
	transitioning_out = true
	transitioning = true
	transition_timer = 0
	
	automatically_start_in_transition = start_in_transition
	to_run_on_transition = to_run

func start_in_transition() -> void:
	if transitioning:
		return
	transitioning_out = false
	transitioning = true
	transition_timer = 0
	automatically_start_in_transition = false
