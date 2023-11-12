extends Control


onready var continue_button = $ContinueButton
onready var range_enemy_text = $RangeEnemyText

var range_enemy_triggered = false
onready var current_hint = $RangeEnemyText

func _ready():
	continue_button.hide()
	range_enemy_text.hide()

func _on_RangeEnemyArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		if (not range_enemy_triggered):
			current_hint = range_enemy_text
			range_enemy_text.show()
			range_enemy_triggered = true
			get_tree().paused = true
			continue_button.show()

func _on_ContinueButton_pressed():
	print("continuar")
	get_tree().paused = false
	current_hint.hide()
	continue_button.hide()
	
