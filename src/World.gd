extends GameLevel
onready var player = $YSort/Entities/Player

# Regresa al menu principal

## Agregamos un botoncito primitivo de reset. Por default es la "R".
func _input(event: InputEvent) -> void:
	if event.is_action("reset"):
		Checkpoint.reset()
		get_tree().reload_current_scene()


func _on_return_requested() -> void:
	Checkpoint.reset()
	emit_signal("return_requested")


func _on_restart_requested() -> void:
	Checkpoint.reset()
	emit_signal("restart_requested")

