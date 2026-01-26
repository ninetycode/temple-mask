extends CharacterBody2D


@export var _speed = 300.0
@export var _jump_velocity = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_velocity

	# Get the input direction and handle the movement/deceleration.s
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()
