extends Node

@export var is_active: bool = false

@export var falling_speed = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var parent: CharacterBody2D = get_parent()
	if is_active:
		parent.velocity = Vector2(0, falling_speed)
		parent.move_and_slide()
		# parent.move_and_collide(Vector2(0, falling_speed) * delta)
	pass

func activate(sender) -> void:
	is_active = true
