extends Area2D

var timer = 10
var amount = Vector2(48,48)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func trigger_win():
	#grow to take up full screen
	print("test")
	get_tree().create_tween().tween_property(self,"scale",amount,timer).set_ease(Tween.EASE_IN)
