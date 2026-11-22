extends Node


func make_inwawrd_outline_of_polygon(polygon_array: PackedVector2Array, width: float) -> PackedVector2Array:
		
	var current_polygon_array := polygon_array.duplicate()
	for offset_polygon in Geometry2D.offset_polygon(polygon_array, -width):
		current_polygon_array = _cut_hole_in_polygon(current_polygon_array, offset_polygon)
	return current_polygon_array

func _cut_hole_in_polygon(original_polygon: PackedVector2Array, hole_polygon: PackedVector2Array) -> PackedVector2Array:
	if Geometry2D.is_polygon_clockwise(original_polygon) == Geometry2D.is_polygon_clockwise(hole_polygon):
		hole_polygon.reverse()
	
	var closest_original_point := 0
	var closest_hole_point := 0
	
	for original_point in range(original_polygon.size()):
		for new_point in range(hole_polygon.size()):
			var current_shortest_length := (original_polygon[closest_original_point] - hole_polygon[closest_hole_point]).length()
			var new_length := (original_polygon[original_point] - hole_polygon[new_point]).length()
			
			if new_length < current_shortest_length:
				closest_original_point = original_point
				closest_hole_point = new_point
	
	var new_polygon_array := PackedVector2Array()
	
	var starting_point := 0
	if closest_original_point == 0:
		starting_point = 1
	var is_on_outer_polygon := true
	var current_point := starting_point
	var seen_starting_point := false
	var just_switched_polygons := false
	
	while true:
		if is_on_outer_polygon:
			if current_point == starting_point:
				if seen_starting_point:
					break
				seen_starting_point = true
			new_polygon_array.append(original_polygon[current_point])
			if current_point == closest_original_point and not just_switched_polygons:
				just_switched_polygons = true
				is_on_outer_polygon = false
				current_point = closest_hole_point
			else:
				just_switched_polygons = false
				current_point += 1
				if current_point >= original_polygon.size():
					current_point = 0
		else:
			new_polygon_array.append(hole_polygon[current_point])
			if current_point == closest_hole_point and not just_switched_polygons:
				just_switched_polygons = true
				is_on_outer_polygon = true
				current_point = closest_original_point
			else:
				just_switched_polygons = false
				current_point += 1
				if current_point >= hole_polygon.size():
					current_point = 0
	return new_polygon_array
	
func is_colliding_with_area_currently(space_state: PhysicsDirectSpaceState2D, collision_shape : CollisionShape2D, area: Area2D) -> bool:
	var parameters := PhysicsShapeQueryParameters2D.new()
	parameters.shape = collision_shape.shape
	parameters.transform = collision_shape.global_transform
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = area.collision_layer
	for hit in space_state.intersect_shape(parameters):
		if hit.collider == area:
			return true
	return false

func get_polygon_centroid(polygons: Array[PackedVector2Array]) -> Vector2:
	var sum := Vector2()
	var divide_sum := 0.0
	for polygon in polygons:
		var indices := Geometry2D.triangulate_polygon(polygon)
		for index in range(0, indices, 3):
			var a := polygon[index]
			var b := polygon[index + 1]
			var c := polygon[index + 2]
			
	
	if divide_sum == 0:
		return Vector2()
	return sum / divide_sum
