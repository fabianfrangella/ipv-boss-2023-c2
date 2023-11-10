extends Control

onready var hp_progress_1 = $HpProgress

func _ready():
	hp_progress_1.value = 100

func _on_hp_changed(hp: int, hp_max: int) -> void:
	hp_progress_1.max_value = hp_max
	hp_progress_1.value = hp
