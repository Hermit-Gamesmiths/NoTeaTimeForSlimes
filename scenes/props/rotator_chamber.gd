extends Node2D

enum Direction {
	CW = 1,
	CCW = -1,
}

@export var detector: Area2D

@export var rotation_direction:Direction = Direction.CW
@export var flipflop: bool = true

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
func _process(_delta: float) -> void:
	scale.x = sign(rotation_direction)

func activate(_sender) -> void:
	for thing in detector.get_overlapping_areas():
		var target = thing.get_parent()
		create_tween().tween_property(target, "global_rotation", target.global_rotation + (PI / 2 * rotation_direction), .15)
	if flipflop:
		rotation_direction = Direction.CW if rotation_direction == Direction.CCW else Direction.CCW
