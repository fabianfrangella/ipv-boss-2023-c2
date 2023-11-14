extends Listener2D

onready var boss_music = $BossMusic
onready var music = $Music

var timer = Timer.new()

func _on_Boss_boss_found():
	timer.wait_time = 5.0
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.start()
	
func _on_timer_timeout():
	music.stop()
	boss_music.play()
	timer.disconnect("timeout", self, "_on_timer_timeout")
	timer.queue_free()
