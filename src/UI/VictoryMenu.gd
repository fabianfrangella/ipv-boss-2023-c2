extends Control

## Menú de victoria genérico. Solo se presenta si se levanta la signal
## de "level_won" en GameState.

signal next_selected()
signal return_selected()
onready var time = $Panel/Time
onready var deaths = $Panel/Deaths


func _ready() -> void:
	hide()
	GameState.connect("level_won", self, "_on_level_won")
	


func _on_level_won() -> void:
	var minutos = int(Checkpoint.time / 60)
	var segundos = int(Checkpoint.time % 60)
	var tiempo_formateado = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)
	time.text = "Time: " + tiempo_formateado
	deaths.text = "Deaths: " + str(Checkpoint.deaths + 1)
	show()


func _on_ReturnButton_pressed() -> void:
	hide()
	Checkpoint.reset()
	get_tree().reload_current_scene()
	emit_signal("return_selected")
	


func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false
