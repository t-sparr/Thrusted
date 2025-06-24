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
		Vector2(-1, 1),  Vector2(0, 1), Vector2(1, 1)]

var LARGE_ASTEROID = [
	preload("res://Assets/Asteroids/large_asteroid_1.png"),
	preload("res://Assets/Asteroids/large_asteroid_2.png"),
	preload("res://Assets/Asteroids/large_asteroid_3.png"),
	preload("res://Assets/Asteroids/large_asteroid_4.png")]

var BIG_ASTEROID = [
	preload("res://Assets/Asteroids/big_asteroid_1.png"),
	preload("res://Assets/Asteroids/big_asteroid_2.png"),
	preload("res://Assets/Asteroids/big_asteroid_3.png"),
	preload("res://Assets/Asteroids/big_asteroid_4.png"),
	preload("res://Assets/Asteroids/big_asteroid_5.png"),
	preload("res://Assets/Asteroids/big_asteroid_6.png"),
	preload("res://Assets/Asteroids/big_asteroid_7.png"),
	preload("res://Assets/Asteroids/big_asteroid_8.png"),]

func _physics_process(delta: float) -> void:
	screen_wrap()
	update_ghosts()
	

func SET_UP_ASTEROID(asteroid):
	match asteroid:
		Global.Asteroid.LARGE:
			pass
		Global.Asteroid.BIG:
			set_up_big_asteroid()


func set_up_big_asteroid():
	var index = randi_range(0,BIG_ASTEROID.size()-1)
	var texture = BIG_ASTEROID[index]
	$Sprite.texture = texture
	$Sprite.centered = false
	
	# Get polygon from alpha and recenter it
	var raw_poly = get_polygon_from_sprite($Sprite)
	var center = Vector2.ZERO
	for point in raw_poly:
		center += point
	center /= raw_poly.size()

	var centered_poly = PackedVector2Array()
	for point in raw_poly:
		centered_poly.append(point - center)

	# Apply to main sprite and collision
	$Sprite.offset = -center
	$CollisionPolygon2D.polygon = centered_poly
	$CollisionPolygon2D.position = Vector2.ZERO

	# Physics
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_speed, max_speed)
	angular_velocity = randf_range(-angular_vel_range, angular_vel_range)

	# Apply to ghosts
	setup_ghosts(texture, centered_poly, -center)
	




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

func setup_ghosts(texture: Texture2D, polygon: PackedVector2Array, offset: Vector2) -> void:
	for i in range(ghost_container.get_child_count()):
		var ghost = ghost_container.get_child(i)
		var sprite = ghost.get_node("Sprite")
		sprite.texture = texture
		sprite.offset = offset
		sprite.centered = false

		var poly_node = ghost.get_node("CollisionPolygon2D")
		poly_node.polygon = polygon
		poly_node.position = Vector2.ZERO
	
func update_ghosts():
	for i in range(ghost_container.get_child_count()):
		var ghost = ghost_container.get_child(i)
		var offset = ghost_offsets[i] * screen_size
		ghost.global_position = global_position + offset
		ghost.global_rotation = global_rotation

func get_polygon_from_sprite(sprite: Sprite2D) -> Array:
	if not sprite.texture:
		return []

	var image := sprite.texture.get_image()
	if image.is_empty():
		return []

	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image)

	var polygons := bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()), 2.0)
	if polygons.size() > 0:
		print(polygons[0])
		return polygons[0]  # Return first polygon
	else:
		return []
