extends Control


onready var continue_button = $Panel/ContinueButton
onready var range_enemy_text = $Panel/RangeEnemyText
onready var melee_enemy_text = $Panel/MeleeEnemyText
onready var potion_text = $Panel/PotionText
onready var boss_text = $Panel/BossText
onready var panel = $Panel

var range_enemy_triggered = false
var melee_enemy_triggered = false
var potion_triggered = false

onready var current_hint = $Panel/RangeEnemyText

func _ready():
	continue_button.hide()
	range_enemy_text.hide()
	melee_enemy_text.hide()
	potion_text.hide()
	boss_text.hide()
	panel.hide()

func _on_RangeEnemyArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		if (not range_enemy_triggered):
			current_hint = range_enemy_text
			panel.show()
			range_enemy_text.show()
			range_enemy_triggered = true
			get_tree().paused = true
			continue_button.show()

func _on_ContinueButton_pressed():
	get_tree().paused = false
	current_hint.hide()
	continue_button.hide()
	panel.hide()

func _on_MeleeEnemyArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		if (not melee_enemy_triggered):
			current_hint = melee_enemy_text
			panel.show()
			melee_enemy_text.show()
			melee_enemy_triggered = true
			get_tree().paused = true
			continue_button.show()


func _on_PotionArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		if (not potion_triggered):
			current_hint = potion_text
			panel.show()
			potion_text.show()
			potion_triggered = true
			get_tree().paused = true
			continue_button.show()


func _on_BossChamberArea_area_entered(area):
	if (area.name == "PlayerHitbox"):
		var text = ""
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
		if (text != ""):
			text += "Si no tienes los elementos necesarios será muy dificil que mates al demonio que tienes adelante"
			if (elementsLeft >= 2):
				text = "Si no tienes los elementos necesarios será muy dificil que mates al demonio que tienes adelante. \n Sería mejor que explores la mazmorra y encuentres el equipamiento necesario."
			boss_text.text = text
			current_hint = boss_text
			panel.show()
			boss_text.show()
			get_tree().paused = true
			continue_button.show()
		
