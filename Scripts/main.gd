extends Node2D
@export var scene_path: String = "res://pipe.tscn"   # Path to the scene to instantiate
var min_pipe_interval: float = 2
var max_pipe_interval: float = 4
# Speed at which the TileMap scrolls
var scroll_speed = Global.scroll_speed  # pixels per second
var pipes = []  # List to keep track of pipes
var viewport_size
var max_pipes = 5
var debug
var player: CharacterBody2D
var pipe_size = Vector2(0,0)
var game_over_scene: PackedScene
var timer :Timer
var scoretext : RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	player = $Player
	Global.score = 0
	Global.is_game_started = 1
	scoretext = $Score
	scoretext.text = "Score: " + str(Global.score)
	viewport_size = get_viewport().get_visible_rect().size
	timer_start()
	# Preload game over scene
	game_over_scene = preload("res://Restart.tscn")
	debug = get_node("Debug") # Custom debug script assuming its mapped to a Label node called "Debug" under root node
	

func _physics_process(delta):
	if Global.is_game_over == 0:
		for pipe in pipes:
			pipe.position.x -= scroll_speed * delta
			# Remove pipes that have moved off the left side of the screen
			pipe_size = pipe.get_node("CollisionShape2D").shape.extents * 2 # Extents are half the size
			# Scoring
			if(player.position.x>pipe.position.x and pipe.expired == false):
				Global.score += 1
				pipe.expired = true
				scoretext.text = "Score: " + str(Global.score)
		# Remove old pipes
		for pipe in pipes:
			if pipe.position.x < -pipe_size.x / 2:
				pipes.erase(pipe)
				pipe.queue_free()
			if pipes.size() >= max_pipes: # Ensure pipes don't overload the memory
				var old_pipe = pipes.pop_front()
				old_pipe.queue_free()
		#debug.dpush("Pipe Size",pipes.size())
		#debug.dupdate()
	else:
		pass

func timer_start():
	timer.wait_time = max_pipe_interval
	timer.start()
	timer.timeout.connect(self.generate_pipe)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

# Generate a pipe
func generate_pipe():
	if pipes.size() < max_pipes:
		var pipe = load(scene_path).instantiate()
		pipe_size = pipe.get_node("CollisionShape2D").shape.extents * 2 # Extents are half the size
		pipe.z_index = -1
		pipe.position = Vector2(viewport_size.x + pipe_size.x / 2, randi_range(-41,191))
		pipes.append(pipe)
		add_child(pipe)
	timer.set_wait_time(randf_range(min_pipe_interval,max_pipe_interval))

# Trigger Game Over
func trigger_game_over():
	Global.is_game_over = 1
	Global.scroll_speed = 0
	Global.is_game_started = 0
	player.rotate(PI/2)
	timer.stop()
	var game_over_instance = game_over_scene.instantiate()
	add_child(game_over_instance)
	# Optionally, set it to be on top
	game_over_instance.z_index = 1

