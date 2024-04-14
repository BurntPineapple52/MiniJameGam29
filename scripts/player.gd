extends CharacterBody2D  # Change this to the type of your player ship node, e.g., Sprite, KinematicBody2D, etc.

# Constants for visualization and audio analysis
#const VU_COUNT = 24
#const FREQ_MAX = 11050.0/10#4
const VU_COUNT = 60
const FREQ_MAX = 11050.0/12#4

# Constants for player movement
const NEUTRAL_PITCH = 250#1200  # Example neutral pitch value
const MIN_DB = 100

var angle = 0
var speed = 0
var deceleration = 70
var acc_mod = 400

var min_acc = 160
var max_acc = 300

var max_ang = 2*PI

var max_speed = 200
var max_magnitude = .2

var record
var spectrum : AudioEffectSpectrumAnalyzerInstance
var min_values = []
var max_values = []
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	record = AudioServer.get_bus_effect_instance(1, 0)
	spectrum = AudioServer.get_bus_effect_instance(1, 1)

func _process(delta):
	var data = []
	var prev_hz = 0
	
	var note_pitch = NEUTRAL_PITCH
	var note_magnitude = 0
	
	for i in range(1, VU_COUNT + 1):
		var hz = i * FREQ_MAX / VU_COUNT
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * 250 * 8.0
		data.append(height)
		prev_hz = hz
		
		if magnitude > note_magnitude:
			note_pitch = i * FREQ_MAX / VU_COUNT
			note_magnitude = magnitude
	#print(note_pitch)
	
	var average_pitch = calculate_average_pitch(data)
	var total_volume = calculate_total_volume(data)
	#print("Average Pitch: ", average_pitch, " | Neutral Pitch: ", NEUTRAL_PITCH)
	#print("Total Volume: ", total_volume, " | Neutral Volume: ", NEUTRAL_VOLUME)
	
	if note_magnitude >= .008:
		if note_pitch != NEUTRAL_PITCH:
			rotate(clamp((NEUTRAL_PITCH-note_pitch)/160,-max_ang,max_ang)*delta)
			print("avg - " + str(average_pitch) + " |peak - " + str(note_pitch))
			
		var mod = clamp(note_magnitude*acc_mod,min_acc,max_acc)
		speed = move_toward(speed,max_speed,mod*delta)
	else:
		speed = move_toward(speed,0,deceleration*delta)
	
	velocity = Vector2.from_angle(rotation)*speed
	move_and_slide()	

func calculate_bad_average_pitch(data):
	var total_weighted_pitch = 0.0
	var total_weight = 0.0
	for i in range(VU_COUNT):
		var hz = (i + 1) * FREQ_MAX / VU_COUNT
		var weight = data[i]
		total_weighted_pitch += hz * weight
		total_weight += weight
	return total_weighted_pitch / total_weight

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
