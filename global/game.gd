extends Node

@export var level_list:LevelCollection
@export_file("*.tscn", "*.scn") var end_scene := ""


var level_index: int = 0
var current_level_scene:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("game ready")
	Events.level_loaded.connect(level_loaded)
	Events.player_died.connect(player_died)
	Events.level_finished.connect(level_complete)


func level_loaded(level: Level) -> void:
	print("level loaded")
	current_level_scene = level.scene_file_path


func player_died() -> void:
	print("played died")
	TransitionManager.transition_to(current_level_scene)
	pass


func level_complete() -> void:
	level_index = level_index + 1
	if level_index >= len(level_list.levels):
		TransitionManager.transition_to(end_scene)
	else:
		TransitionManager.transition_to(level_list.levels[level_index].path)
