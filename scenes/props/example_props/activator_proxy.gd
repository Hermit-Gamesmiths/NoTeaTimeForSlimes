extends Node

@export var target: Node

func activate():
	if target:
		if target.has_method("activate"):
			target.activate()

func deactivate():
	if target:
		if target.has_method("deactivate"):
			target.deactivate()

func telegraph():
	if target:
		if target.has_method("telegraph"):
			target.telegraph()
