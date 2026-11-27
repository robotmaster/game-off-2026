extends Area2D
class_name TriggerHint

var hint_timer := 0.0
var current_hint_node : Node2D = null
var current_hint_start_pos : Vector2

@export var original_hint_position : Vector2

@export var spawn_hint_time := 4.5
var spawn_hint_timer := 2.0
var spawn_hint_initial_value := 2.0


@export var hint_fade_in := 0.3
@export var hint_stay := 1.2
@export var hint_fade := 0.6

@export var hint_move_up_start := 1.5
@export var hint_move_up_speed := 12.0

func _ready() -> void:
	assert(is_instance_valid($Hint), "hint doesn't exist inside trigger hint")
	$Hint.visible = false
	original_hint_position = $Hint.global_position
	inherit_ready()

func inherit_ready() -> void:
	pass

func _process(delta: float) -> void:
	hint_timer += delta
	override_hint_behavior(delta)
	
	if not is_instance_valid(current_hint_node):
		return
	
	if hint_timer < hint_fade_in:
		current_hint_node.modulate.a = hint_timer / hint_fade_in
	elif hint_timer < hint_fade_in + hint_stay:
		current_hint_node.modulate.a = 1
	elif hint_timer < hint_fade_in + hint_stay + hint_fade:
		current_hint_node.modulate.a = 1 - (hint_timer - hint_stay - hint_fade_in) / hint_fade
	else:
		current_hint_node.queue_free()
	
	if hint_timer < hint_move_up_start:
		current_hint_node.global_position = current_hint_start_pos
	else:
		current_hint_node.global_position = current_hint_start_pos + Vector2(0, -1) * hint_move_up_speed * (hint_timer - hint_move_up_start)

func override_hint_behavior(delta: float) -> void:
	override_hint_time_increment(delta)
	
	if spawn_hint_timer > spawn_hint_time:
		spawn_hint(override_hint_spawn_pos())
		spawn_hint_timer -= spawn_hint_time

func override_hint_spawn_pos() -> Vector2:
	return original_hint_position

func override_hint_time_increment(delta: float) -> void:
	if overlaps_body(get_node("../Player")):
		spawn_hint_timer += delta
	else:
		spawn_hint_timer = spawn_hint_initial_value

func spawn_hint(hint_position: Vector2) -> void:
	if is_instance_valid(current_hint_node):
		current_hint_node.queue_free()
	
	current_hint_node = $Hint.duplicate()
	current_hint_node.visible = true
	
	add_child(current_hint_node)
	current_hint_node.global_position = hint_position
	
	current_hint_start_pos = hint_position
	hint_timer = 0
