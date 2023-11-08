extends Area2D

# Variables para controlar si el jugador puede pasar a través del piso
var canPass = false

func _ready():
	# Configura las señales para detectar cuando el jugador se acerca
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area):
	# Comprueba si el área que entra es el jugador y si puede pasar
	if area.is_in_group("player") and canPass:
		# Permite al jugador pasar a través del piso
		area.get_parent().canPassThrough = true

func _on_area_exited(area):
	# Restablece la capacidad del jugador para pasar a través del piso cuando sale
	if area.is_in_group("player"):
		area.get_parent().canPassThrough = false
