extends Node

var speed = 240

func handle_movement(body: KinematicBody2D):
			var motion = Vector2()
			if Input.is_action_pressed("move_up"):
				motion += Vector2(0, -1)
			if Input.is_action_pressed("move_down"):
				motion += Vector2(0, 1)
			if Input.is_action_pressed("move_left"):
				motion += Vector2(-1, 0)
			if Input.is_action_pressed("move_right"):
				motion += Vector2(1, 0)

			motion = motion.normalized() * speed

			body.move_and_slide(motion)
