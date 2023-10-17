extends Node2D

export (PackedScene) var projectile_scene: PackedScene
onready var weapon_tip: Node2D = $WeaponTip
var projectile_container: Node
var fire_tween: SceneTreeTween
var is_using_joystick = false
onready var player = $"../.."
const ATTACK_MODES = preload("res://entities/player/AttackModes.gd")
export (float) var mana_drain: float = 2.0



func fire() -> void:

	## Mato al tween antes de disparar para que no me cambie la rotación
	if fire_tween != null:
		fire_tween.kill()
	
	## No disparo de inmediato, sino que delego a una animación de disparo
	_fire()


## La animación de disparo llama a esta función que va a ser la que instancie
## el proyectil
func _fire() -> void:
	if player.currentAttackMode == ATTACK_MODES.RANGE && player.mana >= mana_drain:
		projectile_scene.instance().initialize(projectile_container, weapon_tip.global_position, global_position.direction_to(weapon_tip.global_position))
		player.sum_mana(-mana_drain)
	elif player.currentAttackMode == ATTACK_MODES.MELEE:
		projectile_scene.instance().initialize(projectile_container, weapon_tip.global_position, global_position.direction_to(weapon_tip.global_position))

