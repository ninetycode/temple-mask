extends Control
class_name SlotUI

@onready var icono = $Icono
@onready var selector = $Selector

# Guardamos qué item tiene este slot
var item_almacenado: ItemData = null

func actualizar_slot(item: ItemData):
	item_almacenado = item
	
	if item:
		icono.texture = item.icono
		icono.visible = true
	else:
		icono.texture = null
		icono.visible = false

# --- DETECCIÓN DE FOCO (Para Joystick/Teclado) ---
func _on_focus_entered():
	selector.visible = true
	# Acá podrías reproducir un sonido "bip"

func _on_focus_exited():
	selector.visible = false
