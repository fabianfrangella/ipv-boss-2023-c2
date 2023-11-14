extends AbstractEnemyState


func enter() -> void:
	character.dead = true
	character.collision_layer = 0
	character.collision_mask = 0
	
	if character.target != null:
		character._play_animation("die")

	else:
		character._play_animation("die")
	character.play_sound("death")



func _on_animation_finished(anim_name:String) -> void:
	if anim_name in ["die_alert_"+ character.direccion ,"die_"+ character.direccion]:
		
		character._remove()
