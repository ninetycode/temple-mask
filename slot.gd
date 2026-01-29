extends Control
class_name SlotUI

# Señal para avisar al padre (InventoryUI)
signal slot_activado(slot_propio)

@onready var icono = $Icono
@onready var selector = $Selector

# Guardamos qué item tiene y DÓNDE está (para saber qué intercambiar en el array)
var item_almacenado: ItemData = null
var indice_slot: int = -1
var tipo_coleccion: int = 0 # 0=Mochila, 1=Mascaras, 2=Equipo

func actualizar_slot(item: ItemData, indice: int, tipo: int):
	item_almacenado = item
	indice_slot = indice
	tipo_coleccion = tipo
	
	if item:
		icono.texture = item.icono
		icono.visible = true
	else:
		icono.visible = false

# --- DETECCIÓN DE FOCO (Teclado/Joystick) ---
func _on_focus_entered():
	selector.visible = true

func _on_focus_exited():
	selector.visible = false

# --- DETECCIÓN DE ENTRADA (Enter / Clic) ---
func _gui_input(event):
	# Soporte para Clic del Mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		slot_activado.emit(self)

func _input(event):
	# Soporte para Teclado/Joystick (Solo si este slot tiene el foco)
	if has_focus() and event.is_action_pressed("ui_accept"):
		slot_activado.emit(self)
		get_viewport().set_input_as_handled() # Evita doble input
