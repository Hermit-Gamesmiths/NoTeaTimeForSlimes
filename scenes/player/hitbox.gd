extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(on_hit)
	self.body_entered.connect(on_hit)


func on_hit(hit_by) -> void:
	print(hit_by)
	pass
