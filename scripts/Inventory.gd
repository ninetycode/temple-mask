extends Node
class_name Inventory

# Esta señal avisará a la UI (cuando la hagamos) que algo cambió.
# Así la UI se redibuja sola sin que el inventario sepa de ella.
signal inventario_actualizado
signal item_agregado(item: ItemData)

# Acá guardamos los items.
@export var items_mochila: Array[ItemData] = []
@export var items_mascaras: Array[ItemMascara] = []
@export var items_equipo: Array[ItemData] = []

#capacidad de el inventario:
const CAPACIDAD_MOCHILA = 12
const CAPACIDAD_MASCARAS = 6
const CAPACIDAD_EQUIPO = 3

func _ready():
	items_mochila.resize(CAPACIDAD_MOCHILA)
	items_mascaras.resize(CAPACIDAD_MASCARAS)
	items_equipo.resize(CAPACIDAD_EQUIPO)

func agregar_item(item: ItemData) -> bool:
	if item is ItemMascara:
		return _agregar_a_array(items_mascaras,item)
	else:
		return _agregar_a_array(items_mochila, item)
	


func _agregar_a_array(array_destino: Array, item: ItemData) -> bool:
	for i in range(array_destino.size()):
		if array_destino[i] == null:
			array_destino[i] = item
			
			# ESTA ES LA SEÑAL PARA LA UI (DIBUJAR)
			inventario_actualizado.emit() 
			
			# --- FALTA ESTA SEÑAL ---
			# ESTA ES LA SEÑAL PARA EL PLAYER (EQUIPAR)
			item_agregado.emit(item) 
			
			print("Item agregado en slot ", i)
			return true
	
	print("¡No hay espacio en esa sección!")
	return false
