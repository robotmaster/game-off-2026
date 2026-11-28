extends Node2D

@export var Room : RoomRoot
@export var color_representing : Color
@export var node_representing : PolygonParent

const OFF_MODULATE = Color(0.5, 0.4, 0.4)
const PLAYING_MODULATE = Color(1, 1, 1, 0.6)
const EDITING_MODULATE = Color(1, 1, 1, 0.85)

@export var white_highlight_highest_alpha := 0.8

const WHITE_HIGHLIGHT_INTERPOLATE_TIME = 0.6
const WHITE_HIGHLIGHT_HOLD_TIME = 0.2

var transform_highlight_interpolate_timer := 0.0
var rotate_highlight_interpolate_timer := 0.0
var scale_highlight_interpolate_timer := 0.0

func _ready() -> void:
	Room.allowed_transformed_changed.connect.call_deferred(_flash_highlight)
	Room.editing_changed.connect.call_deferred(_flash_editing.call_deferred)

func _process(delta: float) -> void:
	if Room.is_editing:
		modulate = EDITING_MODULATE
	else:
		modulate = PLAYING_MODULATE
	
	
	
	$ColorFill.color = color_representing
	
	$Translate.modulate = OFF_MODULATE
	$Rotate.modulate = OFF_MODULATE
	$Scale.modulate = OFF_MODULATE
	
	$GreenHighlight.global_position = Vector2(999999, 999999)
	for allowed_transform_index in range(len(Room.allowed_polygon_transforms)):
		var allowed_transform = Room.allowed_polygon_transforms[allowed_transform_index]
		if allowed_transform["node"] != node_representing:
			continue
		
		if allowed_transform["transform"] == Room.PolygonTransforms.Translate:
			$Translate.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$GreenHighlight.position = $Translate.position - $GreenHighlight.size / 2
				$GreenHighlight.visible = true
		if allowed_transform["transform"] == Room.PolygonTransforms.Rotate:
			$Rotate.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$GreenHighlight.position = $Rotate.position - $GreenHighlight.size / 2
				$GreenHighlight.visible = true
		if allowed_transform["transform"] == Room.PolygonTransforms.Scale:
			$Scale.modulate = Color(1, 1, 1)
			if Room.is_editing and Room.transform_editing_index == allowed_transform_index:
				$GreenHighlight.position = $Scale.position - $GreenHighlight.size / 2
				$GreenHighlight.visible = true

	transform_highlight_interpolate_timer -= delta
	if transform_highlight_interpolate_timer > WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME:
		$WhiteHighlightTransform.modulate.a = white_highlight_highest_alpha
	elif transform_highlight_interpolate_timer > 0:
		$WhiteHighlightTransform.modulate.a = transform_highlight_interpolate_timer / (WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME) * white_highlight_highest_alpha
	else:
		$WhiteHighlightTransform.modulate.a = 0
	
	rotate_highlight_interpolate_timer -= delta
	if rotate_highlight_interpolate_timer > WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME:
		$WhiteHighlightRotate.modulate.a = white_highlight_highest_alpha
	if rotate_highlight_interpolate_timer > 0:
		$WhiteHighlightRotate.modulate.a = rotate_highlight_interpolate_timer / (WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME) * white_highlight_highest_alpha
	else:
		$WhiteHighlightRotate.modulate.a = 0
	
	scale_highlight_interpolate_timer -= delta
	if scale_highlight_interpolate_timer > WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME:
		$WhiteHighlightScale.modulate.a = white_highlight_highest_alpha
	elif scale_highlight_interpolate_timer > 0:
		$WhiteHighlightScale.modulate.a = scale_highlight_interpolate_timer / (WHITE_HIGHLIGHT_INTERPOLATE_TIME - WHITE_HIGHLIGHT_HOLD_TIME) * white_highlight_highest_alpha
	else:
		$WhiteHighlightScale.modulate.a = 0

	

func _flash_highlight() -> void:
	for allowed_transform in Room.allowed_polygon_transforms:
		if allowed_transform["node"] != node_representing:
			continue
		
		if allowed_transform["transform"] == Room.PolygonTransforms.Translate:
			transform_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME
		if allowed_transform["transform"] == Room.PolygonTransforms.Rotate:
			rotate_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME
		if allowed_transform["transform"] == Room.PolygonTransforms.Scale:
			scale_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME

func _flash_editing() -> void:
	var transform_editing : Dictionary = Room.allowed_polygon_transforms[Room.transform_editing_index]
	if transform_editing["node"] != node_representing:
		return
	
	if transform_editing["transform"] == Room.PolygonTransforms.Translate:
		transform_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME
	
	if transform_editing["transform"] == Room.PolygonTransforms.Rotate:
		rotate_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME
	
	if transform_editing["transform"] == Room.PolygonTransforms.Scale:
		scale_highlight_interpolate_timer = WHITE_HIGHLIGHT_INTERPOLATE_TIME
