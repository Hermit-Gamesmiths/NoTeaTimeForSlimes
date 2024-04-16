extends Node

@export var level_list:LevelCollection
@export_file("*.tscn", "*.scn") var end_scene := ""
@export_file("*.tscn", "*.scn") var good_end_scene := ""


var level_index: int = 0
var current_level: Level
var current_level_scene: String
var has_killed_wizard:bool = false

var times_wizard_died:int = 0

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	Events.level_loaded.connect(level_loaded)
	Events.player_died.connect(player_died)
	Events.level_finished.connect(level_complete)
	Events.wizard_died.connect(wizard_died)


func level_loaded(level: Level) -> void:
	has_killed_wizard = false
	current_level_scene = level.scene_file_path
	current_level = level


func player_died() -> void:
	has_killed_wizard = false
	TransitionManager.transition_to(current_level_scene)
	pass


func wizard_died() -> void:
	has_killed_wizard = true


func level_complete() -> void:
	level_index = level_index + 1
	if has_killed_wizard:
		times_wizard_died += 1

	if level_index >= len(level_list.levels):
		level_index = 0
		print("Fin")
		current_level_scene = ""
		if times_wizard_died >= len(level_list.levels):
			TransitionManager.transition_to(good_end_scene)
		else:
			TransitionManager.transition_to(end_scene)
	else:
		TransitionManager.transition_to(level_list.levels[level_index].path)


func start():
	TransitionManager.transition_to(level_list.levels[level_index].path)
