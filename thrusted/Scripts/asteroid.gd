extends RigidBody2D

@export var min_speed: float = 50
@export var max_speed: float = 150
@export var angular_vel_range: float = 2.0
@onready var screen_size = get_viewport_rect().size
@onready var ghost_container = $Ghost_Container
enum ASTEROID_TYPE {LARGE, BIG}

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
		Vector2(3.0, -106.0),]),
	1: PackedVector2Array([
		Vector2(41.0, -97.0),
		Vector2(71.0, -83.0),
		Vector2(105.0, -26.0),
		Vector2(102.0, 43.0),
		Vector2(68.0, 100.0),
		Vector2(4.0, 112.0),
		Vector2(-66.0, 91.0),
		Vector2(-102.0, 34.0),
		Vector2(-106.0, -34.0),
		Vector2(-60.0, -81.0),
		Vector2(3.0, -113.0),]),
	2: PackedVector2Array([
		Vector2(-73.0, -93.0),
		Vector2(0.0, -108.0),
		Vector2(65.0, -91.0),
		Vector2(104.0, -33.0),
		Vector2(101.0, 34.0),
		Vector2(70.0, 93.0),
		Vector2(3.0, 107.0),
		Vector2(-67.0, 94.0),
		Vector2(-102.0, 31.0),
		Vector2(-105.0, -39.0),]),
	3: PackedVector2Array([
		Vector2(102.0, -30.0),
		Vector2(108.0, 42.0),
		Vector2(56.0, 100.0),
		Vector2(-4.0, 107.0),
		Vector2(-67.0, 89.0),
		Vector2(-105.0, 38.0),
		Vector2(-108.0, -21.0),
		Vector2(-60.0, -85.0),
		Vector2(3.0, -109.0),
		Vector2(64.0, -85.0),])
}

var BIG_ASTEROID_POLY = {
	0: PackedVector2Array([
		Vector2(-33.0, -42.0),
		Vector2(23.0, -41.0),
		Vector2(50.0, -1.0),
		Vector2(33.0, 32.0),
		Vector2(11.0, 29.0),
		Vector2(-21.0, 40.0),
		Vector2(-50.0, 10.0),
	])
}


var LARGE_ASTEROID = [
	preload("res://Assets/Asteroids/large_asteroid_1.png"),
	preload("res://Assets/Asteroids/large_asteroid_2.png"),
	preload("res://Assets/Asteroids/large_asteroid_3.png"),
	preload("res://Assets/Asteroids/large_asteroid_4.png")
]

var BIG_ASTEROID = [
	preload("res://Assets/Asteroids/meteorBrown_big1.png"),
	preload("res://Assets/Asteroids/meteorBrown_big2.png"),
	preload("res://Assets/Asteroids/meteorBrown_big3.png"),
	preload("res://Assets/Asteroids/meteorBrown_big4.png")
]

func SET_UP_ASTEROID(asteroid):
	match asteroid:
		Global.Asteroid.LARGE:
			set_up_large_asteroid()
		Global.Asteroid.BIG:
			set_up_big_asteroid()
			

	
func set_up_large_asteroid():
	var index = randi_range(0,3)
	var size = 1
	$CollisionPolygon2D.polygon = LARGE_ASTEROID_POLY[index]
	$CollisionPolygon2D.scale = size * Vector2.ONE
	$Sprite.texture = LARGE_ASTEROID[index]
	$Sprite.scale = size * Vector2.ONE
	
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_speed, max_speed)
	angular_velocity = randf_range(-angular_vel_range, angular_vel_range)
	set_up_ghosts(LARGE_ASTEROID[index], LARGE_ASTEROID_POLY[index])

func set_up_big_asteroid():
	var index = 0
	var size = 1
	$CollisionPolygon2D.polygon = BIG_ASTEROID_POLY[index]
	$CollisionPolygon2D.scale = size * Vector2.ONE
	$Sprite.texture = BIG_ASTEROID[index]
	$Sprite.scale = size * Vector2.ONE
	
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_speed, max_speed)
	angular_velocity = randf_range(-angular_vel_range, angular_vel_range)
	set_up_ghosts(BIG_ASTEROID[index], BIG_ASTEROID_POLY[index])


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
