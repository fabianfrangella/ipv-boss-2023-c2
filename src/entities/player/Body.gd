extends Node2D

onready var body_anim: AnimatedSprite = $Body
onready var melee_weapon_anim: AnimatedSprite = $Melee
onready var range_weapon_anim: AnimatedSprite = $Range

var previous_direction = Vector2(0, 0)

func _ready():
	melee_weapon_anim.hide()
	range_weapon_anim.hide()

func play(animation):
	if (body_anim.frames.has_animation(animation)):
		body_anim.play(animation)
	if (animation == 'range'):
		range_weapon_anim.play(animation)
	if (animation == 'melee'):
		melee_weapon_anim.show()
		_play_melee()
	
func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
		
	if (direction != Vector2(0, 0)):
		_play_idle_melee(previous_direction)
		previous_direction = direction
	else:
		_play_movement_melee(direction)
	
func _play_idle_melee(direction):
	pass
func _play_movement_melee(direction):
	pass
	
func _play_melee():
	body_anim.hide()
	match previous_direction:
		Vector2(0,-1):
			melee_weapon_anim.play("melee_up")
		Vector2(0, 1):
			melee_weapon_anim.play("melee_down")
		Vector2(-1, 0):
			melee_weapon_anim.play("melee_left")
		Vector2(1, 0):
			melee_weapon_anim.play("melee_right")
		Vector2(-1, -1):
			melee_weapon_anim.play("melee_up_left")
		Vector2(1, -1):
			melee_weapon_anim.play("melee_up_right")
		Vector2(-1, 1):
			melee_weapon_anim.play("melee_down_left")
		Vector2(1, 1):
			melee_weapon_anim.play("melee_down_right")
		Vector2(0, 0):
			melee_weapon_anim.play("melee_idle_down")


func _on_Melee_animation_finished():
	melee_weapon_anim.hide()
	body_anim.show()
