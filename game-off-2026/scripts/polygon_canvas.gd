extends CanvasGroup

@export var Room : RoomRoot

const EDITING_ALPHA = 0.8
const PLAYING_ALPHA = 0.5

func _process(_delta: float) -> void:
	if Room.is_editing:
		material.set_shader_parameter("alpha", EDITING_ALPHA)
	else:
		material.set_shader_parameter("alpha", PLAYING_ALPHA)
