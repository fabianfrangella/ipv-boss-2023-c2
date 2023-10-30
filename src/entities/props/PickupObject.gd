extends Node2D


var picked: bool = false
export (StreamTexture) var image: StreamTexture
export (String) var objectName: String
export (float) var scaleSprite: float
onready var sprite = $Sprite

func _ready():
	sprite.texture = image
	sprite.scale.x = scaleSprite
	sprite.scale.y = scaleSprite

func _on_PickupArea_body_entered(body):
	if body is Player && !picked:
		match objectName:
			"potion":
				body.set_potions()
				
			"armor":
				body.set_armor()
			"gsword":
				body.set_gsword()
			"staff":
				body.set_staff()
		picked = true
		self.hide()
