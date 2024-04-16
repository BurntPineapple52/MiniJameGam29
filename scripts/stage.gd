extends Node2D

var reset_timer = 5.5
var end_timer = 5
var pad = 650
@onready var timebreak = $Timebreak
@onready var player = $Player
var camera
var width = 1152

var checkpoint = 0

@onready var winner_text = $WinnerText
@onready var game_over_text = $GameOverText
@onready var galacto_core = $GalactoCore
@onready var game = $".."

@onready var checkpoints = $Checkpoints

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = player.get_node("Camera2D")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_camera():
	return camera

func checkpoint_reached(id):
	game.set_checkpoint(id)

func start_at_checkpoint(id):
	for n in checkpoints.get_children():
		if n.checkpoint_id < id:
			n.queue_free()
		elif n.checkpoint_id == id:
			player.position = n.position
	
	timebreak.start(player.position.x)

func start_timebreak():
	timebreak.start(player.position.x)

func trigger_reset():
	if timebreak.global_position.x < camera.get_screen_center_position().x - width/2 - pad:
		timebreak.global_position.x = camera.get_screen_center_position().x - width/2 - pad
	timebreak.speed_up()
	game_over_text.position = camera.get_screen_center_position() - game_over_text.pivot_offset
	game_over_text.visible = true
	get_tree().create_tween().tween_property(game_over_text,"modulate",Color(game_over_text.modulate,1),1)
	await get_tree().create_timer(reset_timer).timeout
	game.restart_stage()
	process_mode = Node.PROCESS_MODE_DISABLED

func trigger_win():
	winner_text.position = camera.get_screen_center_position() - winner_text.pivot_offset
	winner_text.visible = true
	galacto_core.trigger_win()
	get_tree().create_tween().tween_property(winner_text,"modulate",Color(winner_text.modulate,1),1)
	await get_tree().create_timer(end_timer).timeout
	#goto menu
	game.game_won()
	process_mode = Node.PROCESS_MODE_DISABLED
