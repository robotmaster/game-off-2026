extends Node2D

@export var color_1 : Polygon2D
@export var color_2 : Polygon2D

@export var intersection_static_body : StaticBody2D

func _ready() -> void:
	var polygon_1_global := color_1.global_transform * color_1.polygon
	color_1.polygon = polygon_1_global
	color_1.global_transform = Transform2D()
	var polygon_2_global := color_2.global_transform * color_2.polygon
	color_2.polygon = polygon_2_global
	color_2.global_transform = Transform2D()
	
	intersection_static_body.global_transform = Transform2D()
	intersection_static_body.global_transform = Transform2D()

func _physics_process(_delta: float) -> void:
	
	var polygon_1_global := color_1.global_transform * color_1.polygon
	var polygon_2_global := color_2.global_transform * color_2.polygon
	
	var overlap := Geometry2D.intersect_polygons(polygon_1_global, polygon_2_global)
	
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
