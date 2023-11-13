extends AttackMode

signal player_shoot

var sound = preload("res://Sounds/Spell/Magic Spell_Simple Swoosh_6.wav")
func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack") && body.mana >= 2.0:
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.range_weapon.projectile_container == null:
			body.range_weapon.projectile_container = body.projectile_container
		body.range_weapon.fire()
		body.body_anim.set_state('range')
		self.can_attack = false
		_play_sound(body)
		
func _play_sound(body):
	var player = body.audio_container.get_node("Spell")
	player.stream = sound
	player.play()
