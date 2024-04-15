extends Node2D
class_name ContactActivator

const COLLISION_LISTENER = "collision_listener"

@export var body: PhysicsBody2D = get_parent()
var target: Node

func _enter_tree() -> void:
	target = get_parent()
	if body == null || target == null:
		printerr("Contact activator is a hack and needs both body and target to be set, do so.")

	body.set_meta(COLLISION_LISTENER, self)

func _exit_tree() -> void:
	body.remove_meta(COLLISION_LISTENER)

func on_collision() -> void:
	if target.has_method("activate"):
		target.activate(self)
