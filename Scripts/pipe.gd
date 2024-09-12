extends StaticBody2D
@export var pipe_width:int #random width variable
@export var max_width:float = 200 #max width between pipes for fly access
@export var min_width:float = 120 #min width between pipes for fly access
var current_width: float # Stores the original pipe width before instantiation

var UpperExt: Sprite2D
var Upper: Sprite2D
var Lower: Sprite2D
var LowerExt: Sprite2D
var UpperColl: CollisionShape2D
var LowerColl: CollisionShape2D
var offset_value: Vector2
var expired: bool
var hit_sound: AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set a random width between -upper and lower pipes
	UpperExt = $"UpperExt"
	Upper = $"Upper"
	Lower = $"Lower"
	LowerExt = $"LowerExt"
	UpperColl = $"Area2D/UpperColl"
	LowerColl = $"Area2D/LowerColl"
	hit_sound = $"HitSound"
	
	
	#Level up later on based on score
	if Global.score > 10:
		max_width = 150
		min_width = 80
	current_width = (Lower.position.y - Lower.texture.get_height()*Lower.scale.y/2) - (Upper.position.y + Upper.texture.get_height()*Upper.scale.y/2)
	pipe_width = randi_range(min_width,max_width)
	offset_value = Vector2(0,(current_width-pipe_width)/2)
	Upper.position += offset_value
	UpperExt.position += offset_value
	UpperColl.position += offset_value
	Lower.position -= offset_value
	LowerExt.position -= offset_value
	LowerColl.position -= offset_value
	expired = false


func _on_area_2d_body_entered(body):
	if body.name == "Player" and Global.is_game_over == 0:
		hit_sound.play()
		$"/root/Main".trigger_game_over()
