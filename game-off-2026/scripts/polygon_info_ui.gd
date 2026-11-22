extends Node2D

@export var Room : RoomRoot

var OFF_MODULATE = Color(0.5, 0.3, 0.3)

func _process(delta: float) -> void:
	if not Room.is_editing:
		visible = false
		return
	visible = true
	
	var current_polygon_selected := Room.get_current_polygon_editing()
	
	$ColorFill.color = current_polygon_selected.color
	$WhiteHighlight.visible = false
	
	if current_polygon_selected.moving_allowed:
		$Translate.modulate = Color(1, 1, 1)
		if Room.polygon_transform_editing == Room.PolygonTransforms.Translate:
			$WhiteHighlight.global_position = $Translate.global_position - $WhiteHighlight.size / 2
			$WhiteHighlight.visible = true
	else:
		$Translate.modulate = OFF_MODULATE
	
	if current_polygon_selected.rotating_allowed:
		$Rotate.modulate = Color(1, 1, 1)
		if Room.polygon_transform_editing == Room.PolygonTransforms.Rotate:
			$WhiteHighlight.global_position = $Rotate.global_position - $WhiteHighlight.size / 2
			$WhiteHighlight.visible = true
	else:
		$Rotate.modulate = OFF_MODULATE
	
	if current_polygon_selected.scaling_allowed:
		$Scale.modulate = Color(1, 1, 1)
		if Room.polygon_transform_editing == Room.PolygonTransforms.Scale:
			$WhiteHighlight.global_position = $Scale.global_position - $WhiteHighlight.size / 2
			$WhiteHighlight.visible = true
	else:
		$Scale.modulate = OFF_MODULATE
