extends Node2D

@onready var animation:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate() -> void:
	animation.play("extend")


func telegraph() -> void:
	animation.play("expose")


func deactivate() -> void:
	animation.play("retract")
