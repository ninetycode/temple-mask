extends PanelContainer

signal opcion_seleccionada(accion: String)

@onready var btn_equipar = $VBoxContainer/BtnEquipar
@onready var btn_mover = $VBoxContainer/BtnMover
@onready var btn_desequipar = $VBoxContainer/BtnDesequipar

func _ready():
	visible = false
	# Conectamos las señales de los botones
	btn_equipar.pressed.connect(func(): emitir("equipar"))
	btn_mover.pressed.connect(func(): emitir("mover"))
	btn_desequipar.pressed.connect(func(): emitir("desequipar"))

func emitir(accion):
	opcion_seleccionada.emit(accion)
	visible = false # Se cierra al elegir

func abrir_menu(posicion_global: Vector2, tipo_slot: int):
	global_position = posicion_global
	visible = true
	
	# CONFIGURAMOS QUÉ BOTONES SE VEN SEGÚN DÓNDE ESTÁS
	# Tipo 0 = Mochila (Puede Equipar o Mover)
	# Tipo 1 = Máscaras (Solo Mover - entre ellas)
	# Tipo 2 = Equipo (Puede Desequipar o Mover)
	
	btn_equipar.visible = (tipo_slot == 0) # Solo equipás desde la mochila
	btn_desequipar.visible = (tipo_slot == 2) # Solo desequipás lo equipado
	btn_mover.visible = true # Siempre podés mover (con restricciones)
	
	# Foco automático al primer botón visible para Joystick
	if btn_equipar.visible: btn_equipar.grab_focus()
	elif btn_desequipar.visible: btn_desequipar.grab_focus()
	else: btn_mover.grab_focus()
