extends CharacterBody2D

@export var _speed = 300.0
@export var _jump_velocity = -400.0
@export var limite_caida := 1000.0   # ← altura límite

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_velocity

	# Movimiento
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()

	# 👇 SI SE CAE → REINICIA
	if global_position.y > limite_caida:
		reiniciar_nivel()


func reiniciar_nivel():
	get_tree().reload_current_scene()
