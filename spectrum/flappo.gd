extends RigidBody2D

var threshold = -30  # dB, change as needed
var is_flapping = false
var audio_stream_player = AudioStreamPlayer.new()

func _ready():
	# Setting up the microphone stream
	var mic = AudioStreamMicrophone.new()
	audio_stream_player.stream = mic
	add_child(audio_stream_player)
	audio_stream_player.play()

func _process(_delta):
	# Check the microphone input volume
	var bus_index = AudioServer.get_bus_index("Master")
	var mic_input = AudioServer.get_bus_peak_volume_left_db(bus_index)  # Get the peak volume from the default bus
	if mic_input > threshold and not is_flapping:
		flap()

func flap():
	# Apply an impulse to simulate flapping
	is_flapping = true
	apply_impulse(Vector2.ZERO, Vector2(0, -300))  # Adjust the impulse vector as needed
	# Timer to prevent continuous flapping
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()

func _on_timer_timeout():
	is_flapping = false
	# Clean up the timer
	var timer = get_node("Timer")
	timer.queue_free()
