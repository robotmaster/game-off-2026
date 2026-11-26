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

const EDITING_LIGHT_ENERGY = 0.2
const PLAYING_LIGHT_ENERGY = 0.6
#const LIGHT_SPREAD = 0.98

const MAX_SAVES = 5

var last_on_floor_spot := Vector2()

var saved_jumps : Array[Dictionary]

func _revert_jump() -> void:
	var saved_info : Dictionary = saved_jumps.pop_back()
	%JumpBoostingTimer.stop()
	%JumpBufferTimer.stop()
	%CoyoteTimer.stop()
	velocity = Vector2(0, 0)
	global_position = saved_info["player_pos"]
	Room.color_1_parent.global_position = saved_info["red_info"]["pos"]
	Room.color_1_parent.global_rotation = saved_info["red_info"]["rot"]
	Room.color_1_parent.global_scale = saved_info["red_info"]["scale"]
	Room.color_2_parent.global_position = saved_info["green_info"]["pos"]
	Room.color_2_parent.global_rotation = saved_info["green_info"]["rot"]
	Room.color_2_parent.global_scale = saved_info["green_info"]["scale"]
	Room.color_3_parent.global_position = saved_info["blue_info"]["pos"]
	Room.color_3_parent.global_rotation = saved_info["blue_info"]["rot"]
	Room.color_3_parent.global_scale = saved_info["blue_info"]["scale"]

func _physics_process(delta: float) -> void:
	$PointLight2D.visible = true
	if Room.is_editing:
		$PointLight2D.energy = EDITING_LIGHT_ENERGY
	else:
		$PointLight2D.energy = PLAYING_LIGHT_ENERGY
	
	if VisualTools.transitioning:
		velocity = Vector2(0, 0)
		return
	
	if Input.is_action_just_pressed("revert_jump") and not Room.is_editing and len(saved_jumps) > 0:
		VisualTools.start_out_transition(true, _revert_jump)
		return
	
	
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
		last_on_floor_spot = global_position
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
		saved_jumps.append({
			"player_pos": last_on_floor_spot,
			"red_info": {
				"pos": Room.color_1_parent.global_position,
				"rot": Room.color_1_parent.global_rotation,
				"scale": Room.color_1_parent.global_scale,
			},
			"green_info": {
				"pos": Room.color_2_parent.global_position,
				"rot": Room.color_2_parent.global_rotation,
				"scale": Room.color_2_parent.global_scale,
			},
			"blue_info": {
				"pos": Room.color_3_parent.global_position,
				"rot": Room.color_3_parent.global_rotation,
				"scale": Room.color_3_parent.global_scale,
			}
		})
		if len(saved_jumps) > MAX_SAVES:
			saved_jumps.pop_front()
		
		%JumpBufferTimer.stop()
		%JumpBoostingTimer.start()
		_holding_jump_after_jump = true
	if not is_locked and not %JumpBoostingTimer.is_stopped():
		%CoyoteTimer.stop()
		velocity.y = JUMP_VELOCITY
	
	if not is_locked:
		_handle_horizontal_movement(delta)
	
	#move_and_slide()
	var saved := velocity
	velocity.y = 0
	move_and_slide()
	velocity.y = saved.y
	velocity.x = 0
	move_and_slide()
	velocity.x = saved.x
	
	if is_locked:
		locked_flash_timer += delta
		if fmod(locked_flash_timer, LOCKED_FLASH_SPEED * 2) < LOCKED_FLASH_SPEED:
			modulate = locked_flash_color
		else:
			modulate = Color(1, 1, 1)
	else:
		locked_flash_timer = 0
		modulate = Color(1, 1, 1)
	
	#var light_poly : Array[PackedVector2Array]= [[
		#global_position + Vector2(0, 0.1),
		#global_position + Vector2(0, -0.1),
		#global_position + Vector2(0.1, 0),
		#global_position + Vector2(-0.1, 0),
	#]]
	#if Room.is_editing:
		#VisualTools.add_polygon_light(light_poly, EDITING_LIGHT_ENERGY, LIGHT_SPREAD)
	#else:
		#VisualTools.add_polygon_light(light_poly, PLAYING_LIGHT_ENERGY, LIGHT_SPREAD)

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
