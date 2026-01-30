extends Node
class_name Inventory

signal inventario_actualizado
signal item_agregado(item: ItemData) # <--- ESTA ES LA CLAVE

@export var items_mochila: Array[ItemData] = []
@export var items_mascaras: Array[ItemMascara] = []
@export var items_equipo: Array[ItemData] = []

# Arrays de Cantidades
var cantidades_mochila: Array[int] = []

const CAPACIDAD_MOCHILA = 12
const CAPACIDAD_MASCARAS = 6
const CAPACIDAD_EQUIPO = 3

func _ready():
	items_mochila.resize(CAPACIDAD_MOCHILA)
	cantidades_mochila.resize(CAPACIDAD_MOCHILA)
	cantidades_mochila.fill(0)
	
	items_mascaras.resize(CAPACIDAD_MASCARAS)
	items_equipo.resize(CAPACIDAD_EQUIPO)

func agregar_item(item: ItemData) -> bool:
	if item is ItemMascara:
		return _agregar_simple(items_mascaras, item)
	else:
		return _agregar_con_stack(items_mochila, cantidades_mochila, item)

# Función para Máscaras (Corrección aplicada)
func _agregar_simple(array: Array, item: ItemData) -> bool:
	for i in range(array.size()):
		if array[i] == null:
			array[i] = item
			
			# --- ESTAS DOS LINEAS SON VITALES ---
			inventario_actualizado.emit()
			item_agregado.emit(item) # <--- FALTABA ESTA: Activa el equipar automático
			# ------------------------------------
			
			print("Mascara agregada en slot ", i)
			return true
	return false

# Función para Mochila (Stacking)
func _agregar_con_stack(items: Array, cantidades: Array, item: ItemData) -> bool:
	if item.es_acumulable:
		for i in range(items.size()):
			if items[i] == item:
				cantidades[i] += 1
				inventario_actualizado.emit()
				print("Stack subió a: ", cantidades[i])
				return true
	
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			cantidades[i] = 1
			inventario_actualizado.emit()
			return true
	return false

# ... (El resto de funciones consumir/intercambiar dejalas como estaban) ...
func consumir_item(indice: int, tipo_coleccion: int):
	if tipo_coleccion != 0: return
	if items_mochila[indice] != null:
		cantidades_mochila[indice] -= 1
		if cantidades_mochila[indice] <= 0:
			items_mochila[indice] = null
			cantidades_mochila[indice] = 0
		inventario_actualizado.emit()

func intercambiar_items(idx_1, tipo_1, idx_2, tipo_2):
	# (Usá la misma lógica de intercambio que te pasé antes)
	# Resumida para que no te pierdas:
	var lista_1 = _get_lista(tipo_1)
	var lista_2 = _get_lista(tipo_2)
	var item1 = lista_1[idx_1]
	var item2 = lista_2[idx_2]
	lista_1[idx_1] = item2
	lista_2[idx_2] = item1
	
	if tipo_1 == 0 and tipo_2 == 0:
		var c1 = cantidades_mochila[idx_1]
		var c2 = cantidades_mochila[idx_2]
		cantidades_mochila[idx_1] = c2
		cantidades_mochila[idx_2] = c1
	elif tipo_1 == 0: cantidades_mochila[idx_1] = 0 # Reset simple al sacar
	elif tipo_2 == 0: cantidades_mochila[idx_2] = 1 # Asumimos 1 al entrar
	
	inventario_actualizado.emit()

func _get_lista(tipo):
	match tipo:
		0: return items_mochila
		1: return items_mascaras
		2: return items_equipo
	return []
