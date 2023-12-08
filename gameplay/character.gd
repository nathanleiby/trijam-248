extends CharacterBody2D

@export var speed = 800
@export var jump_speed = -1800
@export var gravity = 4000

@export var platformScene: PackedScene
@onready var raycast2d := $RayCast2D
@export var portalScene: PackedScene

const CHARACTER_HEIGHT = 32
const PLATFORM_HEIGHT = 32
const OFFSET = 4
const DEATH_HEIGHT = 720

const PLATFORMS_MAX = 3

signal platform_created(height)

var platforms_remaining:
	set(val):
		platforms_remaining = val
		Events.platform_number_set.emit(val)


@export var respawn_location: Vector2

func _ready() -> void:
	respawn_location = position
	platforms_remaining = PLATFORMS_MAX

const BOUNCE_VELOCITY := 500

func _physics_process(delta):
	# Add gravity every frame
	velocity.y += gravity * delta

	# Input affects x axis only
	velocity.x = Input.get_axis("walk_left", "walk_right") * speed

	if velocity.x > 0:
		$Character.flip_h = true
	elif velocity.x < 0:
		$Character.flip_h = false


	if velocity.y >= BOUNCE_VELOCITY:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			if collision_info.get_collider() is Trampoline:
				velocity = velocity.bounce(collision_info.get_normal())
			else:
				move_and_slide()
	else:
		move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if randf() < 0.5:
			Sound.play_sfx($JumpSfx)
		else:
			Sound.play_sfx($JumpSfx2)
		velocity.y = jump_speed

	# put it below the character
	if Input.is_action_just_pressed("place_platform"):
		if platforms_remaining <= 0:
			Sound.play_sfx($NoPlatformsSfx)
			return

		Sound.play_sfx($PlacePlatformSfx)
		platforms_remaining -= 1

		var platform = platformScene.instantiate()
		add_child(platform)

		var y_offset = CHARACTER_HEIGHT / 2 + PLATFORM_HEIGHT / 2 + OFFSET
		platform.position += Vector2(0, y_offset)
		platform.reparent(get_tree().root)

		emit_signal("platform_created", platform.position.y)



	if Input.is_action_just_pressed("reset"):
		# TODO: play "warping" sound
		Sound.play_sfx($WarpSfx)
		reset()


	if position.y >= DEATH_HEIGHT:
		Sound.play_sfx($DieSfx)
		reset()

	if Input.is_action_just_pressed("place_portal"):
		print('placing portal')
		var portal = portalScene.instantiate()
		add_child(portal)
		portal.position = position

func reset():
	position = respawn_location
	platforms_remaining = PLATFORMS_MAX
	velocity = Vector2(0, 0)


func _on_area_2d_area_entered(area):
	# if the collision is with a portal, respawn the character
	if area.name == "PortalHitArea":
		reset()
