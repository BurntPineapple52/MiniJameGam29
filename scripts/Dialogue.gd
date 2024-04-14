extends RichTextLabel

var messages = [
	"The timeline is crumbling Sergeant Tony Deff, use that beautiful voice of yours to move your Sonomobile through the rapidly fracturing cosmos. Your mission is to make it to the galacto core. Shout, sing, whistle, squeal into the cos-mic. Do whatever you have to do to move that ship. When you get there, you'll know what to do. God speed, sir."
]

var typing_speed = .05

var curr_message = 0
var curr_char = 0
var display = ""

func _ready():
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
	$"..".queue_free()
