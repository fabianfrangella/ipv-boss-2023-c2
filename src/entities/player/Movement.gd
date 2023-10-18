extends Node

var speed = 240
var dash_speed = 30
var can_dash
var previous_direction = Vector2(0, 0)

func initialize(dash_timer: Timer):
	can_dash = true
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")

func handle_movement(body: KinematicBody2D):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1, 0)
	
	if (velocity == Vector2(0, 0)):
		_play_idle_animation(body, previous_direction)
	else:
		_play_movement_animation(body, velocity)
		previous_direction = velocity
	
	velocity = velocity.normalized() * speed
	
	if can_dash && Input.is_action_pressed("dash"):
		velocity = velocity * dash_speed
		can_dash = false
	
	body.move_and_slide(velocity)
	

func _on_dash_timer_timeout():
	can_dash = true
	
func _play_movement_animation(body: KinematicBody2D, direction: Vector2):
	match direction:
		Vector2(0,-1):
			body.body_anim.play("walk_up")
		Vector2(0, 1):
			body.body_anim.play("walk_down")
		Vector2(-1, 0):
			body.body_anim.play("walk_left")
		Vector2(1, 0):
			body.body_anim.play("walk_right")
		Vector2(-1, -1):
			body.body_anim.play("walk_up_left")
		Vector2(1, -1):
			body.body_anim.play("walk_up_right")
		Vector2(-1, 1):
			body.body_anim.play("walk_down_left")
		Vector2(1, 1):
			body.body_anim.play("walk_down_right")
		Vector2(0, 0):
			body.body_anim.play("idle_down")
			
func _play_idle_animation(body: KinematicBody2D, direction: Vector2):
	match direction:
		Vector2(0,-1):
			body.body_anim.play("idle_up")
		Vector2(0, 1):
			body.body_anim.play("idle_down")
		Vector2(-1, 0):
			body.body_anim.play("idle_left")
		Vector2(1, 0):
			body.body_anim.play("idle_right")
		Vector2(-1, -1):
			body.body_anim.play("idle_up_left")
		Vector2(1, -1):
			body.body_anim.play("idle_up_right")
		Vector2(-1, 1):
			body.body_anim.play("idle_down_left")
		Vector2(1, 1):
			body.body_anim.play("idle_down_right")
		Vector2(0, 0):
			body.body_anim.play("idle_down")
