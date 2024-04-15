extends Node

enum Phase {
	Telegraphing,
	Activated,
	Deactivated,
}

var is_active = false

@export var telegraph_duration: float = 1
@export var active_duration: float = 1
@export var cooldown: float = 1

var phase: Phase = Phase.Deactivated
var time_since_phase:float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_phase += delta

	match phase:
		Phase.Deactivated:
			if time_since_phase > cooldown:
				send("telegraph")
				phase = Phase.Telegraphing
		Phase.Telegraphing:
			if time_since_phase > telegraph_duration:
				send("activate")
				phase = Phase.Activated
		Phase.Activated:
			if time_since_phase > active_duration:
				send("deactivate")
				phase = Phase.Deactivated


func send(f):
	time_since_phase = 0
	var trap = get_parent()
	if trap.has_method(f):
		trap.call(f, self)

func start_activation() -> void:
	is_active = true
	var trap = get_parent()

	if trap.has_method("telegraph"):
		trap.telegraph(self)

	await get_tree().create_timer(telegraph_duration).timeout

	if trap.has_method("activate"):
		trap.activate(self)

	await get_tree().create_timer(active_duration).timeout

	if trap.has_method("deactivate"):
		trap.deactivate(self)

	await get_tree().create_timer(cooldown).timeout

	is_active = false
