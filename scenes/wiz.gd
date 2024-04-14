extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_idle() -> void:
	$AnimationPlayer.play("idle")
	var time := randf_range(5.0, 12.0)
	await get_tree().create_timer(time).timeout
	play_drink()
	

func play_drink() -> void:
	$AnimationPlayer.play("drink")
	var time := randf_range(2.0, 3.0)
	await get_tree().create_timer(time).timeout
	play_idle()
