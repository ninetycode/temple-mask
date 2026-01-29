extends CanvasLayer

@onready var control_principal = $ControlPrincipal
@onready var grid_mochila = $ControlPrincipal/GridMochila
@onready var row_mascaras = $ControlPrincipal/RowMascaras
@onready var col_equipo = $ControlPrincipal/ColEquipo

var inventario_player: Inventory = null

# --- VARIABLE PARA MOVER ITEMS ---
var slot_origen: SlotUI = null # Guarda el slot que seleccionaste primero

func _ready():
	control_principal.visible = false 
	# IMPORTANTE: Esperamos un frame para conectar señales si los slots ya existen
	call_deferred("conectar_slots")

func conectar_slots():
	# Conectamos todos los slots a la misma función central
	var todos_los_slots = []
	if grid_mochila: todos_los_slots.append_array(grid_mochila.get_children())
	if row_mascaras: todos_los_slots.append_array(row_mascaras.get_children())
	if col_equipo: todos_los_slots.append_array(col_equipo.get_children())
	
	for slot in todos_los_slots:
		if slot is SlotUI:
			if not slot.slot_activado.is_connected(_on_slot_clicked):
				slot.slot_activado.connect(_on_slot_clicked)

func _input(event):
	if event.is_action_pressed("inventory"): 
		toggle_inventario()

func toggle_inventario():
	control_principal.visible = not control_principal.visible
	
	if control_principal.visible:
		get_tree().paused = true
		actualizar_visuales()
		conectar_slots() # Aseguramos conexión
		
		# Foco inicial
		if grid_mochila and grid_mochila.get_child_count() > 0:
			grid_mochila.get_child(0).grab_focus()
	else:
		get_tree().paused = false
		slot_origen = null # Cancelamos movimiento si cierra

# --- LÓGICA DE INTERCAMBIO ---
func _on_slot_clicked(slot_tocado: SlotUI):
	# CASO 1: No tenías nada seleccionado -> SELECCIONAR (Origen)
	if slot_origen == null:
		# Solo permitimos seleccionar si hay un item (o si querés mover NADA, sacá el if)
		if slot_tocado.item_almacenado != null:
			slot_origen = slot_tocado
			slot_tocado.modulate = Color(1, 1, 0) # Ponerlo Amarillo (visual)
			print("Seleccionado: ", slot_tocado.item_almacenado.nombre)
	
	# CASO 2: Ya tenías uno seleccionado -> INTERCAMBIAR (Destino)
	else:
		# Si tocás el mismo, cancelamos
		if slot_origen == slot_tocado:
			slot_origen.modulate = Color(1, 1, 1) # Volver a normal
			slot_origen = null
			return
			
		# ¡HACEMOS EL CAMBIO EN EL INVENTARIO REAL!
		inventario_player.intercambiar_items(
			slot_origen.indice_slot, slot_origen.tipo_coleccion,
			slot_tocado.indice_slot, slot_tocado.tipo_coleccion
		)
		
		# Reset visual
		slot_origen.modulate = Color(1, 1, 1)
		slot_origen = null
		actualizar_visuales() # Redibujar todo

func actualizar_visuales():
	if inventario_player == null:
		var player = get_tree().get_first_node_in_group("player")
		if player: inventario_player = player.get_node_or_null("Inventory")

	if inventario_player:
		# 1. Mochila (Tipo 0)
		llenar_grid(grid_mochila, inventario_player.items_mochila, 0)
		# 2. Máscaras (Tipo 1)
		llenar_grid(row_mascaras, inventario_player.items_mascaras, 1)
		# 3. Equipo (Tipo 2)
		llenar_grid(col_equipo, inventario_player.items_equipo, 2)

# Función auxiliar para no repetir código
func llenar_grid(contenedor, array_datos, tipo_id):
	if contenedor:
		for i in range(array_datos.size()):
			if i < contenedor.get_child_count():
				var slot = contenedor.get_child(i)
				slot.actualizar_slot(array_datos[i], i, tipo_id)
