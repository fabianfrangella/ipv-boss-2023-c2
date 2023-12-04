extends Node2D

var AttackStateEnum = preload("res://entities/enemies/Boss/AttackTree/AttackStateEnum.gd")

onready var boss = get_parent()

onready var areaAttack = get_node("AreaAttack")
onready var fireAttack = get_node("FireAttack")
onready var summonAttack = get_node("SummonAttack")
onready var states = [areaAttack]

var next_portal = 0

func _physics_process(delta):
	if (boss.is_dead() || boss.move_to_portal):
		return
	if (states != null):
		_set_states(boss.hp)
		_handle_states(delta)

func _handle_states(delta):
	if (states != null):
		for state in states:
			if (boss.has_been_triggered):
				state.handle_state(delta)

func _set_states(hp):
	if (hp > 90):
		states = [areaAttack]
	elif (hp <= 90 && boss.hp > 70):
		states = [fireAttack]
	elif (hp <= 70 && boss.hp > 50):
		if (next_portal < 1):
			_move_to_next_portal()
		states = [summonAttack]
	elif (hp <= 50 && boss.hp > 30):
		states = [areaAttack, fireAttack]
	elif (hp <= 30 && boss.hp > 10):
		if (next_portal < 2):
			_move_to_next_portal()
		states = [fireAttack, areaAttack, summonAttack]
	elif (hp <= 10 && boss.hp > 0):
		if (next_portal < 3):
			_move_to_next_portal()
		states = [fireAttack, areaAttack, summonAttack]
	elif (hp <= 0):
		states = []

func _move_to_next_portal():
	next_portal += 1
	boss.move_to_portal = true
	boss.current_portal = next_portal
