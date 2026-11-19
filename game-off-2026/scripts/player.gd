extends CharacterBody2D

@export var Room : RoomRoot

const SPEED = 180.0
const JUMP_VELOCITY = -200.0

const FLOOR_GRAVITY_MULT = 4
const DOWNWARD_GRAVITY_MULT = 1.2
const JUMP_STOP_SPEED_CUT := 1.8

var _holding_jump_after_jump := false

func _physics_process(delta: float) -> void:
	if not Room or Room.polygon_editing != 0:
		return 
	
	if not Input.is_action_pressed("up"):
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
