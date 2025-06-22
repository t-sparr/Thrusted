extends RigidBody2D

@export var min_speed: float = 50
@export var max_speed: float = 150
@export var angular_vel_range: float = 2.0
@onready var screen_size = get_viewport_rect().size
@onready var ghost_container = $Ghost_Container

var ghost_offsets = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, 0),                Vector2(1, 0),
		Vector2(-1, 1),  Vector2(0, 1), Vector2(1, 1)
	]

var LARGE_ASTEROID_POLY = {
	0: PackedVector2Array([
	Vector2(33.0, -97.0),
	Vector2(64.0, -87.0),
	Vector2(106.0, -30.0),
	Vector2(103.0, 39.0),
	Vector2(66.0, 85.0),
	Vector2(-1.0, 104.0),
	Vector2(-73.0, 98.0),
	Vector2(-104.0, 30.0),
	Vector2(-106.0, -34.0),
	Vector2(-71.0, -80.0),
	Vector2(3.0, -106.0),
	])
}

var LARGE_ASTEROID = [
	preload("res://Assets/Asteroids/large_asteroid_1.png"),
	preload("res://Assets/Asteroids/large_asteroid_2.png"),
	preload("res://Assets/Asteroids/large_asteroid_3.png"),
	preload("res://Assets/Asteroids/large_asteroid_4.png")
]
func _ready():
	set_up_large_asteroid()
	pass
	
	
func set_up_large_asteroid():
	var index = 0
	var size = 1
	$CollisionPolygon2D.polygon = LARGE_ASTEROID_POLY[index]
	$CollisionPolygon2D.scale = size * Vector2.ONE
	$Sprite.texture = LARGE_ASTEROID[index]
	$Sprite.scale = size * Vector2.ONE
	
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_speed, max_speed)
	angular_velocity = randf_range(-angular_vel_range, angular_vel_range)
	set_up_ghosts(LARGE_ASTEROID[index], LARGE_ASTEROID_POLY[index])

func _physics_process(delta: float) -> void:
	screen_wrap()
	update_ghosts()

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

func set_up_ghosts(ghost_tex, poly):
	for i in range(ghost_container.get_child_count()):
		var ghost = ghost_container.get_child(i)
		var sprite = ghost.get_node("Sprite")
		var child_poly = ghost.get_node("CollisionPolygon2D")
		sprite.texture = ghost_tex
		child_poly.polygon = poly
	
func update_ghosts():
	for i in range(ghost_container.get_child_count()):
		var ghost = ghost_container.get_child(i)
		var offset = ghost_offsets[i] * screen_size
		ghost.global_position = global_position + offset
		ghost.global_rotation = global_rotation
