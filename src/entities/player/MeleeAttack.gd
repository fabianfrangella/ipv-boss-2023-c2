extends AttackMode


func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack") && body.can_melee_attack:
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.weapon.projectile_container == null:
			body.weapon.projectile_container = body.projectile_container
		body.weapon.fire()
		body.body_anim.play("melee")
		body.can_melee_attack = false
