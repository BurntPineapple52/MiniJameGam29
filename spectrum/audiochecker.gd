extends AudioStreamPlayer2D

# Define the threshold for sound detection.
var volume_threshold: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the stream to capture from the microphone.
	stream = AudioStreamMicrophone.new()
	play()

# This function checks the amplitude of the microphone input.
func _process(_delta):
	var pcm = stream.get_
	if pcm > linear2db(volume_threshold):
		print("Sound")
	else:
		print("No Sound")

# Helper function to convert linear volume to decibels.
func linear2db(linear):
	if linear == 0:
		return -80 # Minimum decibel level if no sound
	return max(-80, log(linear) * 20.0)
