extends Area2D


func _ready() -> void:
	var children := %Visuals.get_children()
	for child in children:
		if not child is Polygon2D:
			print("Child not polygon 2d")
		
		var new_collision_polygon := CollisionPolygon2D.new()
		new_collision_polygon.polygon = child.transform * child.polygon
		add_child(new_collision_polygon)
