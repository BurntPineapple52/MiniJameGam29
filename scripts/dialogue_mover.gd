extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_camera_2d().get_screen_center_position()-get_viewport_rect().size/2

