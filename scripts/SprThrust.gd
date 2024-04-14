extends Sprite2D


var time = 0
var shake_mod = 3
@onready var player = $".."
var base_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = base_pos + Vector2(0, (player.speed/player.max_speed)*shake_mod*sin(18*PI*time))
	#print(position)
	time += delta
