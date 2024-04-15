extends CharacterBody2D

@export var speed = 350

@export var default_jump: Jump

@export var hitbox:Hitbox

@export var model: Node2D
@export var swallow_checker: Area2D
@export var stomache: Node2D
@export var spit_location: Node2D

@export var front_ray:RayCast2D
@export var back_ray:RayCast2D
@export var crush_box: Area2D

@export var animation:AnimationTree

@onready var state_machine := animation.get("parameters/playback") as AnimationNodeStateMachinePlayback

var is_dead: bool = false

# 1 = right, -1 = left
var facing: int = 1

@export var coyote_time = .1
var time_since_floor:float = 0
var is_jump: bool = false

var is_eating: bool = false
var is_spitting: bool = false


func _ready() -> void:
	hitbox.on_hit.connect(die)


func _physics_process(delta: float) -> void:
	if is_dead: return
	if crush_box.has_overlapping_bodies():
		die()

	# Add the gravity.
	if is_on_floor():
		time_since_floor = 0
		is_jump = false
	else:
		time_since_floor += delta
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or (!is_jump and time_since_floor < coyote_time)):
		jump()

	if Input.is_action_just_pressed("stomache") && !is_eating && !is_spitting && is_on_floor():
		if stomache.get_child_count() > 0:
			spit()
		else:
			swallow()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		facing = sign(direction)
		velocity.x = direction * speed
		if (is_on_floor() && !is_eating):
			animation.set("parameters/moving", true)
	else:
		animation.set("parameters/moving", false)
		velocity.x = 0

	model.scale.x = facing

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider() as Node
		if collider.has_meta(ContactActivator.COLLISION_LISTENER):
			collider.get_meta(ContactActivator.COLLISION_LISTENER).on_collision()


func current_jump() -> Jump:
	if stomache.get_child_count() > 0:
		var jump_data = stomache.get_child(0).modified_jump
		if jump_data != null:
			return jump_data
	return default_jump


func hurt(_damage_type: Projectile.DamageType):
	die()


func die():
	if is_dead: return # STOP, he's already dead :sob:
	is_dead = true
	state_machine.start("hurt")
	await animation.animation_finished
	Events.player_died.emit()


func jump() -> void:
	is_jump = true
	velocity.y = current_jump().jump_velocity()


func get_gravity() -> Vector2:
	return Vector2(0, current_jump().jump_gravity() if velocity.y < 0 else current_jump().fall_gravity())

# Eating Stuff

func swallow():
	print("swallowing")
	is_eating = true
	state_machine.travel("eat")
	var edibles = swallow_checker.get_overlapping_areas()
	if len(edibles) == 0:
		is_eating = false
		return

	var edible = edibles[0]
	var color = stomache.modulate
	stomache.modulate = Color.WHITE

	await get_tree().create_timer(.25).timeout # Just to allow for the animation to start
	await get_tree().physics_frame
	edible.pack(stomache)
	var anim = create_tween()
	var duration = .1

	anim.tween_property(edible, "position", Vector2.ZERO, duration)
	anim.parallel().tween_property(edible, "scale", Vector2.ONE, duration)
	anim.parallel().tween_property(stomache, "modulate", color, duration)
	await anim.finished
	is_eating = false


func spit():
	print("spitting")
	is_spitting = true
	var edible = stomache.get_child(0) as Node2D
	if front_ray.is_colliding():
		var front_distance = abs(front_ray.get_collision_point().x - front_ray.global_position.x)
		if back_ray.is_colliding():
			var back_distance = abs(back_ray.get_collision_point().x - back_ray.global_position.x)

			if front_distance + back_distance <= Const.TILE_SIZE:
				var error_flash = create_tween()
				error_flash.tween_property(self, "modulate", Color.ORANGE_RED, .3)
				error_flash.chain().tween_property(self, "modulate", Color.WHITE, .3)
				is_spitting = false
				return
			# Abort!

		var distance = 128 - front_distance
		move_and_collide(Vector2(distance * -facing, 0))
		# TODO: tween backward then spit.

	edible.unpack(get_parent(), spit_location.global_position)

	var anim = create_tween()
	var duration = .1
	anim.tween_property(edible, "position", Vector2.ZERO, duration)
	anim.parallel().tween_property(edible, "global_scale", Vector2.ONE, duration)

	await anim.finished
	is_spitting = false
