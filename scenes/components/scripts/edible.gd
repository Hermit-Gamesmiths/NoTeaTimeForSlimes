extends Area2D
class_name Edible

@onready var parent: Node2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pack(target) -> void:
	# TODO: send true and animate flowing into the player/shrinking using a tween.
	self.reparent(target, false)
	parent.get_parent().remove_child(parent)


func unpack(world: Node, location: Vector2) -> void:
	world.add_child(parent)
	parent.position = location
	self.reparent(parent, false)
