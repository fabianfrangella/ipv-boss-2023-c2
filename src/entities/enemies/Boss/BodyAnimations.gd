extends Node

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var body_anim: AnimatedSprite = $Demon

var animation_direction: Vector2 = Vector2(0, 1)
var state = AnimationState.IDLE

func _ready():
	set_state(AnimationState.IDLE)
	
func _physics_process(delta):
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
