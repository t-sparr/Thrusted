extends RigidBody2D

var engine_thrust
var spin_thrust
var thrust: Vector2 = Vector2.ZERO
var rotation_dir: int = 0

#Audio and Visual Stuff
var blaster_active: bool = false
var blaster_timer: float = 0.0 
var sound_timer: float = 0.0
var blaster_part
var left_air
var right_air
var air_hiss_player
var booster_sound

func _ready():
	engine_thrust = Global.global_engine_thrust
	spin_thrust = Global.global_spin_thrust
	if Global.game_mode == Global.GameMode.PLAYER:
		pass
	if Global.applyVisuals_Audio == true:
		setup_visual_aduio()

func _physics_process(delta):
	if Global.game_mode == Global.GameMode.PLAYER: 
		handle_player_input(delta)
	if Global.applyVisuals_Audio == true: 
		handle_visuals_audio(delta)
		
	apply_central_force(thrust)
	apply_torque(rotation_dir * spin_thrust)
	rotation_dir = rotation 
	
	
	
func handle_visuals_audio(delta):
	sound_timer += delta
	if Input.is_key_pressed(KEY_W): 
		blaster_part.emitting = true
		blaster_timer = 0.0
		if booster_sound.playing == false:
			booster_sound.play()
	else: 
		blaster_timer += delta
		if blaster_timer >= .1: 	
			blaster_part.emitting = false
			booster_sound.stop()
			
	if Input.is_key_pressed(KEY_A):
		left_air.emitting = true
	else: left_air.emitting = false
	if Input.is_key_pressed(KEY_D):
		right_air.emitting = true
	else: right_air.emitting = false
	
	if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_A)):
		sound_timer = 0
		if not air_hiss_player.playing: 
			air_hiss_player.play()
			
	else:
		if air_hiss_player.playing and sound_timer > .1:
			air_hiss_player.stop()

func handle_player_input(delta):
	var rotation_dir = 0 
	var pos_thrust = Input.is_key_pressed(KEY_W)
	if Input.is_key_pressed(KEY_A): 
		rotation_dir -= 1
	if Input.is_key_pressed(KEY_D): 
		rotation_dir += 1
	set_controls(pos_thrust, rotation_dir)

func set_controls(pos_thrust: bool, turn_dir: int):
	if pos_thrust: thrust = -transform.y * (engine_thrust) 
	else: thrust = Vector2.ZERO
	rotation_dir = turn_dir

func setup_visual_aduio():
	blaster_part = $Blaster/Part
	left_air = $Air_Blast_Left/Part
	right_air = $Air_Blast_Right/Part
	air_hiss_player = $AirHissPlayer
	booster_sound = $Booster_Sound
