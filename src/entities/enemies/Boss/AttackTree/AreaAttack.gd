extends AttackState

onready var explosion_container = $ExplosionContainer
onready var explosion_animations = $ExplosionContainer/Explosions
onready var area_animations = $ExplosionContainer/Area

var time_since_last_attack = 0
var damage_per_explosion = 15

signal area_attack

func _ready():
	explosion_animations.hide()
	area_animations.hide()

func handle_state(delta):
	time_since_last_attack+= delta
	if (time_since_last_attack > 5):
		emit_signal("area_attack")
		time_since_last_attack = 0
		explosion_container.global_position = get_parent().boss.target.global_position
		var area = area_animations.get_node("Area")
		area_animations.show()
		area.show()
		area.play("appear")

func _on_Explosion_animation_finished():
	var explosions = [
		explosion_animations.get_node("Explosion"),
		explosion_animations.get_node("Explosion2"),
		explosion_animations.get_node("Explosion3"),
		explosion_animations.get_node("Explosion4")
	]
	for explosion in explosions:
		explosion.stop()
		explosion.position = explosion_container.position
	explosion_animations.hide()
	
	area_animations.get_node("Area").get_child(0).queue_free()

func _play_explosions():
	explosion_animations.show()
	var explosions = [
		explosion_animations.get_node("Explosion"),
		explosion_animations.get_node("Explosion2"),
		explosion_animations.get_node("Explosion3"),
		explosion_animations.get_node("Explosion4")
	]
	for explosion in explosions:
		var random_range = rand_range(-40, 40)
		var rand_position = Vector2(random_range, random_range)
		explosion.position = rand_position
		explosion.play("explode")

func _on_Area_animation_finished():
	var area = area_animations.get_node("Area")
	area.hide()
	area.stop()
	_play_explosions()
	var explosion_area = _create_area()
	explosion_area.connect("body_entered", self, "on_explosion_hit")
	area.add_child(explosion_area)
	

func on_explosion_hit(node):
	if (node.name == "Player"):
		node.notify_hit(damage_per_explosion)

func _create_area():
	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	shape.shape = circle_shape
	shape.scale = Vector2(4,4)
	area.add_child(shape)
	return area
	
