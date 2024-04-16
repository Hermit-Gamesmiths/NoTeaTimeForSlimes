extends Node2D

var injured: bool = false
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $Crushbox.has_overlapping_bodies():
		hurt(Projectile.DamageType.Crush)
	pass


func crushed() -> void:

	hurt(Projectile.DamageType.Crush)

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
	Events.wizard_died.emit()
	pass

func hurt_anim(damage_type: Projectile.DamageType) -> String:
	match damage_type:
		Projectile.DamageType.Fire:
			var sound_player = $DieSound
			sound_player.pitch_scale = randf_range(0.9, 1.1)
			sound_player.play(0.0)
			return "burn"
		Projectile.DamageType.Sharp:
			var sound_player = $DieSound
			sound_player.pitch_scale = randf_range(0.9, 1.1)
			sound_player.play(0.0)
			return "shot"
		Projectile.DamageType.Crush:
			var sound_playerr = $CrushSound
			sound_playerr.pitch_scale = randf_range(0.9, 1.1)
			sound_playerr.play(0.0)
			var sound_player = $DieSound
			sound_player.pitch_scale = randf_range(0.9, 1.1)
			sound_player.play(0.0)
			return "smoosh"

	assert(false, "Whoops, forgot to update this")
	return "burn"
