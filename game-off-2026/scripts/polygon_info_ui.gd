extends Node2D

@export var Room : RoomRoot
@export var color_representing : Color
@export var node_representing : PolygonParent

const OFF_MODULATE = Color(0.4, 0.2, 0.2)
const PLAYING_MODULATE = Color(1, 1, 1, 0.4)
const EDITING_MODULATE = Color(1, 1, 1, 0.7)

func _process(delta: float) -> void:
	if Room.is_editing:
		modulate = EDITING_MODULATE
	else:
		modulate = PLAYING_MODULATE
	#
	#
	$ColorFill.color = color_representing
	
	$Translate.modulate = OFF_MODULATE
	$Rotate.modulate = OFF_MODULATE
	$Scale.modulate = OFF_MODULATE
	
	$WhiteHighlight.global_position = Vector2(999999, 999999)
	for allowed_transform_index in range(len(Room.allowed_polygon_transforms)):
		var allowed_transform = Room.allowed_polygon_transforms[allowed_transform_index]
		if allowed_transform["node"] != node_representing:
			continue
		
		if allowed_transform["transform"] == Room.PolygonTransforms.Translate:
			$Translate.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$WhiteHighlight.position = $Translate.position - $WhiteHighlight.size / 2
				$WhiteHighlight.visible = true
		if allowed_transform["transform"] == Room.PolygonTransforms.Rotate:
			$Rotate.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$WhiteHighlight.position = $Rotate.position - $WhiteHighlight.size / 2
				$WhiteHighlight.visible = true
		if allowed_transform["transform"] == Room.PolygonTransforms.Scale:
			$Scale.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$WhiteHighlight.position = $Scale.position - $WhiteHighlight.size / 2
				$WhiteHighlight.visible = true
