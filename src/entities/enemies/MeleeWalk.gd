extends AbstractEnemyState

export (float) var speed: float = 10.0
export (float) var max_speed: float = 100.0
export (float) var pathfinding_step_threshold: float = 1.0
export (Vector2) var wander_radius:Vector2 = Vector2(10.0, 10.0)
var path:Array = []
func enter() ->void:
	if character.target != null:
		var player_position = character.target.position
		var target_position = (player_position - character.position).normalized()
		if character.position.distance_to(player_position) < 10:
			emit_signal("finished","idle")
	else:
		if character.target != null:
			character._play_animation("walk_alert")
		else:
			character._play_animation("idle")
		character.play_sound("walk")
	
		
func exit() -> void:
	path=[]

func update(delta:float) ->void:
	if character.target == null:
		emit_signal("finished","idle")
		return
	var player_position = character.target.position
	var target_position = (player_position - character.position).normalized()

	if character.position.distance_to(player_position) < 10:
		emit_signal("finished","idle")
		return
	
	character.velocity = (character.velocity + character.global_position.direction_to(player_position) *speed).clamped(max_speed)

	character._apply_movement()
	character._play_animation("walk")
	
func _handle_body_entered(body) -> void:
	._handle_body_entered(body)
	character._play_animation("walk")
	
func _handle_body_exited(body:Node) -> void:
	._handle_body_exited(body)
	character._play_animation("go_normal")
	
func _on_animation_finished(anim_name: String) -> void:
	var full_normal_animation_name = "go_normal_" + character.direccion
	var full_alert_animation_name = "alert_" + character.direccion
	match anim_name:
		full_alert_animation_name:
			character._play_animation("walk_alert")
		
		full_normal_animation_name:
			character._play_animation("walk")
