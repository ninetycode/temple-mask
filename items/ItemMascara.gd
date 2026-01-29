extends ItemData
class_name ItemMascara

@export_group("Visuales")
@export var sprite_rostro: Texture2D

@export_group("Pasivas (Stats)")
# Si es 0, no da saltos extra. Si es 1, da doble salto. Si es 2, triple, etc.
@export var saltos_extra: int 
@export var velocidad_movimiento_bonus: float 
# Acá podés agregar más stats a futuro: resistencia_fuego, daño_base, etc.

@export_group("Pasivas (Funcionales)")
# Acá iría lo de la luz. Si ponés una escena aquí (ej: una antorcha), se instancia en el player.
@export var accesorio_pasivo: PackedScene 

@export_group("Habilidad Activa")
# Acá iría la "Bola de fuego". Es una escena que el player instancia al atacar.
@export var proyectil_activo: PackedScene
