extends CharacterBody2D

@onready var inventory: Inventory = $Inventory
@onready var equiment_manager: Node = $EquimentManager

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var mascara_debug : ItemMascara
#--- STATS BASE ---------
@export var _speed = 300.0
@export var _jump_velocity = -400.0
@export var limite_caida := 800.0 
@export var max_saltos_base : int

#----STATS ACTUALES -----
var max_saltos_actuales : int = 1
var saltos_realizados : int = 0

#-------MASCARA EQUIPADA------
var mascara_equipada : ItemMascara = null

var is_facing_right = true 

func _ready():
	inventory.item_agregado.connect(_on_item_agregado_al_inventario)
	recalcular_stats()
	

func _on_item_agregado_al_inventario(nuevo_item : ItemData):
	if nuevo_item is ItemMascara:
		print("es una mascara! equipando automaticamente")
		equiment_manager.equipar_mascara(nuevo_item)
	# Aca a futuro podés poner:
	# elif nuevo_item is ItemArma:
	#      equipment_manager.equipar_arma(nuevo_item)

func recalcular_stats():
	max_saltos_actuales = max_saltos_base
	if mascara_equipada != null:
		max_saltos_actuales += mascara_equipada.saltos_extra
		#ABAJO HABRIA QUE PONER LOS DISTINTOS STATS POSITIVOS.

func _physics_process(delta: float) -> void:
	
	# Gravedad
	gravity(delta)
	#movimiento horizontal
	move_x()
	#chequea saltos posibles
	check_landing()
	#salto
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

	if Input.is_action_just_pressed("jump"):
			if saltos_realizados < max_saltos_actuales :
				velocity.y = _jump_velocity
				saltos_realizados +=1
			
	
func check_landing():
	if is_on_floor():
		saltos_realizados = 0
	
func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right


func update_animatios():

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
	
