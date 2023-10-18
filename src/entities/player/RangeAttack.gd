extends AttackMode

signal player_shoot

func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack"):
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.range_weapon.projectile_container == null:
			body.range_weapon.projectile_container = body.projectile_container
		body.range_weapon.fire()
