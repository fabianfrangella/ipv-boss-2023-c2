extends Node

var speed
var dash_speed
var can_dash
var is_attacking = false
var canPassThrough = false
var audio_container
var ghost_timer
var body

const footsteps = [
preload("res://Sounds/footsteps/footstep01.ogg"), preload("res://Sounds/footsteps/footstep02.ogg"), 
preload("res://Sounds/footsteps/footstep03.ogg"), preload("res://Sounds/footsteps/footstep04.ogg"), 
preload("res://Sounds/footsteps/footstep05.ogg"), preload("res://Sounds/footsteps/footstep06.ogg"), 
preload("res://Sounds/footsteps/footstep07.ogg"), preload("res://Sounds/footsteps/footstep08.ogg"), 
preload("res://Sounds/footsteps/footstep09.ogg")
]

var ghost_scene = preload("res://entities/player/DashGhost.tscn")

func initialize(dash_timer: Timer, _dash_speed = 20, _speed = 240, _audio_container = null, _ghost_timer = null , _body = null):
	can_dash = true
	dash_speed = _dash_speed
	speed = _speed
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	audio_container = _audio_container
	body = _body
	ghost_timer = _ghost_timer
	ghost_timer.connect("timeout", self, "_on_ghost_timer_timeout")

func handle_movement(body: KinematicBody2D, delta: float):

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
		ghost_timer.start()
		instance_ghost()
		velocity = velocity * dash_speed
		can_dash = false
		canPassThrough = true
		audio_container.get_node("DashStart").play()
		audio_container.get_node("Dash").play()
		#body.body_anim.get_node("AnimationPlayer").play("teleport")
		ghost_timer.start()
		instance_ghost()
		
	
	body.move_and_slide(velocity * delta)
	
func instance_ghost():
	var ghost: AnimatedSprite = ghost_scene.instance()  # Cambiamos de Sprite a AnimatedSprite
	body.get_parent().add_child(ghost)
	ghost.global_position = body.body_anim.body_anim.global_position
	ghost.frames = body.body_anim.body_anim.frames  # Utilizamos 'frames' en lugar de 'texture'
	ghost.animation = body.body_anim.body_anim.animation  # Asignamos la animación actual
	ghost.frame = body.body_anim.body_anim.frame
	ghost.scale = body.body_anim.body_anim.scale

func _on_dash_timer_timeout():
	can_dash = true
	canPassThrough = false
	ghost_timer.stop()
	
func _on_ghost_timer_timeout():
	instance_ghost()
	
func _play_sound():
	var sfx = footsteps[randi() % footsteps.size()]
	sfx.set_loop(false)
	var player = audio_container.get_node("Footsteps")
	if (not player.playing):
		player.stream = sfx
		player.play()
