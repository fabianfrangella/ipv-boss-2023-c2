extends Node
onready var area_2d = $Area2D




func _on_Area2D_body_entered(body):
	Checkpoint.last_position = area_2d.global_position
