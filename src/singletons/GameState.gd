extends Node

signal current_player_changed(player)

var current_player: Player

signal level_won()

func set_current_player(player: Player) -> void:
	current_player = player
	emit_signal("current_player_changed", player)

func notify_input_map_changed() -> void:
	emit_signal("input_map_changed")

func notify_level_won() -> void:
	emit_signal("level_won")
