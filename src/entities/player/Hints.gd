extends Label


var is_hide = false

func _process(delta):
	if (Input.is_action_just_pressed("hints")):
		if (is_hide):
			self.show()
			is_hide = false
		else:
			self.hide()
			is_hide = true
