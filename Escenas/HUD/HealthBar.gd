extends ProgressBar

# Asignar al Player desde el editor o buscarlo en _ready
@export var player: CharacterBody2D 

func _ready():
	# Si no asignaste player manual, buscalo
	if not player:
		player = get_tree().get_first_node_in_group("player")
	
	if player:
		# Conectamos con el COMPONENTE de salud, no con el player directo
		var salud = player.get_node("HealthComponent")
		salud.salud_cambiada.connect(_on_salud_cambiada)
		
		# Inicializar valores
		max_value = salud.get_salud_maxima()
		value = salud.salud_actual

func _on_salud_cambiada(actual, maxima):
	max_value = maxima
	value = actual
