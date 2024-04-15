extends Node2D

## This is expected to be a child element of this component
@export var projectile_prototype: Projectile

func _ready() -> void:
	projectile_prototype.get_parent().remove_child(projectile_prototype)

func activate() -> void:
	var projectile = projectile_prototype.duplicate() as Projectile
	Game.current_level.add_child(projectile)
	projectile.projectile_velocity.x *= sign(scale.x)
	projectile.scale.x = sign(scale.x)
	projectile.global_position = global_position
	pass # TODO: animation

func telegraph() -> void:
	pass # TODO: animation

func deactivate() -> void:
	pass # TODO: animation
