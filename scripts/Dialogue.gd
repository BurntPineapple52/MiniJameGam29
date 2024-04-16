extends RichTextLabel

var messages = [
	"The timeline is crumbling Sergeant Tony Deff, use that beautiful voice of yours to move your Sonomobile through the rapidly fracturing cosmos. Shout, sing, whistle, squeal into the cos-mic. Do whatever you have to do to move that ship. Your mission is to make it to the galacto core. When you get there, you'll know what to do. God speed, sir."
]

@onready var color_rect = $"../ColorRect"
@onready var line_2d = $"../Line2D"
@onready var dialogue = $".."

var start_timer = .5
var typing_speed = .05

var curr_message = 0
var curr_char = 0
var display = ""

func _ready():
	color_rect.visible = false
	line_2d.visible = false
	color_rect.set_modulate(Color(color_rect.modulate,0))
	line_2d.set_modulate(Color(line_2d.modulate,0))
	
	await get_tree().create_timer(start_timer).timeout
	color_rect.visible = true
	line_2d.visible = true
	get_tree().create_tween().tween_property(color_rect,"modulate",Color(color_rect.modulate,1),1)
	await get_tree().create_tween().tween_property(line_2d,"modulate",Color(line_2d.modulate,1),1).finished
	
	start_dialogue()
	
func start_dialogue():
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func _on_next_char_timeout():
	if (curr_char < len(messages[curr_message])):
		var next_char = messages[curr_message][curr_char]
		display += next_char
		
		$"../RichTextLabel".text = display
		curr_char += 1
	else:
		$next_char.stop()
		$"2sec".start()

func _on_sec_timeout():
	await get_tree().create_tween().tween_property(dialogue,"modulate",Color(dialogue.modulate,0),1).finished
	$"..".queue_free()
