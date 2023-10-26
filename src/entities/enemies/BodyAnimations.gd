extends Node

onready var body_anim: AnimatedSprite = $Demon

func _ready():
	body_anim.play("idle_down")
