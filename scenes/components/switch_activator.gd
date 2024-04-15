extends Node
class_name SwitchActivator

func activate(_sender):
	var parent = get_parent()
	if parent.has_method("activate"):
		parent.activate(self)


func deactivate(_sender):
	var parent = get_parent()
	if parent.has_method("deactivate"):
		parent.deactivate(self)
