extends CharacterBody2D  # Change this to the type of your player ship node, e.g., Sprite, KinematicBody2D, etc.

# Constants for visualization and audio analysis
const VU_COUNT = 46
const FREQ_MAX = 11050.0/4

# Constants for player movement

const SHIP_SPEED_VERTICAL = 300
const SHIP_SPEED_HORIZONTAL = 10
const NEUTRAL_PITCH = 800#1000#1200  # Example neutral pitch value
const NEUTRAL_VOLUME = 50  # Example neutral volume threshold
const MIN_DB = 60

var angle = 0
var max_avel = 2.4434609527920588#140/360*2*3.14159265358979#2.4434609527920588888888888888889	#140/360*2*PI but for some reason it doesn't like that here. 
var pitch_div = 200
var speed = 0
var deceleration = 300
var acc_mod = 600

var min_acc = 300
var max_acc = 600

var max_speed = 400
var max_magnitude = .2

var record
var spectrum : AudioEffectSpectrumAnalyzerInstance
var min_values = []
var max_values = []
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var spr_thrust_1 = $SprThrust1
@onready var spr_thrust_2 = $SprThrust2
@onready var spr_thrust_3 = $SprThrust3

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
		var mod = 1
		if hz > NEUTRAL_PITCH:
			mod = 1+clamp((hz-NEUTRAL_PITCH/NEUTRAL_PITCH),0,1)
		data.append(height*mod)
		prev_hz = hz
		
		if magnitude > note_magnitude:
			note_pitch = i * FREQ_MAX / VU_COUNT
			note_magnitude = magnitude
	#print(note_pitch)
	
	var average_pitch = calculate_average_pitch(data)
	#var total_volume = calculate_total_volume(data)
	#print("Average Pitch: ", average_pitch, " | Neutral Pitch: ", NEUTRAL_PITCH)
	#print("Total Volume: ", total_volume, " | Neutral Volume: ", NEUTRAL_VOLUME)
	
	#(NEUTRAL_PITCH-average_pitch)/200
	if note_magnitude >= .003:
		if average_pitch != NEUTRAL_PITCH:
			rotate(clamp((NEUTRAL_PITCH-average_pitch)/pitch_div,-max_avel,max_avel)*delta)
			#print(max_avel)
			#print((NEUTRAL_PITCH-average_pitch)/pitch_div)
		var mod = clamp(note_magnitude*acc_mod,min_acc,max_acc)
		speed = move_toward(speed,max_speed,mod*delta)
		#print(average_pitch)
	else:
		#print("decelearte")
		speed = move_toward(speed,0,deceleration*delta)
	
	velocity = Vector2.from_angle(rotation)*speed
	move_and_slide()	
	
	
	spr_thrust_1.modulate = Color(spr_thrust_1.modulate,clamp(speed/(max_speed/3),0,1))
	spr_thrust_2.modulate = Color(spr_thrust_2.modulate,clamp(speed/(max_speed/3)-.333,0,1))
	spr_thrust_3.modulate = Color(spr_thrust_3.modulate,clamp(speed/(max_speed/3)-.666,0,1))


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




#extends CharacterBody2D  # Change this to the type of your player ship node, e.g., Sprite, KinematicBody2D, etc.
#
## Constants for visualization and audio analysis
#const VU_COUNT = 46
#const FREQ_MAX = 11050.0/4
#
## Constants for player movement
#
#const SHIP_SPEED_VERTICAL = 300
#const SHIP_SPEED_HORIZONTAL = 10
#const NEUTRAL_PITCH = 1000#1200  # Example neutral pitch value
#const NEUTRAL_VOLUME = 50  # Example neutral volume threshold
#const MIN_DB = 60
#
#var angle = 0
#var max_avel = 2.4434609527920588#140/360*2*3.14159265358979#2.4434609527920588888888888888889	#140/360*2*PI but for some reason it doesn't like that here. 
#var pitch_div = 200
#var speed = 0
#var deceleration = 300
#var acc_mod = 600
#
#var min_acc = 300
#var max_acc = 600
#
#var max_speed = 400
#var max_magnitude = .2
#
#var record
#var spectrum : AudioEffectSpectrumAnalyzerInstance
#var min_values = []
#var max_values = []
#@onready var audio_stream_player_2d = $AudioStreamPlayer2D
#@onready var spr_thrust_1 = $SprThrust1
#@onready var spr_thrust_2 = $SprThrust2
#@onready var spr_thrust_3 = $SprThrust3
#
#func _ready():
	#record = AudioServer.get_bus_effect_instance(1, 0)
	#spectrum = AudioServer.get_bus_effect_instance(1, 1)
#
#func _process(delta):
	#var data = []
	#var prev_hz = 0
	#
	#var note_pitch = NEUTRAL_PITCH
	#var note_magnitude = 0
	#
	#for i in range(1, VU_COUNT + 1):
		#var hz = i * FREQ_MAX / VU_COUNT
		#var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		#var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		#var height = energy * 250 * 8.0
		#var mod = 1
		#if hz > NEUTRAL_PITCH:
			#mod = 1+clamp((hz-NEUTRAL_PITCH/NEUTRAL_PITCH),0,1)
		#data.append(height*mod)
		#prev_hz = hz
		#
		#if magnitude > note_magnitude:
			#note_pitch = i * FREQ_MAX / VU_COUNT
			#note_magnitude = magnitude
	##print(note_pitch)
	#
	#var average_pitch = calculate_average_pitch(data)
	##var total_volume = calculate_total_volume(data)
	##print("Average Pitch: ", average_pitch, " | Neutral Pitch: ", NEUTRAL_PITCH)
	##print("Total Volume: ", total_volume, " | Neutral Volume: ", NEUTRAL_VOLUME)
	#
	##(NEUTRAL_PITCH-average_pitch)/200
	#if note_magnitude >= .003:
		#if average_pitch != NEUTRAL_PITCH:
			#rotate(clamp((NEUTRAL_PITCH-average_pitch)/pitch_div,-max_avel,max_avel)*delta)
			#print(max_avel)
			#print((NEUTRAL_PITCH-average_pitch)/pitch_div)
		#var mod = clamp(note_magnitude*acc_mod,min_acc,max_acc)
		#speed = move_toward(speed,max_speed,mod*delta)
		##print(average_pitch)
	#else:
		##print("decelearte")
		#speed = move_toward(speed,0,deceleration*delta)
	#
	#velocity = Vector2.from_angle(rotation)*speed
	#move_and_slide()	
	#
	#
	#spr_thrust_1.modulate = Color(spr_thrust_1.modulate,clamp(speed/(max_speed/3),0,1))
	#spr_thrust_2.modulate = Color(spr_thrust_2.modulate,clamp(speed/(max_speed/2)-.333,0,1))
	#spr_thrust_3.modulate = Color(spr_thrust_3.modulate,clamp(speed/max_speed-.500,0,1))
#
#
#func calculate_average_pitch(data):
	#var total_weighted_pitch = 0.0
	#var total_weight = 0.0
	#for i in range(VU_COUNT):
		#var hz = (i + 1) * FREQ_MAX / VU_COUNT
		#var weight = data[i]
		#total_weighted_pitch += hz * weight
		#total_weight += weight
	#return total_weighted_pitch / total_weight
#
#func calculate_total_volume(data):
	#var total_volume = 0.0
	#for height in data:
		#total_volume += height
	#return total_volume
