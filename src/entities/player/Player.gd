extends KinematicBody2D

const MeleeAttack = preload("res://entities/player/MeleeAttack.gd")
const RangeAttack = preload("res://entities/player/RangeAttack.gd")
const MovementHandler = preload("res://entities/player/Movement.gd")

var attackMode
var movementHandler

func _ready():
	initialize()

func _physics_process(delta):
	movementHandler.handle_movement(self)
	attackMode.handle_attack()
	

func initialize():
	attackMode = MeleeAttack.new()
	movementHandler = MovementHandler.new()
