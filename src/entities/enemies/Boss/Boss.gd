extends Node2D

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var attack_tree = get_node("AttackTree")
onready var heal_timer: Timer = get_node("HealTimer")
onready var body_anim = $BodyAnimations

var target
var max_hp = 100
var hp = 100

signal hp_changed(hp)

var is_attacking = false

func _ready():
	target = get_parent().get_node("Player")
	
func _physics_process(delta):
	if (target == null || is_dead()|| target.hp <= 0):
		return
	elif (target != null):
		if (not is_attacking):
			body_anim.set_state(AnimationState.IDLE, 
				_get_direction_to(self.position.direction_to(target.position)))

func notify_hit():
	self.hp -= 10
	emit_signal("hp_changed", self.hp, max_hp)
	if (target != null && hp <= 0):
		body_anim.set_state(AnimationState.DEAD,
				_get_direction_to(self.position.direction_to(target.position)))

func _get_direction_to(pos):
	var abs_position = Vector2(0, 0)
	if (pos.x > 0.5):
		abs_position.x = 1
	if (pos.x < 0):
		abs_position.x = -1
	if (pos.y > 0.5):
		abs_position.y = 1
	if (pos.y < 0):
		abs_position.y = -1
	return abs_position


func _on_HealTimer_timeout():
	if (hp <= 0):
		return
	if (hp < 100):
		hp+=10
		if (hp > max_hp):
			hp = max_hp
		emit_signal("hp_changed", hp, max_hp)

func _on_AreaAttack_area_attack():
	is_attacking = true
	body_anim.set_state(AnimationState.ATTACK, 
		_get_direction_to(self.position.direction_to(target.position)))


func _on_Demon_animation_finished():
	is_attacking = false
	if (target != null && hp <= 0):
		return
	elif (target != null):
		body_anim.set_state(AnimationState.IDLE, 
			_get_direction_to(self.position.direction_to(target.position)))

func is_dead():
	return hp <= 0
