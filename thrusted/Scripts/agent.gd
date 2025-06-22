extends RigidBody2D

var engine_thrust
var spin_thrust
var thrust: Vector2 = Vector2.ZERO
var rotation_dir: int = 0

func _ready():
	engine_thrust = Global.global_engine_thrust
	spin_thrust = Global.global_spin_thrust
	if Global.game_mode == Global.GameMode.PLAYER:
		pass



func _physics_process(delta):
	if Global.game_mode == Global.GameMode.PLAYER: handle_player_input(delta)
	apply_central_force(thrust)
	apply_torque(rotation_dir * spin_thrust)
	rotation_dir = rotation 
	

func handle_player_input(delta):
	var rotation_dir = 0 
	var pos_thrust = Input.is_key_pressed(KEY_W)
	if Input.is_key_pressed(KEY_A): rotation_dir -= 1
	if Input.is_key_pressed(KEY_D): rotation_dir += 1
	set_controls(pos_thrust, rotation_dir)

func set_controls(pos_thrust: bool, turn_dir: int):
	if pos_thrust: thrust = -transform.y * (engine_thrust) 
	else: thrust = Vector2.ZERO
	rotation_dir = turn_dir
