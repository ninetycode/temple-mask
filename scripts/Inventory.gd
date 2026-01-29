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
	
func intercambiar_items(idx_origen: int, tipo_origen: int, idx_destino: int, tipo_destino: int):
	var lista_origen = _get_lista_por_tipo(tipo_origen)
	var lista_destino = _get_lista_por_tipo(tipo_destino)
	
	# Validación básica
	if lista_origen == null or lista_destino == null: return
	
	var item1 = lista_origen[idx_origen]
	var item2 = lista_destino[idx_destino]
	
	# REGLA DE JUEGO: Solo máscaras en slots de máscaras
	# Si intentás mover una poción (mochila) al slot de máscaras (abajo), chequeamos:
	if tipo_destino == 1 and item1 != null and not (item1 is ItemMascara):
		print("¡Eso no es una máscara!")
		return
	if tipo_origen == 1 and item2 != null and not (item2 is ItemMascara):
		print("¡No podés poner eso ahí!")
		return

	# Intercambio
	lista_origen[idx_origen] = item2
	lista_destino[idx_destino] = item1
	
	print("Items intercambiados")

func _get_lista_por_tipo(tipo: int) -> Array:
	match tipo:
		0: return items_mochila
		1: return items_mascaras
		2: return items_equipo
	return []
