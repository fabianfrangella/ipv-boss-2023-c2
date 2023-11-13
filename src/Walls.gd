extends TileMap
onready var player = $"../Entities/Player"
onready var area_2d = $Area2D
onready var walls = $"."

func changeDoorTile():	
	var tile_id = self.get_cellv(self.world_to_map(area_2d.global_position))
	if tile_id == 69:
		walls.set_cellv(self.world_to_map(area_2d.global_position), 57)
	player.get_node("Listener2D/DoorCloseSound").play()
