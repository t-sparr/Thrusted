# spaceship.gd
extends RigidBody2D

@export var spin_thrust: float = 3500
@export var engine_thrust: float = 800



var thrust: Vector2 = Vector2.ZERO
var rotation_dir: int = 0
var sound_timer: float = 0.0
var thruster_active: bool = false
var blaster_timer: float = 0.0
var blaster_active: bool = false
var booster_sound_timer: float = 0

@onready var screen_size = get_viewport_rect().size
@onready var ghost_container = $GhostContainer
@onready var blaster = $Blaster/Part
@onready var left_air = $Air_Blast_Left/Part
@onready var right_air = $Air_Blast_Right/Part
@onready var air_hiss_player = $AirHissPlayer
@onready var booster_sound = $Booster_Sound

func _process(delta):
	
	var pos_thrust = Input.is_key_pressed(KEY_W)
	var rotation_dir = 0 
	if Input.is_key_pressed(KEY_A):
		rotation_dir -= 1
		left_air.emitting = true
	else: left_air.emitting = false
	if Input.is_key_pressed(KEY_D):
		rotation_dir += 1
		right_air.emitting = true
	else: right_air.emitting = false
	if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_A)):
		sound_timer = 0
		thruster_active = true
		if not air_hiss_player.playing: 
			air_hiss_player.play()
			
	else:
		if air_hiss_player.playing and sound_timer > .1:
			air_hiss_player.stop()
			

	set_controls(pos_thrust, rotation_dir)
	

func _physics_process(delta):
	sound_timer += delta
	apply_central_force(thrust)
	apply_torque(rotation_dir * spin_thrust)
	screen_wrap()
	update_ghosts()
	
	rotation_dir = rotation 
	
	if blaster_active: 
		blaster.emitting = true
		if booster_sound.playing == false:
			booster_sound.play()
	else: 
		blaster_timer += delta
		if blaster_timer >= .1: 	
			blaster.emitting = false
			booster_sound.stop()
	#if not air_hiss_player.playing: 
			#air_hiss_player.play()
			#
	#else:
		#if air_hiss_player.playing and sound_timer > .1:
			#air_hiss_player.stop()
			


func set_controls(pos_thrust: bool, turn_dir: int):
	if pos_thrust: 
		thrust = -transform.y * (engine_thrust) 
		blaster_timer = 0.0
		blaster_active = true
	else: 
		thrust = Vector2.ZERO
		blaster_active = false
		

	
	rotation_dir = turn_dir

func update_ghosts():
	var offsets = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, 0),                Vector2(1, 0),
		Vector2(-1, 1),  Vector2(0, 1), Vector2(1, 1)
	]
	
	for i in range(ghost_container.get_child_count()):
		var ghost = ghost_container.get_child(i)
		var offset = offsets[i] * screen_size
		ghost.global_position = global_position + offset
		ghost.global_rotation = global_rotation




func screen_wrap():
	var pos = global_position

	var half_width = screen_size.x / 2
	var half_height = screen_size.y / 2

	if pos.x > half_width:
		pos.x = -half_width
	elif pos.x < -half_width:
		pos.x = half_width

	if pos.y > half_height:
		pos.y = -half_height
	elif pos.y < -half_height:
		pos.y = half_height

	global_position = pos
