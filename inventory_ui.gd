extends CanvasLayer

@onready var control_principal = $ControlPrincipal
@onready var grid_mochila = $ControlPrincipal/GridMochila
@onready var row_mascaras = $ControlPrincipal/RowMascaras
@onready var col_equipo = $ControlPrincipal/ColEquipo
@onready var menu_contextual: PanelContainer = $MenuContextual


var inventario_player: Inventory = null

# --- ESTADOS ---
enum Estado { NAVEGANDO, MENU_ABIERTO, MOVIENDO_ITEM }
var estado_actual = Estado.NAVEGANDO


# --- VARIABLE PARA MOVER ITEMS ---
var slot_origen: SlotUI = null # Guarda el slot que seleccionaste primero

func _ready():
	control_principal.visible = false 
	menu_contextual.visible = false
	menu_contextual.opcion_seleccionada.connect(_on_menu_accion)
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
	# MAQUINA DE ESTADOS
	match estado_actual:
		
		Estado.NAVEGANDO:
			# Si tocás un slot vacío, no hacemos nada
			if slot_tocado.item_almacenado == null: return
			
			# Guardamos cuál tocaste
			slot_origen = slot_tocado
			
			# Abrimos menú justo ahí
			estado_actual = Estado.MENU_ABIERTO
			menu_contextual.abrir_menu(slot_tocado.global_position + Vector2(20, 20), slot_tocado.tipo_coleccion)
		
		Estado.MOVIENDO_ITEM:
			# Acá aplicamos la lógica de INTERCAMBIO con RESTRICCIONES
			ejecutar_movimiento(slot_tocado)

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
				
func _on_menu_accion(accion: String):
	match accion:
		"mover":
			estado_actual = Estado.MOVIENDO_ITEM
			slot_origen.modulate = Color(1, 1, 0) # Amarillo (Modo Selección)
			# Devolvemos el foco al slot para que te puedas mover
			slot_origen.grab_focus()
			
		"equipar":
			# Lógica automática: Buscar hueco en Equipo y mandar
			intentrar_auto_equipar(slot_origen)
			resetear_estado()
			
		"desequipar":
			# Lógica automática: Buscar hueco en Mochila y mandar
			intentar_auto_desequipar(slot_origen)
			resetear_estado()

func ejecutar_movimiento(slot_destino: SlotUI):
	# VALIDACIÓN ESTRICTA (LO QUE PEDISTE)
	var tipo_origen = slot_origen.tipo_coleccion
	var tipo_destino = slot_destino.tipo_coleccion
	
	var es_valido = false
	
	# Regla 1: Máscaras (Tipo 1) SOLO se mueven a Máscaras (Tipo 1)
	if tipo_origen == 1:
		if tipo_destino == 1: es_valido = true
		else: print("¡Las máscaras solo van abajo!")
	
	# Regla 2: Equipo (Tipo 2) NO puede recibir Máscaras ni Basura random
	elif tipo_destino == 2:
		# Solo entra si el origen es ItemEquipo
		if slot_origen.item_almacenado is ItemEquipo: es_valido = true
		else: print("¡Eso no es equipable!")
		
	# Regla 3: Mochila (Tipo 0) acepta todo MENOS máscaras (según tu diseño)
	elif tipo_destino == 0:
		if not (slot_origen.item_almacenado is ItemMascara): es_valido = true
		else: print("¡Las máscaras no van a la mochila!")

	# Regla 4: Moverse entre Máscaras
	if tipo_destino == 1 and not (slot_origen.item_almacenado is ItemMascara):
		es_valido = false
		print("¡Solo máscaras ahí abajo!")

	if es_valido:
		inventario_player.intercambiar_items(
			slot_origen.indice_slot, tipo_origen,
			slot_destino.indice_slot, tipo_destino
		)
		actualizar_visuales()
	
	resetear_estado()

func intentrar_auto_equipar(slot: SlotUI):
	# Buscamos espacio vacío en la lista de equipos (Tipo 2)
	var indice_vacio = -1
	for i in range(inventario_player.items_equipo.size()):
		if inventario_player.items_equipo[i] == null:
			indice_vacio = i
			break
	
	if indice_vacio != -1:
		inventario_player.intercambiar_items(slot.indice_slot, 0, indice_vacio, 2)
		actualizar_visuales()
	else:
		print("¡No tenés espacio para equipar más cosas!")

func intentar_auto_desequipar(slot: SlotUI):
	# Buscamos espacio en mochila (Tipo 0)
	var indice_vacio = -1
	for i in range(inventario_player.items_mochila.size()):
		if inventario_player.items_mochila[i] == null:
			indice_vacio = i
			break
			
	if indice_vacio != -1:
		inventario_player.intercambiar_items(slot.indice_slot, 2, indice_vacio, 0)
		actualizar_visuales()
	else:
		print("¡Mochila llena!")

func resetear_estado():
	if slot_origen: slot_origen.modulate = Color(1, 1, 1)
	slot_origen = null
	estado_actual = Estado.NAVEGANDO
	# Importante: Si cerraste menú, devolvé foco a algún lado
	if grid_mochila.get_child_count() > 0:
		grid_mochila.get_child(0).grab_focus()
