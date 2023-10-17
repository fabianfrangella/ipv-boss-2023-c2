extends Node

signal current_player_changed(player)

var current_player: Player

func set_current_player(player: Player) -> void:
	current_player = player
	emit_signal("current_player_changed", player)
