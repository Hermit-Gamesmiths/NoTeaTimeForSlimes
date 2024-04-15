extends Node
class_name SwitchActivator

func activate():
	var parent = get_parent()
	if parent.has_method("activate"):
		parent.activate()


func deactivate():
	var parent = get_parent()
	if parent.has_method("deactivate"):
		parent.deactivate()
