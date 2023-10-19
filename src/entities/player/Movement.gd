extends Node

var speed = 240
var dash_speed = 30
var can_dash

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
		
	body.previous_direction = velocity
	
	velocity = velocity.normalized() * speed
	
	if can_dash && Input.is_action_pressed("dash"):
		velocity = velocity * dash_speed
		can_dash = false
	
	body.move_and_slide(velocity)
	

func _on_dash_timer_timeout():
	can_dash = true
