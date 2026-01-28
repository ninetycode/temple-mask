extends Marker2D

var is_active = true 
@onready var area_visible: Area2D = $AreaVisible


func _ready():
	area_visible.body_entered.connect(_on_body_entered)
	area_visible.body_exited.connect(on_body_exited)
func mostrar():
	show()
	# Si querés, acá podrías disparar un sonido de "pop"
	
	
func deactivate():
	is_active = false
	hide()

func _on_body_entered(body):
	if body.is_in_group("player") and is_active:
		show()

func on_body_exited(body):
	if body.is_in_group("player"):
		hide()
