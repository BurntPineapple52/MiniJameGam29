extends Node2D

var reset_timer = 5.5
var pad = 650
@onready var timebreak = $Timebreak
@onready var player = $Player
var camera
var width = 1152

@onready var game_over_text = $GameOverText



# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera_2d()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_timebreak():
	timebreak.start()

func trigger_reset():
	if timebreak.global_position.x < camera.get_screen_center_position().x - width/2 - pad:
		timebreak.global_position.x = camera.get_screen_center_position().x - width/2 - pad
	timebreak.speed_up()
	game_over_text.position = camera.get_screen_center_position() - game_over_text.pivot_offset
	game_over_text.visible = true
	get_tree().create_tween().tween_property(game_over_text,"modulate",Color(game_over_text.modulate,1),1)
	
	
	await get_tree().create_timer(reset_timer).timeout
	get_tree().reload_current_scene()