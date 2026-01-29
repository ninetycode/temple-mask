extends Node

# Referencia al dueño (el Player) para modificarle los stats y sprites
@onready var player = get_parent() 

# Referencia al Sprite que muestra la máscara (asegurate de tener este nodo en tu player)
@export var sprite_mascara: Sprite2D 

func equipar_mascara(nueva_mascara: ItemMascara):
	# 1. Guardar la referencia en el player
	player.mascara_equipada = nueva_mascara
	
	# 2. Actualizar visuales (Ponerse la máscara)
	if sprite_mascara:
		sprite_mascara.texture = nueva_mascara.sprite_rostro
		sprite_mascara.visible = true
		
	# 3. IMPORTANTE: Decirle al player que recalcule sus números
	player.recalcular_stats()
	
	# 4. Lógica futura para Pasivas Funcionales (ej: Luz)
	# Aquí instanciaríamos la antorcha si nueva_mascara.accesorio_pasivo no es null.

func desequipar_mascara():
	player.mascara_equipada = null
	if sprite_mascara:
		sprite_mascara.visible = false
	player.recalcular_stats()
