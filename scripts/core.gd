extends Node2D

var inner_size = 30
var flicker_size = 36

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2(0,0),inner_size,Color.WHITE)
	draw_circle(Vector2(0,0),flicker_size,Color(Color.WHITE,.5))
