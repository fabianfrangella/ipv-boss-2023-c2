extends Node2D

var AttackStateEnum = preload("res://entities/enemies/Boss/AttackTree/AttackStateEnum.gd")

onready var boss = get_parent()

onready var areaAttack = get_node("AreaAttack")
onready var fireAttack = get_node("FireAttack")
onready var summonAttack = get_node("SummonAttack")
onready var states = [areaAttack]

func _physics_process(delta):
	if (states != null):
		_handle_states(delta)

func notify_hit():
	if (boss.hp > 90):
		states = [areaAttack]
	elif (boss.hp <= 90 && boss.hp > 70):
		states = [summonAttack]
	elif (boss.hp <= 70 && boss.hp > 50):
		states = [areaAttack]
	elif (boss.hp <= 50 && boss.hp > 30):
		states = [fireAttack]
	elif (boss.hp <= 30 && boss.hp > 10):
		states = [fireAttack, areaAttack]
	elif (boss.hp <= 10):
		states = [fireAttack, areaAttack, summonAttack]

func _handle_states(delta):
	if (states != null):
		for state in self.states:
			state.handle_state(delta)

