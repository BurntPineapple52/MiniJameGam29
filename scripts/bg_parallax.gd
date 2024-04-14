extends TileMap
@onready var player = $"../Player"

var rate = 10000
var base_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = base_pos.x + player.position.x/rate
	position.y = base_pos.y + player.position.y/rate
	print(position)
	
