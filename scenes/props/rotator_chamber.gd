extends Node2D

@export var detector: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector.area_entered.connect(on_enter)
	pass # Replace with function body.

func on_enter(area: Area2D):
	var target
	if area.has_method("get_snap_target"):
		target = area.get_snap_target()
	if !target:
		target = area.get_parent()
	create_tween().tween_property(target, "position", position, .15)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate() -> void:
	for thing in detector.get_overlapping_areas():
		thing.get_parent().global_rotation += PI / 2
