extends Node

## Escena manager de niveles que administra y carga el nivel actual,
## y se encarga de reiniciar el nivel, regresar al menu principal o
## cargar el siguiente nivel.
export (Array, PackedScene) var levels: Array
export (String) var main_menu_path: String

onready var current_level_container: Node = $CurrentLevelContainer

var level: int = 0

export (Texture) var mouse_cursor: Texture


func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_cursor, Input.CURSOR_ARROW, mouse_cursor.get_size() / 2)
	call_deferred("_setup_level", level)


func _setup_level(id: int) -> void:
	# Chequea que exista un nivel, y el número de nivel dado es correcto
	if id >= 0 && id < levels.size():
		
		# Remueve el nivel activo, si existiese
		if current_level_container.get_child_count() > 0:
			for child in current_level_container.get_children():
				current_level_container.remove_child(child)
				child.queue_free()
		
		# Inicializa el nivel nuevo y lo agrega al árbol
		var level_instance: GameLevel = levels[id].instance()
		current_level_container.add_child(level_instance)
		level_instance.connect("return_requested", self, "_return_called")
		level_instance.connect("restart_requested", self, "_restart_called")
		level_instance.connect("next_level_requested", self, "_next_called")


# Callback de regreso al MainMenu.
func _return_called() -> void:
	get_tree().paused = false
	get_tree().change_scene(main_menu_path)


# Callback de reinicio del nivel.
func _restart_called() -> void:
	_setup_level(level)


# Callback de nivel siguiente.
func _next_called() -> void:
	level = min(level + 1, levels.size() - 1)
	_setup_level(level)
