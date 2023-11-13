extends Node2D

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var attack_tree = get_node("AttackTree")
onready var heal_timer: Timer = get_node("HealTimer")
onready var body_anim = $BodyAnimations

var target
var max_hp = 100
var hp = 100

export (NodePath) var pathfinding_path: NodePath
signal hp_changed(hp)
signal hit
signal boss_found

var is_attacking = false
var has_been_triggered = false

export var fire_damage = 3
export var area_damage = 5

func _ready():
	target = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta):
	if (target == null || is_dead() || not has_been_triggered):
		return
	elif (target != null):
		if (not is_attacking):
			body_anim.set_state(AnimationState.IDLE, 
				_get_direction_to(self.position.direction_to(target.position)))

func notify_hit(damage):
	self.hp -= damage
	emit_signal("hp_changed", self.hp, max_hp)
	emit_signal("hit")
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
	_set_attack_state()


func _on_Demon_animation_finished():
	is_attacking = false
	if (target != null && hp <= 0):
		return
	elif (target != null):
		body_anim.set_state(AnimationState.IDLE, 
			_get_direction_to(self.position.direction_to(target.position)))

func is_dead():
	return hp <= 0


func _on_Player_dead():
	target = null

func _on_FireAttack_fire_attack():
	_set_attack_state()
	
func _set_attack_state():
	is_attacking = true
	if (target != null && target.position != null):
		body_anim.set_state(AnimationState.ATTACK, 
			_get_direction_to(self.position.direction_to(target.position)))


func _on_DetectionArea_entered(area):
	if (area.name == "PlayerHitbox"):
		get_node("DetectionArea").queue_free()
		emit_signal("boss_found")
		has_been_triggered = true
		
func set_outline():
	body_anim.set_outline()

func remove_outline():
	body_anim.remove_outline()

