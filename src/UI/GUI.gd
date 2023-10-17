extends Control

onready var hp_progress_1 = $StatsContainer/HpProgress1
onready var mana_progress = $StatsContainer/ManaProgress

onready var fading_elements: Array = [hp_progress_1, mana_progress]

export (float) var fade_duration: float = 5.0
export (float) var fade_delay: float = 2.0


var stats_tween: SceneTreeTween


# Recupera la información de cuál es el Player actual desde GameState.
func _ready() -> void:
	GameState.connect("current_player_changed", self, "_on_current_player_changed")


## Cuando se asigna un Player nuevo, se conecta a las señales que
## interesan, y se refresca la data.
func _on_current_player_changed(player: Player) -> void:
	player.connect("hp_changed", self, "_on_hp_changed")
	_on_hp_changed(player.hp, player.max_hp)

	player.connect("mana_changed", self, "_on_mana_changed")
	_on_mana_changed(player.mana, player.max_mana)


# Callback de cambio de HP.
func _on_hp_changed(hp: int, hp_max: int) -> void:
	hp_progress_1.max_value = hp_max
	hp_progress_1.value = hp
	_animate_fade()

func _on_mana_changed(mana: int, mana_max: int) -> void:
	mana_progress.max_value = mana_max
	mana_progress.value = mana
	_animate_fade()

# Función de ayuda para animar el fade-out de elementos de la escena.
func _animate_fade() -> void:
	if !is_inside_tree():
		return
	
	if stats_tween:
		stats_tween.kill()
	stats_tween = create_tween()
	
	for element in fading_elements:
		element.modulate = Color.white
		stats_tween.set_parallel().tween_property(element, "modulate", Color.transparent, fade_duration).set_trans(Tween.TRANS_SINE).set_delay(fade_delay)
