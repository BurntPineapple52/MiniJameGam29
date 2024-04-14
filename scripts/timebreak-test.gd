extends Area2D

@export var speed = 0
@export var base_speed = 150
@export var quick_speed = 500
var vp_width = 1152
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera_2d()
	pass # Replace with function body..

func start():
	print("start")
	position.x = camera.get_screen_center_position().x - vp_width/2 - 600
	speed = base_speed


func speed_up():
	get_tree().create_tween().tween_property(self,"speed",quick_speed,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x < camera.global_position.x + vp_width:
		position += Vector2(speed*delta, 0)
