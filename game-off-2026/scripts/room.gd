extends Node2D

@export var color_1 : Polygon2D
@export var color_2 : Polygon2D

@export var intersection_polygon : Polygon2D
@export var intersection_collision : CollisionPolygon2D

func _ready() -> void:
	# reset polygon transforms
	var polygon_1_global := color_1.global_transform * color_1.polygon
	color_1.polygon = polygon_1_global
	color_1.global_transform = Transform2D()
	var polygon_2_global := color_2.global_transform * color_2.polygon
	color_2.polygon = polygon_2_global
	color_2.global_transform = Transform2D()
	
	intersection_polygon.global_transform = Transform2D()
	intersection_collision.global_transform = Transform2D()

func _physics_process(delta: float) -> void:
	
	var polygon_1_global := color_1.global_transform * color_1.polygon
	var polygon_2_global := color_2.global_transform * color_2.polygon
	
	var overlap := Geometry2D.intersect_polygons(polygon_1_global, polygon_2_global)

	intersection_polygon.polygon = intersection_polygon.global_transform.affine_inverse() * overlap[0]
