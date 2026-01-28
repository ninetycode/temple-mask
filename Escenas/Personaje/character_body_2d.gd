extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var mask_basic: Sprite2D = $AnimatedSprite2D/MaskBasic

@export var _speed = 300.0
@export var _jump_velocity = -400.0
@export var limite_caida := 800.0   # ← altura límite

var is_facing_right = true 
var is_interacting = false

var tiene_mascara = false
var saltos_realizados = 0

func _physics_process(delta: float) -> void:
	
	# Gravedad
	gravity(delta)
	#movimiento horizontal
	move_x()
	# Salto
	jump()
	# animacion de girar
	flip()
	#animaciones
	update_animatios()
	#fisicas
	move_and_slide()
	# 👇 SI SE CAE → REINICIA
	if global_position.y > limite_caida:
		reiniciar_nivel()


func gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func move_x():
	# Movimiento
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		

func jump():
	# si toca el suelo, tiene 2 saltos
	if is_on_floor():
		saltos_realizados = 0
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = _jump_velocity
			saltos_realizados += 1
		elif tiene_mascara and saltos_realizados < 2:
			velocity.y = _jump_velocity
			saltos_realizados += 1
		
	

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right


	
func update_animatios():
	if is_interacting:
		return
		
	#salto animacion
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	#correr animacion
	elif velocity.x:
		animated_sprite_2d.play("run")
	#idle animacion
	else:
		animated_sprite_2d.play("idle")
	

func reiniciar_nivel():
	get_tree().reload_current_scene()
	
func equip_mask():
	tiene_mascara = true
	mask_basic.show()
