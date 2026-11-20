@tool
extends Node2D

func _process(delta: float) -> void:
	for polygon in %Red.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.RED
	for polygon in %Blue.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.BLUE
	for polygon in %Green.get_children():
		if polygon is Polygon2D:
			polygon.use_parent_material = true
			polygon.color = Color.GREEN
