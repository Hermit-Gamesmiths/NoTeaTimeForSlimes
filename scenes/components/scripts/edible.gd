extends Area2D
class_name Edible

var parent_rotation: float = 0

@onready var parent: Node2D = get_parent()
@export var modified_jump: Jump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pack(target:Node2D) -> void:
	# TODO: send true and animate flowing into the player/shrinking using a tween.
	parent_rotation = parent.global_rotation
	print("ate rotation ", parent_rotation)
	self.reparent(target, true)
	parent.get_parent().remove_child(parent)
	global_rotation = 0


func unpack(world: Node, location: Vector2) -> void:
	# HACK: This is a workaround to an INSANE issue with the previous position of the object
	var colliders = parent.find_children("*", "CollisionShape2D", true, false)
	for child:CollisionShape2D in colliders:
		print("OFF")
		child.disabled = true
	parent.global_position = location
	world.add_child(parent)
	self.reparent(parent, true)
	await get_tree().physics_frame
	for child:CollisionShape2D in colliders:
		child.disabled = false

	rotation = 0
	parent.global_rotation = parent_rotation
