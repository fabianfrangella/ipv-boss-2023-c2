extends Node

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var body_anim: AnimatedSprite = $Demon
onready var blood_anim: AnimatedSprite = $Blood

var animation_direction: Vector2 = Vector2(0, 1)
var state = AnimationState.IDLE

var has_played_dead = false

func _ready():
	set_state(AnimationState.IDLE)
	
func _physics_process(delta):
	if (has_played_dead):
		return
	match self.state:
		AnimationState.IDLE: _play_idle_animation()
		AnimationState.MOVEMENT: _play_movement_animation()
		AnimationState.ATTACK: _play_attack_animation()
		AnimationState.DEAD: _play_dead_animation()

func set_state(new_state, direction = self.animation_direction):
	self.state = new_state
	self.animation_direction = direction

func _play_dead_animation():
	_play_animation("death")
	has_played_dead = true
	GameState.notify_level_won()
			
func _play_idle_animation():
	_play_animation("idle")

func _play_movement_animation():
	_play_animation("walk")

func _play_attack_animation():
	_play_animation("attack")
	
func _play_animation(animation_name):
	match self.animation_direction:
		Vector2(0,-1):
			body_anim.play(animation_name + "_up")
		Vector2(0, 1):
			body_anim.play(animation_name + "_down")
		Vector2(-1, 0):
			body_anim.play(animation_name + "_left")
		Vector2(1, 0):
			body_anim.play(animation_name + "_right")
		Vector2(-1, -1):
			body_anim.play(animation_name + "_up_left")
		Vector2(1, -1):
			body_anim.play(animation_name + "_up_right")
		Vector2(-1, 1):
			body_anim.play(animation_name + "_down_left")
		Vector2(1, 1):
			body_anim.play(animation_name + "_down_right")
		Vector2(0, 0):
			body_anim.play(animation_name + "_down")

func _play_blood_animation():
	if (has_played_dead):
		return
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var animation_name = "blood_" + str(rng.randi_range(1, 5))
	blood_anim.play(animation_name)


func _on_Blood_animation_finished():
	pass

func _on_Boss_hit():
	_play_blood_animation()
