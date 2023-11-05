extends KinematicBody2D

signal hit(amount)

onready var fire_position: Node2D = $FirePosition

onready var raycast: RayCast2D = $RayCast2D
onready var body_anim: AnimatedSprite = $Body

export (float) var speed: float = 10.0
export (float) var max_speed: float = 100.0
export (float) var pathfinding_step_threshold: float = 5.0
export (Vector2) var wander_radius:Vector2 = Vector2(10.0, 10.0)
export (PackedScene) var projectile_scene: PackedScene


export (NodePath) var pathfinding_path: NodePath
onready var pathfinding: PathfindAstar = get_node_or_null(pathfinding_path)

var target: Node2D
var projectile_container: Node
var direccion: String = "down"
var velocity: Vector2 = Vector2.ZERO
var vdirection: Vector2 = Vector2.ZERO

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false

func initialize(container, turret_pos, projectile_container) -> void:
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container


func _fire() -> void:
	if target != null:
		var proj_instance: Node = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(
			projectile_container,
			fire_position.global_position,
			fire_position.global_position.direction_to(target.global_position)
		)


func _look_at_target() -> void:
		pass
		
func _apply_movement()-> void:
	velocity = move_and_slide(velocity, vdirection)

func _can_see_target() -> bool:
	if target == null:
		return false	
	raycast.set_cast_to(raycast.to_local(target.global_position))
	raycast.force_raycast_update()
	set_direction_to(target)
	return raycast.is_colliding() && raycast.get_collider() == target

func set_direction_to(target: Node2D):
	 # Obtenemos las posiciones del personaje y el objetivo
	var character_position = global_transform.origin
	var target_position = target.global_transform.origin  # Reemplaza "target_node" con el nombre de tu nodo objetivo

	# Calculamos la diferencia en coordenadas X y Y entre el personaje y el objetivo
	var x_difference = target_position.x - character_position.x
	var y_difference = target_position.y - character_position.y

	# Determinamos la dirección en la que se encuentra el objetivo
	var direction = Vector2(x_difference, y_difference).normalized()
	vdirection = direction
	# Calculamos el valor absoluto de las diferencias en coordenadas X e Y
	var abs_x_difference = abs(x_difference)
	var abs_y_difference = abs(y_difference)

	if direction == Vector2(0, -1):
		# El objetivo está arriba del personaje
		direccion = "up"
	elif direction == Vector2(0, 1):
		# El objetivo está abajo del personaje
		direccion = "down"
	elif direction == Vector2(1, 0):
		# El objetivo está a la derecha del personaje
		direccion = "right"
	elif direction == Vector2(-1, 0):
		# El objetivo está a la izquierda del personaje
		direccion = "left"
	elif abs_x_difference > 0 and abs_y_difference > 0:
		# El objetivo está en una diagonal
		# Puedes determinar en cuál de las cuatro diagonales se encuentra
		if x_difference > 0 and y_difference > 0:
			# El objetivo está en la diagonal superior derecha
			direccion = "down_right"
		elif x_difference > 0 and y_difference < 0:
			# El objetivo está en la diagonal inferior derecha
			direccion = "up_right"
		elif x_difference < 0 and y_difference > 0:
			# El objetivo está en la diagonal superior izquierda
			direccion = "down_left"
		elif x_difference < 0 and y_difference < 0:
			# El objetivo está en la diagonal inferior izquierda
			direccion = "up_right"

## Esta función ya no llama directamente a remove, sino que inhabilita las
## colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
## dependiendo de si el enemigo esta o no alerta
func notify_hit(amount: int=1) -> void:
	emit_signal("hit",amount)
	pass

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	
	if body_anim.frames.has_animation(animation + "_" + direccion):
		body_anim.play(animation + "_" + direccion)

func get_current_animation() -> String:
	return body_anim.animation
