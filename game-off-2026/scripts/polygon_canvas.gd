extends CanvasGroup

@export var Room : RoomRoot

const EDITING_ALPHA = 0.7
const PLAYING_ALPHA = 0.3

var time := 0.0

func _process(delta: float) -> void:
	time += delta
	material.set_shader_parameter("time", time)
	if Room.is_editing:
		material.set_shader_parameter("alpha", EDITING_ALPHA)
	else:
		material.set_shader_parameter("alpha", PLAYING_ALPHA)
