extends Resource
class_name Jump

@export var jump_height_tiles = 2.1
var jump_height : float : get = get_height
@export var jump_time_to_peak : float = .5
@export var jump_time_to_descend : float = .4

func jump_velocity():
    return ((2.0 * jump_height) / jump_time_to_peak) * -1


func jump_gravity():
    return ((-2.0 * jump_height) / (jump_time_to_peak ** 2)) * -1


func fall_gravity():
    return ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descend)) * -1


func get_height() -> float:
    return (Const.TILE_SIZE * jump_height_tiles)
