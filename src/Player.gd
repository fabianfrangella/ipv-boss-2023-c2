extends KinematicBody2D


var velocity: Vector2 = Vector2.ZERO
var speed = 240

func _ready():
	pass 

func _physics_process(delta):
	move_on_input()


func move_on_input():
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

			move_and_slide(motion)
