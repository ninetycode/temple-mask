extends Area2D

@onready var sprite_cerrado = $Cerrado
@onready var sprite_abierto = $Abierto
@onready var interaccion_icon: Marker2D = $InteraccionIcon


# Variables para controlar el estado
var player_in_range = false
var is_opened = false


# Esto te permite definir qué da el cofre desde el Inspector sin tocar código
@export var items_to_give = [
	{"id": "gold", "amount": 19},
	{"id": "mask_base", "amount": 1},
	{"id": "potion_health", "amount": 2}
]

func _ready():
	# Arrancamos con el cofre cerrado
	sprite_cerrado.visible = true
	sprite_abierto.visible = false
	
	# Conectamos las señales (podés hacerlo desde el editor también)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Verificamos que sea el jugador (asegurate que tu player esté en el grupo "player")
	if body.is_in_group("player"):
		player_in_range = true
		if not is_opened:
			interaccion_icon.show()
			
			

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		

func _input(event):
	# Si apretás el botón, estás cerca y el cofre no se abrió todavía
	if event.is_action_pressed("accept") and player_in_range and not is_opened:
		open_chest()
		

func open_chest():
	is_opened = true
	sprite_cerrado.visible = false
	sprite_abierto.visible = true
	interaccion_icon.deactivate()
	
	print("¡Cofre abierto! Recibiste:")
	for item in items_to_give:
		print("- ", item.amount, " de ", item.id)
	
	# Acá es donde después llamarías a la función de tu inventario
	# ejemplo: Global.inventory.add_items(items_to_give)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
