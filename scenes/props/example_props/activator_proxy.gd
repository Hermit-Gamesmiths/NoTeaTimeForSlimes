extends Node

@export var target: Node

func activate(sender):
	if target:
		if target.has_method("activate"):
			target.activate(self)

func deactivate(_sender):
	if target:
		if target.has_method("deactivate"):
			target.deactivate(self)

func telegraph(_sender):
	if target:
		if target.has_method("telegraph"):
			target.telegraph(self)
