extends CanvasLayer

# This class is adapted from the transition_mgr in https://github.com/jhlothamer/godot_project_starter
# Currently only minor updates for project consistency but may be wholly replaced later.

# In the future we could create a "Transition" class that would be added as a child of this node
# and provide fancier customizable transitions. Including camera zooms and such.

# I suspect this might do weird things when you've got volume changes in settings, but I'm not sure.
@onready var _starting_bus_volume = AudioServer.get_bus_volume_db(0)

@export var animation_progress = 1.0: set = set_for_anim_db
var _scene_path := ""
var _animation_speed := 1.0
var _do_volume_anim := false
var _mute_bus_volume := - 80.0
var _default_speed := .5

func _ready():
	$TransitionAnimation.animation_finished.connect(_on_animation_finished)

	var temp = ProjectSettings.get_setting("global/transition_mgr_default_speed")
	if !temp:
		printerr("TransitionMgr: no Transition Mgr Default Speed project setting found.  Using default speed of .5 seconds.")
		return
	if temp <= 0.0:
		printerr("TransitionMgr: default speed must be > 0.0.  Using default speed of .5 seconds.")
		return
	_default_speed = temp

func set_for_anim_db(value: float) -> void:
	animation_progress = value
	if _do_volume_anim:
		AudioServer.set_bus_volume_db(0, _mute_bus_volume - animation_progress * (_mute_bus_volume - _starting_bus_volume))

func transition_to(scene_path: String, speed_seconds: float=- 1.0, include_sound=false):
	if speed_seconds <= 0.0:
		speed_seconds = _default_speed
	_scene_path = scene_path
	_animation_speed = 2.0 / speed_seconds
	_do_volume_anim = include_sound
	$TransitionAnimation.play("fadeOut", -1, _animation_speed)

func _on_animation_finished(anim_name):
	print("animation finished")
	if anim_name == "fadeOut":
		var results = get_tree().change_scene_to_file(_scene_path)
		if results != OK:
			printerr("TransitionMgr: could not change to scene '%s'" % _scene_path)
			return
		get_tree().paused = false
		$TransitionAnimation.play("fadeIn", -1, _animation_speed)
