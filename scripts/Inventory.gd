extends Node
class_name Inventory

# Esta señal avisará a la UI (cuando la hagamos) que algo cambió.
# Así la UI se redibuja sola sin que el inventario sepa de ella.
signal inventario_actualizado
signal item_agregado(item: ItemData)

# Acá guardamos los items. Es una lista de nuestros archivos .tres
@export var items: Array[ItemData] = []
@export var capacidad: int = 20 # limite del inventario

func agregar_item(nuevo_item: ItemData) -> bool:
	# 1. Chequeamos si hay lugar
	if items.size() >= capacidad:
		print("¡Inventario lleno! No entra: ", nuevo_item.nombre)
		return false
	
	# 2. Agregamos el item a la lista
	item_agregado.emit(nuevo_item)
	print("item agrego al inventario:", nuevo_item.nombre)
	return true
	
	# 3. Avisamos al mundo (y a la futura UI) que hubo cambios
	inventario_actualizado.emit()
	print("Item agregado: ", nuevo_item.nombre) # Debug para ver si anda
	return true

func remover_item(item: ItemData):
	if items.has(item):
		items.erase(item)
		inventario_actualizado.emit()
		print("Item removido: ", item.nombre)

func tiene_item(item_buscado: ItemData) -> bool:
	return items.has(item_buscado)
