extends Node2D

@export var is_active: bool = true
@export var one_shot: bool = true
@export var cooldown: float = .1
var time_since_shot: float = 0

## This is expected to be a child element of this component
@export var projectile_prototype: Projectile

func _ready() -> void:
	projectile_prototype.get_parent().remove_child(projectile_prototype)

func _process(delta: float) -> void:
	time_since_shot += delta
	if !one_shot && is_active && time_since_shot > cooldown:
		shoot()

func shoot() -> void:
	time_since_shot = 0
	var projectile = projectile_prototype.duplicate() as Projectile
	Game.current_level.add_child(projectile)
	projectile.projectile_velocity.x *= sign(scale.x)
	projectile.scale.x = sign(scale.x)
	projectile.global_position = global_position
	pass # TODO: animation

func activate() -> void:
	is_active = true
	shoot()
	pass

func telegraph() -> void:
	pass # TODO: animation

func deactivate() -> void:
	is_active = false
	pass # TODO: animation
