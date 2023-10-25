extends Node2D

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var body_anim: AnimatedSprite = $Melee
onready var melee_weapon_anim: AnimatedSprite = $Melee
onready var range_weapon_anim: AnimatedSprite = $Range
onready var body = get_parent()

var previous_direction = Vector2(0, 0)

signal is_attacking
signal finished_attacking

var state = AnimationState.IDLE
var attack_type = 'melee'

func _ready():
	melee_weapon_anim.show()
	range_weapon_anim.hide()
	_play_idle_animation()

func _physics_process(delta):
	# acá tiro magia negra para mover el tip invisible en la direccion a la que está atacando
	# después veo de moverlo a un lugar menos turbio
	body.weapon.get_node("WeaponTip").position = previous_direction * 50
	body.range_weapon.get_node("WeaponTip").position = previous_direction * 50
	
	match self.state:
		AnimationState.IDLE: _play_idle_animation()
		AnimationState.MOVEMENT: _play_movement_animation()
		AnimationState.ATTACK: _play_attack_animation()

func set_direction(direction):
	self.previous_direction = direction

func set_state(new_state, direction = self.previous_direction):
	match new_state:
		'melee': 
			self.state = AnimationState.ATTACK
			emit_signal("is_attacking")
			attack_type = 'melee'
		'range':
			self.state = AnimationState.ATTACK
			emit_signal("is_attacking")
			attack_type = 'range'
		'idle':
			self.state = AnimationState.IDLE
		'movement':
			self.previous_direction = direction
			self.state = AnimationState.MOVEMENT

func _play_attack_animation():
	if (attack_type == 'melee'):
		var melee_animation = _get_melee_animation(previous_direction)
		body_anim.play(melee_animation)
	elif(attack_type == 'range'):
		var range_animation = _get_range_animation(previous_direction)
		body_anim.play(range_animation)
	
func _get_range_animation(direction):
	match direction:
		Vector2(0,-1): return "range_up"
		Vector2(0, 1): return "range_down"
		Vector2(-1, 0): return "range_left"
		Vector2(1, 0): return "range_right"
		Vector2(-1, -1): return "range_up_left"
		Vector2(1, -1): return "range_up_right"
		Vector2(-1, 1): return "range_down_left"
		Vector2(1, 1): return "range_down_right"
		Vector2(0, 0): return "range_down"

func _get_melee_animation(direction):
	match direction:
		Vector2(0,-1): return "melee_up"
		Vector2(0, 1): return "melee_down"
		Vector2(-1, 0): return "melee_left"
		Vector2(1, 0): return "melee_right"
		Vector2(-1, -1): return "melee_up_left"
		Vector2(1, -1): return "melee_up_right"
		Vector2(-1, 1): return "melee_down_left"
		Vector2(1, 1): return "melee_down_right"
		Vector2(0, 0): return "melee_down"

func set_melee_animator():
	melee_weapon_anim.show()
	range_weapon_anim.hide()
	body_anim = melee_weapon_anim
	
func set_range_animator():
	melee_weapon_anim.hide()
	range_weapon_anim.show()
	body_anim = range_weapon_anim

func _play_idle_animation():
	match self.previous_direction:
		Vector2(0,-1):
			body_anim.play("idle_up")
		Vector2(0, 1):
			body_anim.play("idle_down")
		Vector2(-1, 0):
			body_anim.play("idle_left")
		Vector2(1, 0):
			body_anim.play("idle_right")
		Vector2(-1, -1):
			body_anim.play("idle_up_left")
		Vector2(1, -1):
			body_anim.play("idle_up_right")
		Vector2(-1, 1):
			body_anim.play("idle_down_left")
		Vector2(1, 1):
			body_anim.play("idle_down_right")

func _play_movement_animation():
	match self.previous_direction:
		Vector2(0,-1):
			body_anim.play("walk_up")
		Vector2(0, 1):
			body_anim.play("walk_down")
		Vector2(-1, 0):
			body_anim.play("walk_left")
		Vector2(1, 0):
			body_anim.play("walk_right")
		Vector2(-1, -1):
			body_anim.play("walk_up_left")
		Vector2(1, -1):
			body_anim.play("walk_up_right")
		Vector2(-1, 1):
			body_anim.play("walk_down_left")
		Vector2(1, 1):
			body_anim.play("walk_down_right")
		Vector2(0, 0):
			body_anim.play("idle_down")

func _on_animation_finished():
	if 'melee' in body_anim.animation:
		emit_signal("finished_attacking")
		state = AnimationState.IDLE
	if 'range' in body_anim.animation:
		emit_signal("finished_attacking")
		state = AnimationState.IDLE
