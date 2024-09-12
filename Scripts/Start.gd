extends Node2D
# Speed at which the TileMap scrolls
var scroll_speed = Global.scroll_speed  # pixels per second
var viewport_size
var player: CharacterBody2D
var game_over_scene: PackedScene
var main_scene: PackedScene
var sine_counter:int = 0

# Variables for swinging motion
var swing_amplitude: float = 10.0  # The maximum distance up and down the bird will swing
var swing_frequency: float = 2   # How fast the bird will swing up and down
var base_y: float

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	viewport_size = get_viewport().get_visible_rect().size
	# Preload game over scene
	main_scene = preload("res://main.tscn")
	player.gravity = 0
	base_y = player.position.y

func _physics_process(delta):
	if Global.is_game_over == 0 and Global.is_game_started == 0:
		if sine_counter >100:
			sine_counter = 0
		else:
			sine_counter +=1
		apply_swinging_motion(sine_counter)
	else:
		pass
func _unhandled_input(event: InputEvent) -> void:
	# Detect any key press or mouse click
	if event.is_pressed():
		start_game()

func start_game():
	# Replace the current scene with the main game scene
	var check = get_tree().change_scene_to_packed(main_scene)
	Global.is_game_started = 1
	print(check)
	
func apply_swinging_motion(counter:int) -> void:
	# Calculate the new y position based on a sine wave for swinging motion
	player.position.y = base_y + swing_amplitude * sin((counter*PI/100) * swing_frequency)
