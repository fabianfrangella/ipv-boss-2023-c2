extends AttackMode

func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack") && body.body_anim.can_melee_attack && not body.body_anim.is_attacking :
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.weapon.projectile_container == null:
			body.weapon.projectile_container = body.projectile_container
		body.body_anim.play_attack('melee')
		body.weapon.fire()
