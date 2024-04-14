extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred('setup') # So the level is initialized


func setup() -> void:
	var bounds = Game.current_level.get_level_bounds()

	limit_left = bounds.position.x
	limit_right = bounds.end.x
	limit_top = bounds.position.y
	limit_bottom = bounds.end.y
