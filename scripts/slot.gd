extends Control
class_name SlotUI

signal slot_activado(slot_propio)

@onready var icono = $Icono
@onready var selector = $Selector
@onready var label: Label = $Label



var item_almacenado: ItemData = null
var indice_slot: int = -1
var tipo_coleccion: int = 0

# AHORA RECIBIMOS LA CANTIDAD
func actualizar_slot(item: ItemData, indice: int, tipo: int, cantidad: int = 1):
	item_almacenado = item
	indice_slot = indice
	tipo_coleccion = tipo
	
	if item:
		icono.texture = item.icono
		icono.visible = true
		
		# Mostrar número solo si es acumulable y hay más de 1 (estilo Minecraft)
		if item.es_acumulable and cantidad > 1:
			label.text = str(cantidad)
			label.visible = true
		else:
			label.visible = false
	else:
		icono.visible = false
		label.visible = false
