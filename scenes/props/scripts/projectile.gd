extends CharacterBody2D
class_name Projectile

@export var projectile_velocity: Vector2

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(projectile_velocity * delta)

	if collision != null:
		var collider = collision.get_collider()
		if collider.has_method("hurt"):
			collider.hurt()
		call_deferred('queue_free') # Deferred so the player has time to get hit.
		# TODO: Add animation for projectile hitting wall/player
