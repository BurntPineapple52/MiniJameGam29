extends Node2D
const LONG_STAGE = preload("res://scenes/stages/long_stage.tscn")
var stage
@onready var menu = $MainMenu
@onready var fader = $Transition
const DIALOGUE = preload("res://scenes/stages/dialogue.tscn")
const MAIN_MENU = preload("res://scenes/stages/main_menu.tscn")

var current_checkpoint = 0

var camera
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	fader.color = Color.BLACK
	fader.set_modulate(Color(fader.modulate,0))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_checkpoint(id):
	if id > current_checkpoint:
		current_checkpoint = id

func game_start():
	fader.set_visible(true)
	fader.position = Vector2(0,0)
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,1),.5).finished
	await get_tree().create_timer(1.5).timeout
	menu.queue_free()
	print("created")
	stage = LONG_STAGE.instantiate()
	add_child(stage)
	fader.position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,0),.5).finished
	print("done")
	fader.set_visible(false)
	add_child(DIALOGUE.instantiate())


func restart_stage():
	fader.color = Color(Color.WHITE,1)
	fader.position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2
	fader.set_visible(true)
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,1),.25).finished
	get_viewport().get_camera_2d().set_enabled(false)
	stage.queue_free()
	
	
	
	#maybe short wait?
	#await get_tree().create_timer(.1)
	stage = LONG_STAGE.instantiate()
	add_child(stage)
	stage.start_at_checkpoint(current_checkpoint)
	
	fader.position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,0),.3).set_ease(Tween.EASE_IN).finished
	fader.set_visible(false)

func game_won():
	fader.color = Color(Color.BLACK,1)
	fader.modulate = Color(fader.modulate,0)
	fader.position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2
	fader.set_visible(true)
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,1),1).finished
	stage.queue_free()
	#fader.position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2
	await get_tree().create_timer(.1).timeout
	menu = MAIN_MENU.instantiate()
	add_child(menu)
	fader.position = Vector2(0,0)
	await get_tree().create_tween().tween_property(fader,"modulate",Color(fader.modulate,0),1).set_ease(Tween.EASE_IN).finished
	fader.set_visible(false)
