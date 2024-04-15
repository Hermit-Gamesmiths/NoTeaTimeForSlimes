extends Node2D

func activate(sender):
	_do_all(sender, "activate")

func deactivate(sender):
	_do_all(sender, "deactivate")

func telegraph(sender):
	_do_all(sender, "telegraph")

func _do_all(sender, f):
	for child in get_children():
		if child != sender:
			if child.has_method(f):
				child.call(f, self)
