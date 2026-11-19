extends Node2D
class_name RoomRoot

@export var color_1_parent : Node2D
@export var color_2_parent : Node2D
@export var color_3_parent : Node2D

@export var intersection_static_body : StaticBody2D

var _color_1_polygons : Array[Polygon2D]
var _color_2_polygons : Array[Polygon2D]
var _color_3_polygons : Array[Polygon2D]

var polygon_editing := 0

func _ready() -> void:
	_get_children_polygons()
	
	for polygon_2d : Polygon2D in _color_1_polygons:
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
	
	for polygon_2d : Polygon2D in _color_2_polygons:
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
		
	for polygon_2d : Polygon2D in _color_3_polygons:
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
	
	intersection_static_body.global_transform = Transform2D()
	intersection_static_body.global_transform = Transform2D()

func _get_children_polygons() -> void:
	for child in color_1_parent.get_children():
		assert(child is Polygon2D, "Child is not polygon2D")
		_color_1_polygons.append(child)
	
	for child in color_2_parent.get_children():
		assert(child is Polygon2D, "Child is not polygon2D")
		_color_2_polygons.append(child)
	
	for child in color_3_parent.get_children():
		assert(child is Polygon2D, "Child is not polygon2D")
		_color_3_polygons.append(child)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_edit"):
		polygon_editing += 1
		if polygon_editing > 3:
			polygon_editing = 0
	_calculate_polygon_collisions()

func _calculate_polygon_collisions() -> void:
	
	var overlap := _get_overlap_in_polygons()
	
	var children := intersection_static_body.get_children()
	for child in children:
		child.queue_free()
	for polygon_shape in overlap:
		var new_polygon_2d := Polygon2D.new()
		new_polygon_2d.polygon = polygon_shape
		intersection_static_body.add_child(new_polygon_2d)
		
		var new_collision := CollisionPolygon2D.new()
		new_collision.polygon = polygon_shape
		intersection_static_body.add_child(new_collision)
		
	#intersection_polygon.polygon = intersection_polygon.global_transform.affine_inverse() * overlap[0]

func _get_overlap_in_polygons() -> Array[PackedVector2Array]:
	var overlap : Array[PackedVector2Array] = []
	
	for polygon_1 in _color_1_polygons:
		for polygon_2 in _color_2_polygons:
			for polygon_3 in _color_3_polygons:
				var global_polygon_1 := polygon_1.global_transform * polygon_1.polygon
				var global_polygon_2 := polygon_2.global_transform * polygon_2.polygon
				var global_polygon_3 := polygon_3.global_transform * polygon_3.polygon
				
				var first_overlap := Geometry2D.intersect_polygons(global_polygon_1, global_polygon_2)
				for overlap_polygon in first_overlap:
					var all_overlap := Geometry2D.intersect_polygons(overlap_polygon, global_polygon_3)
					for overlap_region in all_overlap:
						overlap.append(overlap_region)
	
	return overlap
