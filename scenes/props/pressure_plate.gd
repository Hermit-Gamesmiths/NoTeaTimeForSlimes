extends Node2D

@export var target: SwitchActivator
@export var inverse_activation: bool = false

@export_group("guts")
@export var detector: Area2D

var is_active: bool = false


func _physics_process(_delta):
	if detector.has_overlapping_bodies() && !is_active:
		pressed()
	if !detector.has_overlapping_bodies() && is_active:
		depressed()


func pressed():
	$AnimationPlayer.play("press")
	is_active = true
	if inverse_activation: _do("deactivate")
	else: _do("activate")


func depressed():
	$AnimationPlayer.play("release")
	is_active = false
	if inverse_activation: _do("activate")
	else: _do("deactivate")

func _do(f):
	if !target: return
	if target.has_method(f):
		target.call(f, self)
