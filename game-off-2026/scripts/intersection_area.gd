extends Node2D

@export var Room : RoomRoot

const INTERSECTION_AREA = preload("res://scenes/polygon_intersection_area.tscn")

func _ready() -> void:
	$CollisionsAndVisuals.global_transform = Transform2D()
	$Light.global_transform = Transform2D()

func do_polygon_collisions() -> void:
	
	var overlap := _get_overlap_in_polygons()
	
	var children := $CollisionsAndVisuals.get_children()
	for child in children:
		child.queue_free()
	
	children = $SubViewport.get_children()
	for child in children:
		child.queue_free()
		
	
	for polygon_shape in overlap:
		var new_intersection_area = INTERSECTION_AREA.instantiate()
		new_intersection_area.polygon = polygon_shape
		$CollisionsAndVisuals.add_child(new_intersection_area)
		
		var new_collision := CollisionPolygon2D.new()
		new_collision.polygon = polygon_shape
		$CollisionsAndVisuals.add_child(new_collision)
		
	#intersection_polygon.polygon = intersection_polygon.global_transform.affine_inverse() * overlap[0]



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
