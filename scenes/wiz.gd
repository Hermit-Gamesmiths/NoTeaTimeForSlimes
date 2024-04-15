extends Node2D

var injured: bool = false
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
	if !injured:
		play_drink()


func play_drink() -> void:
	$AnimationPlayer.play("drink")
	var time := randf_range(2.0, 3.0)
	await get_tree().create_timer(time).timeout
	if !injured:
		play_idle()


func hurt(damage_type: Projectile.DamageType) -> void:
	if injured: return
	injured = true
	$AnimationPlayer.play(hurt_anim(damage_type))
	pass

func hurt_anim(damage_type: Projectile.DamageType) -> String:
	match damage_type:
		Projectile.DamageType.Fire: return "burn"

	assert(false, "Whoops, forgot to update this")
	return "burn"
