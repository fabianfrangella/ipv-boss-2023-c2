extends Control

signal return_selected()
signal restart_selected()

onready var options_menu: Control = $OptionsMenu


func _ready() -> void:
	hide()

func _on_ReturnButton_pressed() -> void:
	hide()
	emit_signal("return_selected")


func _on_RestartButton_pressed() -> void:
	hide()
	emit_signal("restart_selected")


func _on_ResumeButton_pressed() -> void:
	hide()


func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false

func _on_Player_dead():
	visible = !visible
	get_tree().paused = visible
