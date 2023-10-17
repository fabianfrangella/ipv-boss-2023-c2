extends KinematicBody2D
class_name Player

const MeleeAttack = preload("res://entities/player/MeleeAttack.gd")
const RangeAttack = preload("res://entities/player/RangeAttack.gd")
const MovementHandler = preload("res://entities/player/Movement.gd")
const ATTACK_MODES = preload("res://entities/player/AttackModes.gd")

signal hit(amount)
signal healed(amount)
var is_using_joystick = false
signal hp_changed(current_hp, max_hp)
signal mana_changed(current_mana, max_mana)
signal dead()

onready var weapon = $WeaponContainer/Weapon
onready var range_weapon = $RangeWeaponContainer/Weapon

export (int) var max_hp: int = 3
var hp: int = max_hp

export (float) var max_mana: float = 5.0
var mana: float = max_mana

export (float) var mana_recovery_time: float = 5.0
export (float) var mana_recovery_delay: float = 1.0

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
	range_weapon.get_node("Sprite").hide()
	currentAttackMode = ATTACK_MODES.MELEE
	movementHandler = MovementHandler.new()
	movementHandler.initialize(get_node("DashTimer"))
	GameState.set_current_player(self)

func _change_attack_mode():
	if (currentAttackMode == ATTACK_MODES.MELEE):
		attackHandler = attackHandlers.get(ATTACK_MODES.RANGE)
		weapon.get_node("Sprite").hide()
		range_weapon.get_node("Sprite").show()
		currentAttackMode = ATTACK_MODES.RANGE
	else:
		attackHandler = attackHandlers.get(ATTACK_MODES.MELEE)
		range_weapon.get_node("Sprite").hide()
		weapon.get_node("Sprite").show()
		currentAttackMode = ATTACK_MODES.MELEE

func notify_hit(amount: int = 1) -> void:
	handle_event("hit", amount)

func sum_hp(amount: int) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	emit_signal("hp_changed", hp, max_hp)
	print("hp_changed %s %s" % [hp, max_hp])


var mana_regen_tween: SceneTreeTween

func sum_mana(amount: float) -> void:
	_update_passive_prop(
		clamp(mana + amount, 0.0, max_mana),
		max_mana,
		"mana",
		"mana_changed"
	)
	if mana < max_mana:
		if mana_regen_tween:
			mana_regen_tween.kill()
		mana_regen_tween = create_tween()
		var duration: float = (max_mana - mana) * mana_recovery_time / max_mana
		mana_regen_tween.tween_method(
			self,
			"_update_passive_prop",
			mana, max_mana, duration,
			[max_mana, "mana", "mana_changed"]
		).set_delay(mana_recovery_delay)
		
func _update_passive_prop(amount, max_amount, property: String, updated_signal) -> void:
	set(property, amount)
	emit_signal(updated_signal, amount, max_amount)
	
func _remove() -> void:
	set_physics_process(false)
	collision_layer = 0
	get_parent().remove_child(self)
	queue_free()




func notify_healed(amount):
	handle_event("healed", amount)


func notify_hp_changed(current_hp, max_hp):
	handle_event("hp_changed", [current_hp, max_hp])

func notify_mana_changed(current_mana, max_mana):
	handle_event("mana_changed", [current_mana, max_mana])


func handle_event(event: String, value = null) -> void:
	print(value)
	match event:
		"hit":
			sum_hp(-value)
		"healed":
			sum_hp(value)
		"hp_changed":
			if value[0] == 0:
				emit_signal("dead")
		"dead":
			_remove()


func notify_dead():
	handle_event("dead")

func _input(event):
	if event is InputEventMouseMotion:
		is_using_joystick = false
		rotation = (get_global_mouse_position() - global_position).angle()

## Acá solo me mantengo apuntando si tengo habilitada esa función.
## Esto es como corrección de apuntado para compensar por el delay
## aplicado por la animación de disparo.
func process_input() -> void:
	if (not is_using_joystick):
		is_using_joystick = Input.get_joy_axis(0,3) == 1 || Input.get_joy_axis(0, 2) == 1
	
	if (is_using_joystick):
		var _lookDir = Vector2()
		_lookDir.y = Input.get_joy_axis(0, 3)
		_lookDir.x = Input.get_joy_axis(0, 2)
		rotation = _lookDir.angle()
	else:
		rotation = (get_global_mouse_position() - global_position).angle()
