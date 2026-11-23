extends Area2D

const LIGHT_FADE_MULT = 0.9;

func _ready() -> void:
	var children := %Visuals.get_children()
	for child in children:
		if not child is Polygon2D:
			print("Child not polygon 2d")
		
		var new_collision_polygon := CollisionPolygon2D.new()
		new_collision_polygon.polygon = child.transform * child.polygon
		add_child(new_collision_polygon)
	
	VisualTools.setup_polygon_light($Light)

func _process(delta: float) -> void:
	var all_polygons : Array[PackedVector2Array] = []
	var children := %Visuals.get_children()
	for child in children:
		all_polygons.append(child.global_transform * child.polygon)
	
	VisualTools.update_polygon_light($Light, all_polygons, LIGHT_FADE_MULT)
