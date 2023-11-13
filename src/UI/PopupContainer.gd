extends Control


onready var continue_button = $Panel/ContinueButton

# Texts
onready var range_enemy_text = $Panel/RangeEnemyText
onready var melee_enemy_text = $Panel/MeleeEnemyText
onready var potion_text = $Panel/PotionText
onready var boss_text = $Panel/BossText
onready var staff_text = $Panel/StaffText

onready var panel = $Panel

# Triggers
var range_enemy_triggered = false
var melee_enemy_triggered = false
var potion_triggered = false
var staff_triggered = false

var current_trigger = true
onready var current_hint = $Panel/RangeEnemyText

func _ready():
	continue_button.hide()
	range_enemy_text.hide()
	melee_enemy_text.hide()
	potion_text.hide()
	boss_text.hide()
	panel.hide()

func _on_hint_trigger(area, hint):
	if (area.name == "PlayerHitbox"):
		match hint:
			"staff": current_trigger = staff_triggered
			"melee_enemy": current_trigger = melee_enemy_triggered
			"range_enemy": current_trigger = range_enemy_triggered
			"potion": current_trigger = potion_triggered
			_: current_trigger = false
		if (not current_trigger):
			panel.show()
			continue_button.show()
			get_tree().paused = true
			match hint:
				"staff":
					current_hint = staff_text
					staff_triggered = true
				"melee_enemy":
					current_hint = melee_enemy_text
					melee_enemy_triggered = true
				"range_enemy":
					current_hint = range_enemy_text
					range_enemy_triggered = true
				"potion":
					current_hint = potion_text
					potion_triggered = true
				"boss":
					current_hint = boss_text
				_: pass
				
			current_hint.show()
			
func _on_ContinueButton_pressed():
	get_tree().paused = false
	current_hint.hide()
	continue_button.hide()
	panel.hide()

func _on_RangeEnemyArea_area_entered(area):
	_on_hint_trigger(area, "range_enemy")

func _on_MeleeEnemyArea_area_entered(area):
	_on_hint_trigger(area, "melee_enemy")


func _on_PotionArea_area_entered(area):
	_on_hint_trigger(area, "potion")

func _on_StaffArea_area_entered(area):
	_on_hint_trigger(area, "staff")

func _on_BossChamberArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		var text = "\n"
		var elementsLeft = 0
		if (not area.get_parent().hasGSword):
			elementsLeft+=1
			text += "Parece que aún no has encontrado una buena espada. \n"
		if (not area.get_parent().hasStaff):
			elementsLeft+=1
			text += "Todavía no has encontrado tu baculo? \n"
		if (not area.get_parent().hasArmor):
			elementsLeft+=1
			text += "Sin armadura?, buena suerte \n"
		if (text != "\n"):
			text += "Si no tienes los elementos necesarios será muy dificil que mates al demonio que tienes adelante"
			if (elementsLeft >= 2):
				text = "Si no tienes los elementos necesarios será muy dificil que mates al demonio que tienes adelante. \n Sería mejor que explores la mazmorra y encuentres el equipamiento necesario."
			boss_text.text = text
			current_hint = boss_text
			panel.show()
			boss_text.show()
			get_tree().paused = true
			continue_button.show()

