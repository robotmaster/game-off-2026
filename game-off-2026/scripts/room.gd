extends Node2D
class_name RoomRoot

@export var next_room : PackedScene

@export_group("Don't Touch")
@export var color_1_parent : Node2D
@export var color_2_parent : Node2D
@export var color_3_parent : Node2D

@export var intersection_static_body : StaticBody2D

var polygon_editing := 1
var is_editing := false

func _ready() -> void:
	
	for polygon_2d : Polygon2D in get_children_polygons(color_1_parent):
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
	
	for polygon_2d : Polygon2D in get_children_polygons(color_2_parent):
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
		
	for polygon_2d : Polygon2D in get_children_polygons(color_3_parent):
		var polygon_global := polygon_2d.global_transform * polygon_2d.polygon
		polygon_2d.polygon = polygon_global
		polygon_2d.global_transform = Transform2D()
	
	intersection_static_body.global_transform = Transform2D()
	intersection_static_body.global_transform = Transform2D()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_edit"):
		polygon_editing += 1
		if polygon_editing > 3:
			polygon_editing = 1
	if Input.is_action_just_pressed("reset"):
		reset_room()
	
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
	
	for polygon_1 in get_children_polygons(color_1_parent):
		for polygon_2 in get_children_polygons(color_2_parent):
			for polygon_3 in get_children_polygons(color_3_parent):
				var global_polygon_1 := polygon_1.global_transform * polygon_1.polygon
				var global_polygon_2 := polygon_2.global_transform * polygon_2.polygon
				var global_polygon_3 := polygon_3.global_transform * polygon_3.polygon
				
				var first_overlap := Geometry2D.intersect_polygons(global_polygon_1, global_polygon_2)
				for overlap_polygon in first_overlap:
					var all_overlap := Geometry2D.intersect_polygons(overlap_polygon, global_polygon_3)
					for overlap_region in all_overlap:
						overlap.append(overlap_region)
	
	return overlap



func get_children_polygons(parent: Node2D) -> Array[Polygon2D]:
	var children := []
	
	for child in parent.get_children():
		assert(child is Polygon2D, "Child is not polygon2D")
		children.append(child)
	return children


func get_current_polygon_editing() -> Node2D:
	if not is_editing:
		return null
	match polygon_editing:
		1:
			return color_1_parent
		2:
			return color_2_parent
		3:
			return color_3_parent
	return null

func toggle_editing() -> void:
	is_editing = not is_editing

func reset_room() -> void:
	get_tree().reload_current_scene()

func go_to_next_room() -> void:
	get_tree().change_scene_to_packed(next_room)
