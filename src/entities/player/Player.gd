extends KinematicBody2D

const MeleeAttack = preload("res://entities/player/MeleeAttack.gd")
const RangeAttack = preload("res://entities/player/RangeAttack.gd")
const MovementHandler = preload("res://entities/player/Movement.gd")
const ATTACK_MODES = preload("res://entities/player/AttackModes.gd")

var attackHandler
var movementHandler
var attackHandlers
var currentAttackMode

func _ready():
	initialize()

func _physics_process(delta):
	movementHandler.handle_movement(self)
	attackHandler.handle_attack()
	if Input.is_action_pressed("change_attack_mode"):
		_change_attack_mode()
	

func initialize():
	attackHandlers = {
		"melee": MeleeAttack.new(),
		"range": RangeAttack.new()
	}
	attackHandler = attackHandlers.get("melee")
	currentAttackMode = ATTACK_MODES.MELEE
	movementHandler = MovementHandler.new()

func _change_attack_mode():
	if (currentAttackMode == ATTACK_MODES.MELEE):
		attackHandler = attackHandlers.get("range")
		currentAttackMode = ATTACK_MODES.RANGE
	else:
		attackHandler = attackHandlers.get("melee")
		currentAttackMode = ATTACK_MODES.MELEE
