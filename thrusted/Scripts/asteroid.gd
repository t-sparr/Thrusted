extends RigidBody2D

@export var min_speed: float = 50
@export var max_speed: float = 150
@export var angular_vel_range: float = 2.0
@onready var screen_size = get_viewport_rect().size
func _ready():
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_speed, max_speed)
	randf_range(-angular_vel_range, angular_vel_range)
	
	linear_damp = 0
	angular_damp = 0

func _physics_process(delta: float) -> void:
	screen_wrap()

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
