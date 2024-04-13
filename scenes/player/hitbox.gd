extends Area2D
class_name Hitbox

signal on_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(hit_by)
	self.body_entered.connect(hit_by)


func hit_by(something) -> void:
	print("hit by: ", something)
	on_hit.emit()
	pass
