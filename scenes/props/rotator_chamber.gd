extends Node2D

@export var detector: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate() -> void:
	for thing in detector.get_overlapping_bodies():
		thing.global_rotation += PI / 2
