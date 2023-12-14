extends AttackState

export (PackedScene) var summon_scene_range: PackedScene
export (PackedScene) var summon_scene_melee: PackedScene
onready var timer: Timer = $Timer
onready var enemies_container = $EnemiesContainer

var can_summon = true

func handle_state(delta):
	if (can_summon):
		can_summon = false
		_summon(enemies_container.get_node("Enemy_1").global_position, "Enemy_1", "range")
		_summon(enemies_container.get_node("Enemy_2").global_position, "Enemy_2", "range")
		_summon(enemies_container.get_node("Enemy_3").global_position, "Enemy_3", "melee")
		_summon(enemies_container.get_node("Enemy_4").global_position, "Enemy_4", "melee")

func _summon(summon_position, enemy_name, name):
	var enemy
	if (name == "melee"):
		enemy = summon_scene_melee.instance()
	if (name == "range"):
		enemy = summon_scene_range.instance()
		enemy.pathfinding_path = get_parent().boss.pathfinding_path 
	enemy.name = enemy_name
	enemy.global_position = summon_position
	get_parent().boss.get_parent().add_child(enemy)

func _on_Timer_timeout():
	can_summon = true
