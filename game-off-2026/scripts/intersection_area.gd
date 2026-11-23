extends Node2D

@export var Room : RoomRoot

const INTERSECTION_POLYGON_COLOR = 1000

const LIGHT_FADE_DIST = 20.0
const LIGHT_FADE_MULT = 0.8
const LIGHT_POLYGON_SAMPLE_INTERVAL = 0.25

var light_texture : ImageTexture

#const INTERSECTION_AREA = preload("res://scenes/polygon_intersection_area.tscn")

func _ready() -> void:
	$CollisionsAndVisuals.global_transform = Transform2D()
	$Light.global_transform = Transform2D()
	$SubViewport.size = get_viewport_rect().size
	
	
	var image : Image = $SubViewport.get_texture().get_image()
	
	light_texture = ImageTexture.create_from_image(image)
	light_texture.set_size_override(get_viewport_rect().size)
	
	$Light.texture = light_texture

func do_polygon_collisions() -> void:
	
	var overlap := _get_overlap_in_polygons()
	
	var children := $CollisionsAndVisuals.get_children()
	for child in children:
		child.queue_free()
	
	children = $SubViewport.get_children()
	for child in children:
		child.queue_free()
		
	
	for polygon_shape in overlap:
		var new_intersection_area := Polygon2D.new()
		new_intersection_area.polygon = polygon_shape
		new_intersection_area.color = Color(INTERSECTION_POLYGON_COLOR, INTERSECTION_POLYGON_COLOR, INTERSECTION_POLYGON_COLOR, 1)
		
		$CollisionsAndVisuals.add_child(new_intersection_area)
		
		var new_collision := CollisionPolygon2D.new()
		new_collision.polygon = polygon_shape
		$CollisionsAndVisuals.add_child(new_collision)
		
		_setup_light_areas_for_polygon(polygon_shape)
		
		
func _setup_light_areas_for_polygon(polygon_shape : PackedVector2Array) -> void:
	
	var offset_dist := 0.0
	while offset_dist < LIGHT_FADE_DIST:
		var offset_shape := Geometry2D.offset_polygon(polygon_shape, offset_dist, Geometry2D.PolyJoinType.JOIN_ROUND)
		
		var light_area := Polygon2D.new()
		light_area.position = get_viewport_rect().size / 2
		light_area.polygon = offset_shape[0]
		
		
		var polygon_color := LIGHT_FADE_MULT ** offset_dist
		light_area.color = Color(polygon_color, polygon_color, polygon_color, 1)
		$SubViewport.add_child(light_area)
		$SubViewport.move_child(light_area, 0)
		
		
		offset_dist += LIGHT_POLYGON_SAMPLE_INTERVAL


func _get_overlap_in_polygons() -> Array[PackedVector2Array]:
	var overlap : Array[PackedVector2Array] = []
	
	for polygon_1 in Room.get_children_polygons(Room.color_1_parent):
		for polygon_2 in Room.get_children_polygons(Room.color_2_parent):
			for polygon_3 in Room.get_children_polygons(Room.color_3_parent):
				var global_polygon_1 := polygon_1.global_transform * polygon_1.polygon
				var global_polygon_2 := polygon_2.global_transform * polygon_2.polygon
				var global_polygon_3 := polygon_3.global_transform * polygon_3.polygon
				
				var first_overlap := Geometry2D.intersect_polygons(global_polygon_1, global_polygon_2)
				for overlap_polygon in first_overlap:
					var all_overlap := Geometry2D.intersect_polygons(overlap_polygon, global_polygon_3)
					for overlap_region in all_overlap:
						overlap.append(overlap_region)
	
	return overlap

func _process(delta: float) -> void:
	var image : Image = $SubViewport.get_texture().get_image()
	image.save_png("user://a.png")
	light_texture.set_image(image)
