extends Node2D


onready var lifetime_timer: Timer = $LifetimeTimer
onready var hitbox: Area2D = $Hitbox
onready var projectile_animations: AnimationPlayer = $ProjectileAnimations
onready var audio = $AudioStreamPlayer2D

export (float) var VELOCITY: float = 800.0
var damage: int = 1
var direction: Vector2
var hitbox_exceptions = []
var has_animated_sprite = false

func initialize(container: Node, spawn_position: Vector2, direction: Vector2, dmg: int = 1, skip_hitboxes = ["PlayerHitbox", "Player"], has_animated_sprite = false) -> void:
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	rotation = direction.angle()
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()
	damage = dmg
	## Ahora definimos que la implementación de proyectiles usará un AnimationPlayer
	## que contendrá 3 animaciones claves: fire_start, fire_loop y hit.
	## Acá lo que hacemos es definir que iniciará con "fire_start" para darle
	## un arranque, y encolamos a "fire_loop" para que se reproduzca solo.
	
	## Un factor importante es que cada escena que herede de esta debe implementar
	## su propia variación de la animación, seleccionando el nodo de AnimationPlayer
	## y volviendo únicos a la escena sus sub-recursos, para que no se mezclen con los otros
	## hermanos, ya que las animaciones califican como "Resources" y son únicos, y,
	## por lo tanto, compartidos.
	self.has_animated_sprite = has_animated_sprite
	if (has_animated_sprite):
		$ProjectileSprite.play("fire")
	else:
		projectile_animations.play("fire_start")
		projectile_animations.queue("fire_loop")
	hitbox_exceptions = skip_hitboxes


func _physics_process(delta: float) -> void:
	position += direction * VELOCITY * delta


func _on_lifetime_timer_timeout() -> void:
	remove()


func remove() -> void:
	hitbox.collision_mask = 0
	set_physics_process(false)
	
	get_parent().remove_child(self)
	queue_free()


## Esta función se llamaría desde "hit" al terminar la animación
func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()

func _on_Hitbox_area_entered(body):
	if (hitbox_exceptions.has(body.name)):
		return
	if body.get_parent().has_method("notify_hit"):
		body.get_parent().notify_hit(damage)
		audio.play()
