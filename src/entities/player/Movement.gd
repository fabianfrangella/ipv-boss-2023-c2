extends Node

var speed
var dash_speed
var can_dash
var is_attacking = false
var canPassThrough = false
var audio_container

const footsteps = [
preload("res://Sounds/footsteps/footstep01.ogg"), preload("res://Sounds/footsteps/footstep02.ogg"), 
preload("res://Sounds/footsteps/footstep03.ogg"), preload("res://Sounds/footsteps/footstep04.ogg"), 
preload("res://Sounds/footsteps/footstep05.ogg"), preload("res://Sounds/footsteps/footstep06.ogg"), 
preload("res://Sounds/footsteps/footstep07.ogg"), preload("res://Sounds/footsteps/footstep08.ogg"), 
preload("res://Sounds/footsteps/footstep09.ogg")
]

func initialize(dash_timer: Timer, _dash_speed = 30, _speed = 240, _audio_container = null):
	can_dash = true
	dash_speed = _dash_speed
	speed = _speed
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	audio_container = _audio_container

func handle_movement(body: KinematicBody2D):
	var velocity := Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1, 0)
		
	
	if (velocity == Vector2(0, 0) && not is_attacking):
		body.body_anim.set_state("idle")
	if (not is_attacking && velocity != Vector2(0, 0)):
		body.previous_direction = velocity
		body.body_anim.set_direction(velocity)
		body.body_anim.set_state('movement')
		_play_sound()
		if abs(velocity.x) + abs(velocity.y) > 1.0:
			if abs(velocity.x + velocity.y) < 1.5:
				velocity = velocity.rotated(deg2rad(18))
			else:
				velocity = velocity.rotated(deg2rad(-18))
		
	velocity = velocity.normalized() * speed
	
	if can_dash && Input.is_action_pressed("dash"):
		velocity = velocity * dash_speed
		can_dash = false
		canPassThrough = true
	
	body.move_and_slide(velocity)
	

func _on_dash_timer_timeout():
	can_dash = true
	canPassThrough = false
	
func _play_sound():
	var sfx = footsteps[randi() % footsteps.size()]
	sfx.set_loop(false)
	var player = audio_container.get_node("Footsteps")
	if (not player.playing):
		player.stream = sfx
		player.play()
