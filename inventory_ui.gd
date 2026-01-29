extends CanvasLayer

@onready var control_principal = $ControlPrincipal

# Verificá que estos nombres sean EXACTOS a los de tu árbol de escena
@onready var grid_mochila = $ControlPrincipal/GridMochila
@onready var row_mascaras = $ControlPrincipal/RowMascaras # Ojo: en tu código decía row_mascaras_2
@onready var col_equipo = $ControlPrincipal/ColEquipo

var inventario_player: Inventory = null

func _ready():
	control_principal.visible = false 

func _input(event):
	# Asegurate que en Mapa de Entradas la acción se llame "inventory"
	if event.is_action_pressed("inventory"): 
		toggle_inventario()

func toggle_inventario():
	control_principal.visible = not control_principal.visible
	
	if control_principal.visible:
		get_tree().paused = true
		actualizar_visuales()
		
		# --- CORRECCIÓN ANTI-CRASH ---
		# Verificamos que grid_mochila exista y tenga hijos antes de pedirle cosas
		if grid_mochila and grid_mochila.get_child_count() > 0:
			var primer_slot = grid_mochila.get_child(0)
			primer_slot.grab_focus()
			
	else:
		get_tree().paused = false

func actualizar_visuales():
	# Buscamos el inventario si aun no lo tenemos
	if inventario_player == null:
		# Buscamos al player en el grupo 'player' (asegurate que tu Personaje esté en ese grupo)
		var player = get_tree().get_first_node_in_group("player")
		if player:
			inventario_player = player.get_node_or_null("Inventory")

	# Si encontramos el inventario, llenamos los slots
	if inventario_player:
		# 1. Mochila
		if grid_mochila: # Chequeo de seguridad
			for i in range(inventario_player.items_mochila.size()):
				if i < grid_mochila.get_child_count():
					var slot = grid_mochila.get_child(i)
					slot.actualizar_slot(inventario_player.items_mochila[i])
		
		# 2. Máscaras
		if row_mascaras: # Chequeo de seguridad
			for i in range(inventario_player.items_mascaras.size()):
				if i < row_mascaras.get_child_count():
					var slot = row_mascaras.get_child(i)
					slot.actualizar_slot(inventario_player.items_mascaras[i])

		# 3. Equipo
		if col_equipo: # Chequeo de seguridad
			for i in range(inventario_player.items_equipo.size()):
				if i < col_equipo.get_child_count():
					var slot = col_equipo.get_child(i)
					slot.actualizar_slot(inventario_player.items_equipo[i])
