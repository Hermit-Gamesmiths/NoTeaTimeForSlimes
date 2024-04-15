extends Node2D

enum Mode {
	EveryHit,
	Toggle,
}

@export var target: SwitchActivator
@export var mode: Mode = Mode.Toggle
@export var is_active: bool = false

@export_group("Guts")
@export var anim: AnimationPlayer

func _ready() -> void:
	send_update()


func hurt(_damage_type):
	toggle()


func toggle():
	is_active = !is_active
	send_update()


func send_update():
	if is_active:
		anim.play("switch_on")
	else:
		anim.play("switch_off")

	if target:
		if mode == Mode.EveryHit:
			target.activate()
		elif is_active:
			target.activate()
		else:
			target.deactivate()
