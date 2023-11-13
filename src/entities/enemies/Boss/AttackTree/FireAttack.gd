extends AttackState

export (PackedScene) var projectile_scene: PackedScene
onready var timer = $Timer
onready var audio_player: AudioStreamPlayer2D = $FireSound

var can_attack = true

signal fire_attack

func handle_state(delta):
	if (can_attack):
		_fire()
		can_attack = false

func _on_Timer_timeout():
	can_attack = true

func _fire() -> void:
	emit_signal("fire_attack")
	var target_position = get_parent().boss.target.global_position
	projectile_scene.instance().initialize(self, 
											self.global_position, 
											self.global_position.direction_to(target_position), 
											get_parent().boss.fire_damage,
											["BossHitbox", "BasicEnemyHitbox"],
											true)
	audio_player.play()

