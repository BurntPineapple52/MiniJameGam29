extends Node2D

@onready var game = $".."

func _on_play_pressed():
	game.game_start()
	process_mode = Node.PROCESS_MODE_DISABLED
	#queue_free()
	#get_tree().change_scene_to_file("res://scenes/stages/long_stage.tscn")

func _on_quit_pressed():
	get_tree().quit()
