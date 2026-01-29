extends Area2D

@onready var sprite_cerrado = $Cerrado
@onready var sprite_abierto = $Abierto
@onready var interaccion_icon: Marker2D = $InteraccionIcon

# ------- ESTADO -------
# Cambio clave: Inicializamos en null. Esta variable guardará al NODO del jugador, no un true/false.
var jugador_actual: Node2D = null 
var is_opened = false

# Definimos qué da el cofre desde el Inspector
@export var contenido: Array[ItemData] = []

func _ready():
	sprite_cerrado.visible = true
	sprite_abierto.visible = false
	interaccion_icon.visible = false # Aseguramos que arranque oculto
	
	# Conectamos señales
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Verificamos grupo player
	if body.is_in_group("player"):
		jugador_actual = body # <--- GUARDA EL NODO, NO "TRUE"
		if not is_opened:
			interaccion_icon.show()

func _on_body_exited(body):
	# Si el que sale es el mismo que estaba registrado
	if body == jugador_actual:
		jugador_actual = null
		interaccion_icon.hide()

func _input(event):
	# Chequeamos: tecla apretada + jugador existe + cofre cerrado
	if event.is_action_pressed("accept") and jugador_actual != null and not is_opened:
		open_chest()

func open_chest():
	is_opened = true
	sprite_cerrado.visible = false
	sprite_abierto.visible = true
	interaccion_icon.visible = false # Ocultamos el ícono al abrir
	
	print("Intentando dar items...")
	
	# --- REFACTORIZACIÓN DE SEGURIDAD ---
	# 1. Buscamos el inventario UNA SOLA VEZ antes del bucle
	var inventario_jugador = jugador_actual.get_node_or_null("Inventory")
	
	if inventario_jugador:
		# 2. Si existe, le damos todos los items
		for item in contenido:
			inventario_jugador.agregar_item(item)
			print("Cofre entregó: ", item.nombre)
	else:
		print("Error CRÍTICO: El jugador detectado no tiene nodo 'Inventory'")
	
	# 3. Vaciamos el cofre lógico
	contenido.clear()
