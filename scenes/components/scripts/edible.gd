extends Area2D
class_name Edible

@onready var parent: Node2D = get_parent()
@export var modified_jump: Jump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pack(target) -> void:
	# TODO: send true and animate flowing into the player/shrinking using a tween.
	self.reparent(target, true)
	parent.get_parent().remove_child(parent)
	global_rotation = 0


func unpack(world: Node, location: Vector2) -> void:
	# HACK: This is a workaround to an INSANE issue with the previous position of the object
	for child:CollisionShape2D in parent.find_children("*", "CollisionShape2D"):
		child.disabled = true
	parent.global_position = location
	world.add_child(parent)
	self.reparent(parent, true)
	await get_tree().physics_frame
	for child:CollisionShape2D in parent.find_children("*", "CollisionShape2D"):
		child.disabled = false

	global_rotation = 0
