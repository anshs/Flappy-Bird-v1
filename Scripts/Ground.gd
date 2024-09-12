extends Sprite2D

# Speed at which the TileMap scrolls
var scroll_speed = Global.scroll_speed  # pixels per second

# Width of a single tile (assuming square tiles)
@export var tile_width: float = 25  # Adjust according to your tile size

# Position of the starting tile (initially set to zero)
var xoffset: float = 0.0
var start_pos: float

func _ready():
	# Initialize the offset to match the current position
	xoffset = position.x
	start_pos = position.x

func _physics_process(delta: float) -> void:
	# Update the position based on scroll speed
	if Global.is_game_over == 0:
		xoffset -= scroll_speed * delta

	# Check if the TileMap has scrolled past its width
	if start_pos - xoffset >= tile_width:
		# Reset the offset to create an infinite effect
		xoffset = start_pos

	# Update the TileMap's position
	position.x = xoffset
