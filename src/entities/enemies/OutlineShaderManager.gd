extends AnimatedSprite

const outline_shader = preload("res://Shaders/outline.tres")

func set_outline():
	material.set_shader(outline_shader)

func remove_outline():
	material.set_shader(null)
