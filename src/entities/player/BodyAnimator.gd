extends Node2D

onready var body_anim: AnimatedSprite = $Melee
onready var melee_weapon_anim: AnimatedSprite = $Melee
onready var range_weapon_anim: AnimatedSprite = $Range
onready var armor_melee = $ArmorMelee
onready var normal_melee = $NormalMelee
onready var normal_great_sword = $NormalGreatSword
onready var normal_range = $NormalRange

onready var body = get_parent()

var previous_direction = Vector2(0, 0)

#TODO: Pasar todos estos flags a señales para eliminar dependencias directas
var can_melee_attack = true
var is_attacking = false
var can_change_animation = true
var can_range_attack = true

func _ready():
	set_melee_animator()
	_play_idle_animation(Vector2(0, 0))

func play(animation):
	if (body_anim.frames.has_animation(animation)):
		body_anim.play(animation)

func play_attack(type):
	if (type == 'melee'):
		can_melee_attack = false
		is_attacking = true
		var melee_animation = _get_melee_animation(previous_direction)
		body_anim.play(melee_animation)
	elif(type == 'range'):
		can_range_attack = false
		var range_animation = _get_range_animation(previous_direction)
		is_attacking = true
		body_anim.play(range_animation)
	
func _get_range_animation(direction):
	match direction:
		Vector2(0,-1): return "range_up"
		Vector2(0, 1): return "range_down"
		Vector2(-1, 0): return "range_left"
		Vector2(1, 0): return "range_right"
		Vector2(-1, -1): return "range_up_left"
		Vector2(1, -1): return "range_up_right"
		Vector2(-1, 1): return "range_down_left"
		Vector2(1, 1): return "range_down_right"
		Vector2(0, 0): return "range_down"

func _get_melee_animation(direction):
	match direction:
		Vector2(0,-1): return "melee_up"
		Vector2(0, 1): return "melee_down"
		Vector2(-1, 0): return "melee_left"
		Vector2(1, 0): return "melee_right"
		Vector2(-1, -1): return "melee_up_left"
		Vector2(1, -1): return "melee_up_right"
		Vector2(-1, 1): return "melee_down_left"
		Vector2(1, 1): return "melee_down_right"
		Vector2(0, 0): return "melee_down"
	
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
		
	if (direction == Vector2(0, 0) && not is_attacking):
		_play_idle_animation(previous_direction)
	if (not is_attacking && direction != Vector2(0, 0)):
		previous_direction = direction
		_play_movement_animation(direction)
	# acá tiro magia negra para mover el tip invisible en la direccion a la que está atacando
	# después veo de moverlo a un lugar menos turbio
	body.weapon.get_node("WeaponTip").position = previous_direction * 50
	body.range_weapon.get_node("WeaponTip").position = previous_direction * 50
	
	#TODO: Llevar todo lo relacionado a estas (hp, mana, costos, etc) a un singleton
	#	   para poder validar estas cosas desde varios scripts distintos sin repetir codigo
	#      ni pasar dependencias innecesarias
	can_range_attack = body.mana >= 2.0

func set_melee_animator():
	body_anim.hide()
	if body.hasArmor && body.hasGSword:
		melee_weapon_anim.show()
		body_anim = melee_weapon_anim
	elif body.hasArmor:
		armor_melee.show()
		body_anim = armor_melee
	elif body.hasGSword:
		normal_great_sword.show()
		body_anim = normal_great_sword
	else:
		normal_melee.show()
		body_anim = normal_melee
	
func set_range_animator():
	body_anim.hide()
	if body.hasArmor && body.hasStaff:
		range_weapon_anim.show()
		body_anim = range_weapon_anim
	elif body.hasStaff:
		normal_range.show()
		body_anim = normal_range

func _play_idle_animation(direction: Vector2):
	match direction:
		Vector2(0,-1):
			body_anim.play("idle_up")
		Vector2(0, 1):
			body_anim.play("idle_down")
		Vector2(-1, 0):
			body_anim.play("idle_left")
		Vector2(1, 0):
			body_anim.play("idle_right")
		Vector2(-1, -1):
			body_anim.play("idle_up_left")
		Vector2(1, -1):
			body_anim.play("idle_up_right")
		Vector2(-1, 1):
			body_anim.play("idle_down_left")
		Vector2(1, 1):
			body_anim.play("idle_down_right")

func _play_movement_animation(direction: Vector2):
	match direction:
		Vector2(0,-1):
			body_anim.play("walk_up")
		Vector2(0, 1):
			body_anim.play("walk_down")
		Vector2(-1, 0):
			body_anim.play("walk_left")
		Vector2(1, 0):
			body_anim.play("walk_right")
		Vector2(-1, -1):
			body_anim.play("walk_up_left")
		Vector2(1, -1):
			body_anim.play("walk_up_right")
		Vector2(-1, 1):
			body_anim.play("walk_down_left")
		Vector2(1, 1):
			body_anim.play("walk_down_right")
		Vector2(0, 0):
			body_anim.play("idle_down")

func _on_animation_finished():
	if 'melee' in body_anim.animation:
		can_melee_attack = true
		is_attacking = false
		_play_idle_animation(previous_direction)
	if 'range' in body_anim.animation:
		is_attacking = false
		_play_idle_animation(previous_direction)
