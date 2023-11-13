extends KinematicBody2D
class_name Player

const MeleeAttack = preload("res://entities/player/MeleeAttack.gd")
const RangeAttack = preload("res://entities/player/RangeAttack.gd")
const MovementHandler = preload("res://entities/player/Movement.gd")
const ATTACK_MODES = preload("res://entities/player/AttackModes.gd")

signal hit(amount)
signal healed(amount)
signal potions_changed(amount)
signal deaths_changed()
var is_using_joystick = false
signal hp_changed(current_hp, max_hp)
signal mana_changed(current_mana, max_mana)
signal dead()

onready var weapon = $WeaponContainer/Weapon
onready var range_weapon = $RangeWeaponContainer/Weapon
onready var body_anim: Node2D = $BodyAnimations
onready var heal_timer = $HealTimer

export (int) var max_hp: int = 10
var hp: int = max_hp


export (int) var attack: int = 1

export (int) var potions: int = 0

export (float) var max_mana: float = 5.0
var mana: float = max_mana

export (float) var mana_recovery_time: float = 5.0
export (float) var mana_recovery_delay: float = 1.0

export (float) var dash_speed = 30
export (float) var speed = 240
var projectile_container: Node

var attackHandler
var movementHandler
var attackHandlers
var currentAttackMode
var previous_direction = Vector2(0, 0)

export (bool) var hasArmor: bool = false
export (bool) var hasGSword: bool = false
export (bool) var hasStaff: bool = false

const valid_outlines = ["BasicEnemyHitbox", "BossHitbox"]

onready var audio_container = $AudioContainer

func _ready():
	initialize()

func _physics_process(delta):
	if (not movementHandler.is_attacking):
		movementHandler.handle_movement(self)
	attackHandler._handle_attack(self)
	if Input.is_action_just_pressed("change_attack_mode") && hasStaff:
		_change_attack_mode()

	if Input.is_action_just_pressed("heal"):
		heal_hp()
	_set_weapon_direction()
	

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
	movementHandler.initialize(get_node("DashTimer"), dash_speed, speed, audio_container)
	if Checkpoint.last_position:
		self.global_position = Checkpoint.last_position
	if Checkpoint.potions:
		set_potions()
	if Checkpoint.armor:
		set_armor()
	if Checkpoint.sword:
		set_gsword()
	if Checkpoint.staff:
		set_staff()
	GameState.set_current_player(self)

func _set_weapon_direction():
	self.weapon.get_node("WeaponTip").position = previous_direction * 10
	self.range_weapon.get_node("WeaponTip").position = previous_direction * 10

func _change_attack_mode():
	if (currentAttackMode == ATTACK_MODES.MELEE):
		attackHandler = attackHandlers.get(ATTACK_MODES.RANGE)
		currentAttackMode = ATTACK_MODES.RANGE
		body_anim.set_range_animator()
	else:
		attackHandler = attackHandlers.get(ATTACK_MODES.MELEE)
		currentAttackMode = ATTACK_MODES.MELEE
		body_anim.set_melee_animator()

func notify_hit(amount: int = 1) -> void:
	handle_event("hit", amount)

func heal_hp()-> void:
	if potions>0 && hp< max_hp:
		sum_hp(6)
		potions = potions -1
		emit_signal("potions_changed", potions)

func sum_hp(amount: int) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	emit_signal("hp_changed", hp, max_hp)


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
	#set_physics_process(false)
	#collision_layer = 0
	#get_parent().remove_child(self)
	#queue_free()
	get_tree().reload_current_scene()


func notify_healed(amount):
	handle_event("healed", amount)


func notify_hp_changed(current_hp, max_hp):
	handle_event("hp_changed", [current_hp, max_hp])

func notify_mana_changed(current_mana, max_mana):
	handle_event("mana_changed", [current_mana, max_mana])
	
func notify_potions_changed(potions):
	handle_event("potions_changed", potions)

func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			sum_hp(-value)
		"healed":
			sum_hp(value)
		"hp_changed":
			if value[0] == 0:
				emit_signal("dead")
		"dead":
			emit_signal("deaths_changed")
			_remove()
			


func notify_dead():
	handle_event("dead")

func set_potions():
	Checkpoint.potions = true
	potions = 3
	emit_signal("potions_changed", potions)
	
func set_armor():
	hasArmor = true
	Checkpoint.armor = true
	hp = 10
	max_hp = 10
	if (currentAttackMode == ATTACK_MODES.MELEE):
		body_anim.set_melee_animator()
	else:
		body_anim.set_range_animator()
	
func set_gsword():
	Checkpoint.sword = true
	hasGSword = true
	attack = 5
	if (currentAttackMode == ATTACK_MODES.MELEE):
		body_anim.set_melee_animator()
	else:
		body_anim.set_range_animator()
	
func set_staff():
	Checkpoint.staff = true
	hasStaff = true
		

func _on_BodyAnimations_finished_attacking():
	attackHandler.can_attack = true
	movementHandler.is_attacking = false


func _on_BodyAnimations_is_attacking():
	attackHandler.can_attack = false
	movementHandler.is_attacking = true

func _on_PlayerHitbox_body_entered(body):
	if movementHandler.canPassThrough && body.name == "TileMap":
		body.collision_layer = 0

func _on_PlayerHitbox_body_exited(body):
	if body.name == "TileMap" and body.collision_layer != 0 and !movementHandler.canPassThrough:
		 body.collision_layer = 3

func notify_deaths_changed():
	pass # Replace with function body.


func _on_HealTimer_timeout():
	if (hp < max_hp):
		hp+=1


func _on_OutlineTriggerArea_area_entered(area):
	if (valid_outlines.has(area.name)):
		area.get_parent().set_outline()


func _on_OutlineTriggerArea_area_exited(area):
	if (valid_outlines.has(area.name)):
		area.get_parent().remove_outline()
