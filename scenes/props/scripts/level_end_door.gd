extends Node2D

@export var detector:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector.body_entered.connect(player_entered)
	pass # Replace with function body.

func player_entered(_body) -> void:
	Events.level_finished.emit()
