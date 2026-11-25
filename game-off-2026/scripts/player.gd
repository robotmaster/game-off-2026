extends CharacterBody2D
class_name PlayerClass

@export var Room : RoomRoot
@export var Exit : Area2D
@export var PolygonMoveArea: Area2D

@onready var hitbox : CollisionShape2D = $Collision

const SPEED = 170.0
const JUMP_VELOCITY = -210.0

const FLOOR_GRAVITY_MULT = 4
const DOWNWARD_GRAVITY_MULT = 1.2
const JUMP_STOP_SPEED_CUT := 1.8

var _holding_jump_after_jump := false

var is_locked := false

const LOCKED_FLASH_SPEED = 0.08
@export var locked_flash_color : Color
var locked_flash_timer := 0.0

func _physics_process(delta: float) -> void:
	$PointLight2D.visible = true
	if not Room or Room.is_editing:
		is_locked = true
		velocity = Vector2()
		return
	
	if test_move(global_transform, Vector2.ZERO):
		return
	
	_handle_win()
	
	if not Input.is_action_pressed("up") or is_on_ceiling():
		_holding_jump_after_jump = false
		%JumpBoostingTimer.stop()
	
	
	if is_on_floor():
		is_locked = false
		velocity = get_gravity() * delta * FLOOR_GRAVITY_MULT
	elif velocity.y > 0:
		velocity += get_gravity() * delta * DOWNWARD_GRAVITY_MULT
	else:
		if not is_locked and not _holding_jump_after_jump:
			velocity += get_gravity() * delta * JUMP_STOP_SPEED_CUT
		else:
			velocity += get_gravity() * delta
	
	if is_on_floor():
		%CoyoteTimer.start()
	if Input.is_action_just_pressed("up"):
		%JumpBufferTimer.start()
	
	if not is_locked and not %JumpBufferTimer.is_stopped() and not %CoyoteTimer.is_stopped():
		%JumpBufferTimer.stop()
		%JumpBoostingTimer.start()
		_holding_jump_after_jump = true
	if not is_locked and not %JumpBoostingTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
	
	if not is_locked:
		_handle_horizontal_movement(delta)
	move_and_slide()
	
	if is_locked:
		locked_flash_timer += delta
		if fmod(locked_flash_timer, LOCKED_FLASH_SPEED * 2) < LOCKED_FLASH_SPEED:
			modulate = locked_flash_color
		else:
			modulate = Color(1, 1, 1)
	else:
		locked_flash_timer = 0
		modulate = Color(1, 1, 1)

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
