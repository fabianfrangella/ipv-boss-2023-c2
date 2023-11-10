extends Control

onready var hp_progress_1 = $StatsContainer/HpProgress1
onready var mana_progress = $StatsContainer/ManaProgress
onready var potions_amount = $ItemsContainer/PotionsAmount
onready var items_container = $ItemsContainer
onready var deaths_amounts = $DeathsContainer/DeathsAmounts
onready var timer = $ScoreContainer/Timer
onready var hp_text = $StatsContainer/HpProgress1/HpText
onready var mana_text = $StatsContainer/ManaProgress/ManaText
onready var boss_hp = $StatsContainer/BossHpProgress

onready var fading_elements: Array = [hp_progress_1, mana_progress]

export (float) var fade_duration: float = 5.0
export (float) var fade_delay: float = 2.0
var canshow : bool = false

var stats_tween: SceneTreeTween
var deaths: int = -1
var time: Timer

# Recupera la información de cuál es el Player actual desde GameState.
func _ready() -> void:
	GameState.connect("current_player_changed", self, "_on_current_player_changed")
	deaths = Checkpoint.deaths
	boss_hp.value = 100
	boss_hp.hide()

## Cuando se asigna un Player nuevo, se conecta a las señales que
## interesan, y se refresca la data.
func _on_current_player_changed(player: Player) -> void:
	player.connect("hp_changed", self, "_on_hp_changed")
	_on_hp_changed(player.hp, player.max_hp)

	player.connect("mana_changed", self, "_on_mana_changed")
	_on_mana_changed(player.mana, player.max_mana)
	
	player.connect("potions_changed", self, "_on_potions_changed")
	_on_potions_changed(player.potions)

	player.connect("deaths_changed", self, "_on_deaths_changed")
	_on_deaths_changed()


# Callback de cambio de HP.
func _on_hp_changed(hp: int, hp_max: int) -> void:
	hp_progress_1.max_value = hp_max
	hp_progress_1.value = hp
	hp_text.text = str(hp, "/", hp_max)


func _on_mana_changed(mana: int, mana_max: int) -> void:
	mana_progress.max_value = mana_max
	mana_progress.value = mana
	mana_text.text = str(mana, "/", mana_max)

func _on_potions_changed(potions: int) -> void:
	potions_amount.text = str(potions)
	if potions == 0 && !canshow:
		items_container.hide()
		canshow = true
	if potions > 0:
		items_container.show()
		
	
func _on_deaths_changed() -> void:
	Checkpoint.deaths = deaths
	deaths = deaths + 1
	deaths_amounts.text = str(deaths)
	
func on_boss_hp_changed(hp: int, hp_max: int):
	boss_hp.max_value = hp_max
	boss_hp.value = hp

func _on_Boss_boss_found():
	boss_hp.show()


func _on_Boss_hp_changed(hp: int, hp_max: int):
	boss_hp.max_value = hp_max
	boss_hp.value = hp

