extends AttackMode

const sounds = [
 preload("res://Sounds/sword/swing.wav"),
 preload("res://Sounds/sword/swing2.wav"),
 preload("res://Sounds/sword/swing3.wav")
]

func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack") && self.can_attack:
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.weapon.projectile_container == null:
			body.weapon.projectile_container = body.projectile_container
		body.body_anim.set_state('melee')
		body.weapon.fire()
		self.can_attack = false
		
		_play_sound(body)
		
func _play_sound(body):
	var sfx = sounds[randi() % sounds.size()]
	var player = body.audio_container.get_node("Sword")
	if (not player.playing):
		player.stream = sfx
		player.play()
