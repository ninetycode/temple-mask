extends Resource
class_name ItemData

# Estas variables definen al item genérico.
# Usamos @export para que aparezcan en el Inspector de Godot y puedas editarlas visualmente.

@export var nombre: String = "Item Nuevo"
@export_multiline var descripcion: String = "Descripción del item"
@export var icono: Texture2D # Esta es la imagen que se verá en el inventario (la ventanita)
@export var es_acumulable: bool = false # Por si querés juntar 10 pociones en un solo slot
@export var precio : int = 10 
