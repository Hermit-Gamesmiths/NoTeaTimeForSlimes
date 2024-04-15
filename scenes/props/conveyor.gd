@tool
extends StaticBody2D

enum Mode {
	Flip,
	Enable,
}

enum Direction {
	Left = -1,
	Right = 1,
}

@export var is_active: bool = true
@export var activator_mode: Mode = Mode.Enable
@export var speed: float = 300
@export var direction: Direction = Direction.Left
@onready var current_direction: int = direction

func activate(sender):
	print("toggle conveyor")
	toggle(true)


func deactivate(_sender):
	toggle(false)


func toggle(switch:bool):
	match activator_mode:
		Mode.Flip:
			current_direction = direction * -1 if switch else 1
		Mode.Enable:
			is_active = switch

func _process(_delta: float)->void:
	$ArrowSprite.scale.x = -current_direction
	constant_linear_velocity = Vector2(speed * current_direction, 0) if is_active else Vector2.ZERO

	if not Engine.is_editor_hint():
		if is_active:
			$AnimationPlayer.play("active")
		else:
			$AnimationPlayer.play("inactive")
	else:
		$ArrowSprite.scale.x = -direction
