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

func set_state(new_state, direction = self.animation_direction):
	self.state = new_state
	self.animation_direction = direction

func _play_idle_animation():
	match self.animation_direction:
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
	match self.animation_direction:
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
	
func _play_attack_animation():
	pass
