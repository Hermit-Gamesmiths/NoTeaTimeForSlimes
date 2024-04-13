extends CharacterBody2D

@export var speed = 350

@export var jump_height_tiles = 2.1
@onready var jump_height : float = (Const.TILE_SIZE * jump_height_tiles)
@export var jump_time_to_peak : float = .5
@export var jump_time_to_descend : float = .4

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak ** 2)) * -1
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descend)) * -1

@export var hitbox:Hitbox

@onready var model:Node2D = $Model

func _ready() -> void:
	hitbox.on_hit.connect(die)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func die():
	Events.player_died.emit()

func jump() -> void:
	velocity.y = jump_velocity


func get_gravity() -> Vector2:
	return Vector2(0, jump_gravity if velocity.y < 0 else fall_gravity)

# Eating Stuff

func swallow():
	pass
