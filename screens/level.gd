extends Node2D
class_name Level

@onready var map: TileMap = find_child("TileMap")

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	Events.level_loaded.emit(self)

func _ready():
	assert(map != null, "Couldn't find `TileMap` in Level")

	Events.level_started.emit(self)

func get_level_bounds() -> Rect2i:
	var used_rect = map.get_used_rect()
	return Rect2i(used_rect.position, used_rect.size * Const.TILE_SIZE)
