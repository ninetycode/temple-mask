extends Node
class_name HealthComponent

signal salud_cambiada(vida_actual: int, vida_maxima: int)
signal murio

@export var salud_base: int = 100 # La vida "desnudo"

var salud_bonus: int = 0 # La que viene de items
var salud_actual: int = 0

func _ready():
	# 1. Calculamos el máximo actual (Base + 0 bonus inicial)
	# 2. Llenamos la vida actual
	salud_actual = get_salud_maxima()
	emitir_actualizacion()

# Esta función es la calculadora, la usamos siempre que queremos saber el tope
func get_salud_maxima() -> int:
	return salud_base + salud_bonus

func recibir_daño(cantidad: int):
	salud_actual -= cantidad
	salud_actual = max(0, salud_actual) # Evita que baje de 0
	
	emitir_actualizacion()
	
	if salud_actual == 0:
		murio.emit()
		print("¡El dueño de este componente murió!")

func curar(cantidad: int):
	salud_actual += cantidad
	# Usamos get_salud_maxima() para no curar más del tope
	salud_actual = min(salud_actual, get_salud_maxima())
	emitir_actualizacion()

func actualizar_bonus(nuevo_bonus: int):
	# Calculamos la diferencia para ajustar la vida actual proporcionalmente (opcional)
	# Por ahora, simplemente actualizamos el techo
	salud_bonus = nuevo_bonus
	
	# Chequeo de seguridad: Si al sacarte un item tu vida actual quedó mayor al nuevo máximo
	if salud_actual > get_salud_maxima():
		salud_actual = get_salud_maxima()
		
	emitir_actualizacion()

func emitir_actualizacion():
	salud_cambiada.emit(salud_actual, get_salud_maxima())
