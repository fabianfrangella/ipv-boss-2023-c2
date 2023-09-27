extends AttackMode

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func handle_attack():
	if Input.is_action_pressed("attack"):
		print("melee attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
