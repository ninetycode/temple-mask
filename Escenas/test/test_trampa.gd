extends Area2D

@export var daño: int = 20

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Buscamos el componente de vida
		var salud = body.get_node_or_null("HealthComponent")
		if salud:
			salud.recibir_daño(daño)
			print("¡Auch! Vida restante: ", salud.salud_actual)
