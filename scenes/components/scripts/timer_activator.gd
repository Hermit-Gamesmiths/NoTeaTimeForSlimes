extends Node

var is_active = false

@export var telegraph_duration: float = 1
@export var active_duration: float = 1
@export var cooldown: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !is_active:
		start_activation()

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
