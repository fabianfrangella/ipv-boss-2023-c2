extends Node2D


var picked: bool = false
export (StreamTexture) var image: StreamTexture
export (String) var objectName: String
export (float) var scaleSprite: float
onready var sprite = $Sprite
onready var audio = $AudioContainer

func _ready():
	sprite.texture = image
	sprite.scale.x = scaleSprite
	sprite.scale.y = scaleSprite

func _on_PickupArea_body_entered(body):
	if body is Player && !picked:
		match objectName:
			"potion":
				body.set_potions()
				audio.get_node("Potion").play()
			"armor":
				body.set_armor()
				audio.get_node("Armor").play()
			"gsword":
				body.set_gsword()
				audio.get_node("GSword").play()
			"staff":
				body.set_staff()
				audio.get_node("Staff").play()
		picked = true
		self.hide()
