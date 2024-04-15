extends Area2D
class_name Projectile

enum DamageType {
	Fire,
	Sharp,
}

## This could break at any time if I don't set a reference rotation first....
@export var projectile_velocity: Vector2
@export var lifetime:float = -1

@export var rand_deg: float = 0

@export var damage_type: DamageType = DamageType.Fire

var time_alive:float = 0

func _ready():
	var rand_angle = randf_range(-rand_deg, +rand_deg)
	projectile_velocity = projectile_velocity.rotated(deg_to_rad(rand_angle))

func _physics_process(delta: float) -> void:
	time_alive += delta
	if lifetime != -1 && time_alive > lifetime:
		queue_free()

	position = position + projectile_velocity * delta

	for body in get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage_type)
		call_deferred('queue_free') # Deferred so the player has time to get hit.
		# TODO: Add animation for projectile hitting wall/player

func rotate_to(rot: float):
	global_rotation = rot
	projectile_velocity = projectile_velocity.rotated(rot)
