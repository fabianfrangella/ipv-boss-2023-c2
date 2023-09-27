extends Node

var speed = 240
var dash_speed = 10
var can_dash

func initialize(timer: Timer):
	can_dash = true
	timer.connect("timeout", self, "_on_dash_timer_timeout")

func handle_movement(body: KinematicBody2D):
	var motion = Vector2()
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
	
	motion = motion.normalized() * speed
	
	if can_dash && Input.is_action_pressed("dash"):
		motion = motion * dash_speed
		can_dash = false
	
	body.move_and_slide(motion)

func _on_dash_timer_timeout():
	can_dash = true
