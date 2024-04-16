extends Area2D

@export var speed = 0
@export var base_speed = 150
@export var quick_speed = 500
var vp_width = 1152
var camera
@onready var stage = $".."

var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#camera = get_viewport().get_camera_2d()
	#camera = stage.get_camera()
	pass # Replace with function body..

#func set_camera(c):
	#camera = c

func start(pos):
	print("start")
	position.x = pos - vp_width/2 - 700 #get_viewport().get_camera_2d().get_screen_center_position().x - vp_width/2 - 700
	speed = base_speed

func speed_up():
	get_tree().create_tween().tween_property(self,"speed",quick_speed,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !stopped:
		position += Vector2(speed*delta, 0)
		if global_position.x > get_viewport().get_camera_2d().global_position.x + vp_width:
			stopped = true

func on_win():
	get_tree().create_tween().tween_property(self,"speed",-200,.5)
	await get_tree().create_tween().tween_property(self,"modulate",Color(modulate,0),2)
	queue_free()
