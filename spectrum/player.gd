extends Node2D  # Change this to the type of your player ship node, e.g., Sprite, KinematicBody2D, etc.

# Constants for visualization and audio analysis
const VU_COUNT = 16
const FREQ_MAX = 11050.0

# Constants for player movement
const SHIP_SPEED_VERTICAL = 300
const SHIP_SPEED_HORIZONTAL = 10
const NEUTRAL_PITCH = 1350  # Example neutral pitch value
const NEUTRAL_VOLUME = 50  # Example neutral volume threshold

var spectrum
var min_values = []
var max_values = []

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	min_values.resize(VU_COUNT)
	max_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.fill(0.0)

func _process(delta):
	var data = []
	var prev_hz = 0
	
	for i in range(1, VU_COUNT + 1):
		var hz = i * FREQ_MAX / VU_COUNT
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((60 + linear_to_db(magnitude)) / 60, 0, 1)
		var height = energy * 250 * 8.0
		data.append(height)
		prev_hz = hz

	var average_pitch = calculate_average_pitch(data)
	var total_volume = calculate_total_volume(data)
	#print("Average Pitch: ", average_pitch, " | Neutral Pitch: ", NEUTRAL_PITCH)
	print("Total Volume: ", total_volume, " | Neutral Volume: ", NEUTRAL_VOLUME)

	if average_pitch > NEUTRAL_PITCH:
		position.y -= SHIP_SPEED_VERTICAL * delta
	elif average_pitch < NEUTRAL_PITCH:
		position.y += SHIP_SPEED_VERTICAL * delta

	if total_volume > NEUTRAL_VOLUME:
		position.x += SHIP_SPEED_HORIZONTAL * delta
	elif total_volume < NEUTRAL_VOLUME:
		position.x -= SHIP_SPEED_HORIZONTAL * delta

	queue_redraw()

func calculate_average_pitch(data):
	var total_weighted_pitch = 0.0
	var total_weight = 0.0
	for i in range(VU_COUNT):
		var hz = (i + 1) * FREQ_MAX / VU_COUNT
		var weight = data[i]
		total_weighted_pitch += hz * weight
		total_weight += weight
	return total_weighted_pitch / total_weight

func calculate_total_volume(data):
	var total_volume = 0.0
	for height in data:
		total_volume += height
	return total_volume
