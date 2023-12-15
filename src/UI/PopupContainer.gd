extends Control

onready var continue_button = $Panel/ContinueButton

# Texts
onready var range_enemy_text = $Panel/RangeEnemyText
onready var melee_enemy_text = $Panel/MeleeEnemyText
onready var potion_text = $Panel/PotionText
onready var boss_text = $Panel/BossText
onready var staff_text = $Panel/StaffText
onready var dash_text = $Panel/DashText

onready var panel = $Panel

# Triggers
var range_enemy_triggered = false
var melee_enemy_triggered = false
var potion_triggered = false
var staff_triggered = false
var dash_triggered = false

var current_trigger = true
onready var current_hint = $Panel/RangeEnemyText

onready var dead_menu = $DeadMenu

signal unpaused

func _ready():
	initialize_texts()
	continue_button.hide()
	range_enemy_text.hide()
	melee_enemy_text.hide()
	potion_text.hide()
	boss_text.hide()
	panel.hide()
	dead_menu.hide()

func _on_hint_trigger(area, hint):
	if (area.name == "PlayerHitbox"):
		match hint:
			"staff": current_trigger = staff_triggered
			"melee_enemy": current_trigger = melee_enemy_triggered
			"range_enemy": current_trigger = range_enemy_triggered
			"potion": current_trigger = potion_triggered
			"dash": current_trigger = dash_triggered
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
				"dash":
					current_hint = dash_text
					dash_triggered = true
				_: pass
				
			current_hint.show()

func initialize_texts():
	range_enemy_text.text = """Hay enemigos que pueden atacar a la distancia, tratá de esquivar sus ataques para acercarte y eliminarlos!
Cuando estés a una distancia adecuada para hacerle daño podrás observar su silueta remarcada.
Utiliza la tecla """ + get_key_name("attack") + """ para atacar"""
	
	melee_enemy_text.text = """Otros enemigos se acercaran para atacarte, tratá de recibir el menor daño posible de sus ataques y eliminalos!"""
	
	potion_text.text = """Parece que has encontrado una poción!.
En la mazmorra encontraras 
artefactos que te serviran para enfrentar a tus enemigos, camina sobre ellos para equiparlos. 
Algunos de estos artefactos son consumibles, presiona """ + get_key_name("heal") + " para consumirlo"

	boss_text.text = ""
	
	staff_text.text = """Encontraste el baculo!, puedes equiparlo presionando """  + get_key_name("change_attack_mode") + """ en cualquier momento. 
Ten en cuenta que tus ataques de magia consumen mana!."""
	
	dash_text.text = """Puedes utilizar el dash con """ + get_key_name("dash") + """ para esquivar los ataques enemigos!"""

func _on_ContinueButton_pressed():
	get_tree().paused = false
	emit_signal("unpaused")
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

func _on_DashArea_area_entered(area):
	_on_hint_trigger(area, "dash")


func _on_Player_dead():
	dead_menu.show()

func get_key_name(action: String):
	# Gets the first input event attached to an action.
	var event = InputMap.get_action_list(action)[0]
	
	# Returns if the event is not a key.
	if not event is InputEventKey:
		return action
	
	# Gets the constant scancode and the physical scancode of the key
	var scancode: int = event.scancode
	var physical_scancode: int = event.physical_scancode
	
	# Checks if the key is physical, if so it converts the scancode
	if physical_scancode:
		scancode = OS.keyboard_get_scancode_from_physical(physical_scancode)
	
	# Returns the name of the key
	return OS.get_scancode_string(scancode)
