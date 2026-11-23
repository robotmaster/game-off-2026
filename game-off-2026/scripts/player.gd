extends CharacterBody2D

@export var Room : RoomRoot
@export var Exit : Area2D
@export var PolygonMoveArea: Area2D

const SPEED = 170.0
const JUMP_VELOCITY = -210.0

const FLOOR_GRAVITY_MULT = 4
const DOWNWARD_GRAVITY_MULT = 1.2
const JUMP_STOP_SPEED_CUT := 1.8

var _holding_jump_after_jump := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_play"):
		var space_state := get_world_2d().direct_space_state
		if PolygonTools.is_colliding_with_area_currently(space_state, %Collision, PolygonMoveArea):
			Room.toggle_editing()
	
	if not Room or Room.is_editing:
		return
	
	if test_move(global_transform, Vector2.ZERO):
		return
	
	_handle_win()
	
	if not Input.is_action_pressed("up") or is_on_ceiling():
		_holding_jump_after_jump = false
		%JumpBoostingTimer.stop()
	
	
	if is_on_floor():
		velocity = get_gravity() * delta * FLOOR_GRAVITY_MULT
	elif velocity.y > 0:
		velocity += get_gravity() * delta * DOWNWARD_GRAVITY_MULT
	else:
		if not _holding_jump_after_jump:
			velocity += get_gravity() * delta * JUMP_STOP_SPEED_CUT
		else:
			velocity += get_gravity() * delta
	
	if is_on_floor():
		%CoyoteTimer.start()
	if Input.is_action_just_pressed("up"):
		%JumpBufferTimer.start()
	
	if not %JumpBufferTimer.is_stopped() and not %CoyoteTimer.is_stopped():
		%JumpBufferTimer.stop()
		%JumpBoostingTimer.start()
		_holding_jump_after_jump = true
	if not %JumpBoostingTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
	
	_handle_horizontal_movement(delta)
	move_and_slide()

func _handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _handle_win() -> void:
	if Exit.overlaps_body(self):
		if is_on_floor():
			Room.go_to_next_room()
