extends Button

func _ready() -> void:
	self.pressed.connect(on_press)

func on_press():
	get_tree().quit()
