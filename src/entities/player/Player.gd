extends KinematicBody2D

const MeleeAttack = preload("res://entities/player/MeleeAttack.gd")
const RangeAttack = preload("res://entities/player/RangeAttack.gd")
const MovementHandler = preload("res://entities/player/Movement.gd")
const ATTACK_MODES = preload("res://entities/player/AttackModes.gd")

onready var weapon = $WeaponContainer/Weapon
onready var range_weapon = $RangeWeaponContainer/Weapon

var projectile_container: Node

var attackHandler
var movementHandler
var attackHandlers
var currentAttackMode

func _ready():
	initialize()

func _physics_process(delta):
	movementHandler.handle_movement(self)
	attackHandler._handle_attack(self)
	if Input.is_action_just_pressed("change_attack_mode"):
		_change_attack_mode()
	

func initialize(projectile_container: Node = get_parent()):
	attackHandlers = {
		ATTACK_MODES.MELEE: MeleeAttack.new(),
		ATTACK_MODES.RANGE: RangeAttack.new()
	}
	self.projectile_container = projectile_container
	weapon.projectile_container = projectile_container
	range_weapon.projectile_container = projectile_container
	attackHandler = attackHandlers.get(ATTACK_MODES.MELEE)
	currentAttackMode = ATTACK_MODES.MELEE
	movementHandler = MovementHandler.new()
	movementHandler.initialize(get_node("DashTimer"))

func _change_attack_mode():
	if (currentAttackMode == ATTACK_MODES.MELEE):
		attackHandler = attackHandlers.get(ATTACK_MODES.RANGE)
		currentAttackMode = ATTACK_MODES.RANGE
	else:
		attackHandler = attackHandlers.get(ATTACK_MODES.MELEE)
		currentAttackMode = ATTACK_MODES.MELEE

func notify_hit() -> void:
	set_physics_process(false)
	collision_layer = 0
	get_parent().remove_child(self)
	queue_free()
