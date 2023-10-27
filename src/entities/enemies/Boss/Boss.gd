extends Node2D

const AnimationState = preload("res://entities/player/AnimationState.gd")

onready var attackTree = get_node("AttackTree")

var target
var hp = 100

onready var body_anim = $BodyAnimations

func _ready():
	target = get_parent().get_node("Player")
	
func _physics_process(delta):
	if (target != null):
		body_anim.set_state(AnimationState.IDLE, _get_direction_to(self.position.direction_to(target.position)))

func notify_hit():
	self.hp -= 10
	attackTree.notify_hit()

func _get_direction_to(pos):
	var abs_position = Vector2(0, 0)
	if (pos.x > 0.5):
		abs_position.x = 1
	if (pos.x < 0):
		abs_position.x = -1
	if (pos.y > 0.5):
		abs_position.y = 1
	if (pos.y < 0):
		abs_position.y = -1
	return abs_position
