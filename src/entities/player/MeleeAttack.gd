extends AttackMode

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _handle_attack(body: KinematicBody2D) -> void:
	body.weapon.process_input()
	if Input.is_action_just_pressed("attack"):
		if body.projectile_container == null:
			body.projectile_container = get_parent()
		if body.weapon.projectile_container == null:
			body.weapon.projectile_container = body.projectile_container
		body.weapon.fire()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
