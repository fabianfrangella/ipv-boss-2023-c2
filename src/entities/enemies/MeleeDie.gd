extends AbstractEnemyState


func enter() -> void:
	character.dead = true
	character.collision_layer = 0
	character.collision_mask = 0
	character._play_animation("die")
	character.play_sound("death")

func _on_animation_finished(anim_name:String) -> void:
	character._remove()
