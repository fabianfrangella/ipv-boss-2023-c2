extends AttackMode

func _handle_attack(body: KinematicBody2D) -> void:
	if Input.is_action_just_pressed("attack"):
		print("range attack")
