extends Area2D
onready var walls = $"../../../Walls"


func _on_Area2D_body_entered(body):
	walls.changeDoorTile()
