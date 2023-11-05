extends AttackState

export (PackedScene) var summon_scene: PackedScene
onready var timer: Timer = $Timer
onready var enemies_container = $EnemiesContainer

var can_summon = true

func handle_state(delta):
	if (can_summon):
		can_summon = false
		_summon(enemies_container.get_node("Enemy_1").position, "Enemy_1")
		_summon(enemies_container.get_node("Enemy_2").position, "Enemy_2")
		_summon(enemies_container.get_node("Enemy_3").position, "Enemy_3")
		_summon(enemies_container.get_node("Enemy_4").position, "Enemy_4")

func _summon(summon_position, enemy_name):
	var enemy = summon_scene.instance()
	enemy.name = enemy_name
	enemy.global_position = summon_position
	enemy.scale = Vector2(0.25, 0.25)
	enemy.pathfinding_path = get_parent().boss.pathfinding_path
	add_child(enemy)

func _on_Timer_timeout():
	can_summon = true
