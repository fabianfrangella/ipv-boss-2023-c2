extends AbstractEnemyState



func enter() -> void:
	character.velocity = Vector2.ZERO
	
	fire()

func fire()->void:
	character._fire()
	character._play_animation("attack")
	
func update(delta)->void:
	character._look_at_target()
	
func _on_animation_finished(anim_name:String) -> void:
	var full_attack_animation_name = "attack_" + character.direccion
	var full_alert_animation_name = "alert_" + character.direccion
	
	if character.target == null:
		emit_signal("finished","idle")
	else:
		match anim_name:
			full_attack_animation_name:
				character._play_animation("alert")
			full_alert_animation_name:
				if character._can_see_target():
					fire()
				else:
					emit_signal("finished","idle")
					
func _handle_body_exited(body) -> void:
	._handle_body_exited(body)
	
	if character.target == null:
		if character.get_current_animation() != ("attack_" + character.direccion):
			emit_signal("finished","idle")
