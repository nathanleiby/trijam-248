extends CharacterBody2D

@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000

@export var platformScene: PackedScene

const CHARACTER_HEIGHT = 32
const PLATFORM_HEIGHT = 32
const OFFSET = 4
const DEATH_HEIGHT = 720

const PLATFORMS_MAX = 3

signal platform_created(height)

var platforms_remaining:
	set(val):
		platforms_remaining = val
		$PlayerUI/PlatformsRemainingLabel.text = "Platforms = " + str(platforms_remaining)
	

var respawn_location: Vector2 

func _ready() -> void:
	respawn_location = position
	platforms_remaining = PLATFORMS_MAX

	
func _physics_process(delta):
	# Add gravity every frame
	velocity.y += gravity * delta

	# Input affects x axis only
	velocity.x = Input.get_axis("walk_left", "walk_right") * speed

	if velocity.x > 0:
		$Character.flip_h = true
	elif velocity.x < 0: 
		$Character.flip_h = false
		
	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	# put it below the character
	if Input.is_action_just_pressed("place_platform"):
		if platforms_remaining <= 0:
			return
			
		platforms_remaining -= 1
			
		var platform = platformScene.instantiate()
		add_child(platform)
		
		var y_offset = CHARACTER_HEIGHT / 2 + PLATFORM_HEIGHT / 2 + OFFSET
		platform.position += Vector2(0, y_offset)
		platform.reparent(get_tree().root)
		
		emit_signal("platform_created", platform.position.y)
		
		
	
	if Input.is_action_just_pressed("reset"):
		position = respawn_location
		platforms_remaining = PLATFORMS_MAX
	
	if position.y >= DEATH_HEIGHT:
		position = respawn_location


