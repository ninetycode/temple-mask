extends PanelContainer

signal opcion_seleccionada(accion: String)

@onready var btn_equipar = $VBoxContainer/BtnEquipar
@onready var btn_mover = $VBoxContainer/BtnMover
@onready var btn_desequipar = $VBoxContainer/BtnDesequipar
@onready var btn_usar: Button = $VBoxContainer/BtnUsar

func _ready():
	visible = false
	btn_equipar.pressed.connect(func(): emitir("equipar"))
	btn_mover.pressed.connect(func(): emitir("mover"))
	btn_desequipar.pressed.connect(func(): emitir("desequipar"))
	btn_usar.pressed.connect(func(): emitir("usar"))

func emitir(accion):
	opcion_seleccionada.emit(accion)
	visible = false

# CAMBIO: Ahora recibimos el "item" también
func abrir_menu(posicion_global: Vector2, tipo_slot: int, item: ItemData):
	global_position = posicion_global
	visible = true
	
	# 1. Resetear visibilidad
	btn_equipar.visible = false
	btn_desequipar.visible = false
	btn_usar.visible = false
	btn_mover.visible = true # Siempre podés mover
	
	# 2. Lógica según el TIPO DE ITEM
	if item is ItemConsumible:
		btn_usar.visible = true # Las pociones se usan, no se equipan
	elif item is ItemEquipo or item is ItemMascara:
		# Si está en la mochila (0), se puede equipar
		if tipo_slot == 0:
			btn_equipar.visible = true
		# Si está equipado (2) o es mascara abajo (1), no mostramos equipar ahí
		
	# 3. Lógica según DONDE ESTÁ (Desequipar)
	if tipo_slot == 2: # Está en slots de equipo
		btn_desequipar.visible = true
		btn_mover.visible = false # Opcional: Si está equipado, quizás no querés moverlo directo
	
	# 4. Foco
	if btn_usar.visible: btn_usar.grab_focus()
	elif btn_equipar.visible: btn_equipar.grab_focus()
	else: btn_mover.grab_focus()
