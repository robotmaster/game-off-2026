extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -250.0

const FLOOR_GRAVITY_MULT = 4
const DOWNWARD_GRAVITY_MULT = 1.2

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity = get_gravity() * delta * FLOOR_GRAVITY_MULT
	elif velocity.y > 0:
		velocity += get_gravity() * delta * DOWNWARD_GRAVITY_MULT
	else:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
