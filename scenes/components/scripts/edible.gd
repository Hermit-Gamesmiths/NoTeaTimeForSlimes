extends Area2D
class_name Edible

var target_rotation: float = 0

@onready var parent: Node2D = get_parent()
## The node to remove, Target is assumed to be above the parent FYI
@export var target: Node2D
@export var modified_jump: Jump

var original_scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !target:
		target = parent
	pass # Replace with function body.


func pack(destination:Node2D) -> void:
	# TODO: send true and animate flowing into the player/shrinking using a tween.
	original_scale = target.global_scale
	target_rotation = target.global_rotation
	self.reparent(destination, true)
	target.get_parent().remove_child(target)
	global_rotation = 0


func unpack(world: Node, location: Vector2) -> void:
	# HACK: This is a workaround to an INSANE issue with the previous position of the object
	var colliders = target.find_children("*", "CollisionShape2D", true, false)
	for child:CollisionShape2D in colliders:
		child.disabled = true
	target.global_position = location
	world.add_child(target)
	self.reparent(parent, true)
	await get_tree().physics_frame
	for child:CollisionShape2D in colliders:
		child.disabled = false

	rotation = 0
	target.global_rotation = target_rotation
