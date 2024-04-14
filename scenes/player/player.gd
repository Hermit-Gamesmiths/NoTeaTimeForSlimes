extends CharacterBody2D

enum State {
	Idle,
	Walking,
	Jumping,
	Eating,
	Dying,
}

@export var speed = 350

@export var default_jump: Jump

@export var hitbox:Hitbox

@export var model: Node2D
@export var swallow_checker: Area2D
@export var stomache: Node2D
@export var spit_location: Node2D

@export var front_ray:RayCast2D
@export var back_ray:RayCast2D

@export var animation:AnimationTree

@onready var state_machine := animation.get("parameters/playback") as AnimationNodeStateMachinePlayback

var state: State = State.Idle

# 1 = right, -1 = left
var facing: int = 1

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
		facing = sign(direction)
		velocity.x = direction * speed
		if (is_on_floor() && state != State.Eating):
			animation.set("parameters/moving", true)
	else:
		animation.set("parameters/moving", false)
		velocity.x = move_toward(velocity.x, 0, speed)

	model.scale.x = facing

	if Input.is_action_just_pressed("stomache"):
		if stomache.get_child_count() > 0:
			spit()
		else:
			swallow()

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider() as Node
		if collider.has_meta(ContactActivator.COLLISION_LISTENER):
			print("got listener")
			collider.get_meta(ContactActivator.COLLISION_LISTENER).on_collision()

	print(state_machine.get_current_node())

func current_jump() -> Jump:
	if stomache.get_child_count() > 0:
		var jump_data = stomache.get_child(0).modified_jump
		if jump_data != null:
			return jump_data
	return default_jump


func die():
	Events.player_died.emit()


func jump() -> void:
	state = State.Jumping
	velocity.y = current_jump().jump_velocity()


func get_gravity() -> Vector2:
	return Vector2(0, current_jump().jump_gravity() if velocity.y < 0 else current_jump().fall_gravity())

# Eating Stuff

func swallow():
	print("swallowing")
	state = State.Eating
	var edibles = swallow_checker.get_overlapping_areas()
	if len(edibles) == 0:
		return
	var edible = edibles[0]
	edible.pack(stomache)


func spit():
	state = State.Eating
	var edible = stomache.get_child(0)
	if front_ray.is_colliding():
		var front_distance = abs(front_ray.get_collision_point().x - front_ray.global_position.x)
		if back_ray.is_colliding():
			var back_distance = abs(back_ray.get_collision_point().x - back_ray.global_position.x)

			if front_distance + back_distance <= Const.TILE_SIZE:
				var error_flash = create_tween()
				error_flash.tween_property(self, "modulate", Color.ORANGE_RED, .3)
				error_flash.chain().tween_property(self, "modulate", Color.WHITE, .3)
				return
			# Abort!

		var distance = 128 - front_distance
		move_and_collide(Vector2(distance * -facing, 0))
		# TODO: tween backward then spit.

	edible.unpack(get_parent(), spit_location.global_position)
