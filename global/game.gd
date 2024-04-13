extends Node

var current_level_scene:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("game ready")
	Events.level_loaded.connect(level_loaded)
	Events.player_died.connect(player_died)
	pass # Replace with function body.


func level_loaded(level: Level) -> void:
	print("level loaded")
	current_level_scene = level.scene_file_path


func player_died() -> void:
	print("played died")
	TransitionManager.transition_to(current_level_scene)
	pass
