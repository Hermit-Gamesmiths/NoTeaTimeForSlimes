extends Node2D
class_name Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.level_loaded.emit(self)
