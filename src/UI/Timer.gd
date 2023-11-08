extends Timer
onready var label = $"../Label"

var tiempo_transcurrido = 0

func _ready():
	connect("timeout", self, "_on_timer_timeout")
	if Checkpoint.time != null:
		tiempo_transcurrido = Checkpoint.time

func _on_Timer_timeout():
	tiempo_transcurrido += 1
	actualizar_etiqueta()

func actualizar_etiqueta():
	var minutos = int(tiempo_transcurrido / 60)
	var segundos = int(tiempo_transcurrido % 60)
	var tiempo_formateado = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)
	label.text = tiempo_formateado
	Checkpoint.time = tiempo_transcurrido
