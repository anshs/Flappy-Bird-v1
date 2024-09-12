extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input: Vector2
var accel: float = -2000
var min_speed = 75
var max_speed = 500
var bird_anime: AnimatedSprite2D
var viewport_mid: Vector2
# Rotation variables
var max_rotation_up: float = -0.3  # Radians for rotating upwards when flapping (e.g., -0.3 rad is about -17 degrees)
var max_rotation_down: float = 0.5 # Radians for rotating downwards when falling (e.g., 0.5 rad is about 28 degrees)
var rotation_speed: float = 20.0  # Speed at which the bird rotates back to neutral
var fly_sound: AudioStreamPlayer

func _ready():	
	bird_anime = get_node("AnimatedSprite2D")
	bird_anime.play("fly")
	viewport_mid = Vector2(get_viewport().get_visible_rect().size.x/2,get_viewport().get_visible_rect().size.y/3)
	position = viewport_mid
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	fly_sound = $"FlySound"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Player movement (Fly up)
	if Global.is_game_over == 0 and Global.is_game_started == 1:
		player_movement(delta)
		velocity.x = 0 # Keep x position fixed
		rotate_bird(delta)  # Apply rotation logic during normal gameplay
	if Global.is_game_over == 1 and is_on_floor():
		bird_anime.stop()
	move_and_slide()

# Handle player movement (Fly up)
func player_movement(delta):
	input = get_input()
	if input == Vector2.ZERO:
		pass
	else:
		velocity += (input*accel*delta)
		velocity = velocity.limit_length(max_speed)
		if velocity.y >= -min_speed:
			velocity.y = -min_speed
		if not fly_sound.playing:
			fly_sound.play()

# Get input for player movement
func get_input():
	#input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	#input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	input.y = int(Input.is_action_pressed("ui_up"))
	return input.normalized()

# Function to apply rotation logic
func rotate_bird(delta: float) -> void:
	if velocity.y < 0:
		# Bird is flapping upwards, rotate upwards
		rotation = lerp(rotation, max_rotation_up, rotation_speed * delta)
	else:
		# Bird is falling down, rotate downwards
		rotation = lerp(rotation, max_rotation_down, rotation_speed * delta)
