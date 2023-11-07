extends AbstractEnemyState

onready var idle_timer: Timer = $IdleTimer

func enter() ->void:
	character.velocity = Vector2.ZERO
	
	character._play_animation("idle")
		
	idle_timer.start()
	
func exit() -> void:
	idle_timer.stop()
	
func update(delta: float) -> void:
	character._apply_movement()
	
	if character._can_see_target():
		emit_signal("finished","walk")

func _on_IdleTimer_timeout():
	emit_signal("finished","walk")
	
func _handle_body_entered(body) -> void:
	._handle_body_entered(body)
	character._play_animation("walk")
	
func _handle_body_exited(body:Node) -> void:
	._handle_body_exited(body)
	character._play_animation("idle")
	
func _on_animation_finished(anim_name: String) -> void:
	var full_alert_animation_name = "alert_" + character.direccion
	var full_normal_animation_name = "go_normal_" + character.direccion
	match anim_name:
		full_alert_animation_name:
			character._play_animation("idle_alert")
		full_normal_animation_name:
			character._play_animation("idle")
