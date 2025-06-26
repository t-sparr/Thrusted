extends Node2D

@export var asteroid_scene: PackedScene
@onready var screen_size = get_viewport_rect().size



func _ready():
		
		for i in range(3):
			spawn_asteroid(Vector2.ZERO, 200, Global.Asteroid.LARGE)
		for i in range(4):
			spawn_asteroid(Vector2.ZERO, 200, Global.Asteroid.BIG)
		for i in range(3):
			spawn_asteroid(Vector2.ZERO, 200, Global.Asteroid.MED)
		for i in range(2):
			spawn_asteroid(Vector2.ZERO, 200, Global.Asteroid.SMALL)
		for i in range(2):
			spawn_asteroid(Vector2.ZERO, 200, Global.Asteroid.TINY)

		


func spawn_asteroid(center: Vector2, exclude_radius: float, asteroid_type: Global.Asteroid):
		var pos = get_position_outside_circle(center, exclude_radius)
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = pos
		add_child(asteroid)
		asteroid.SET_UP_ASTEROID(asteroid_type)
			
		
		
		

func get_position_outside_circle(center: Vector2, min_radius: float) -> Vector2:
	var angle = randf_range(0, TAU)
	
	# Calculate the farthest distance from center to any corner
	var corners = [
		Vector2(0, 0),
		Vector2(screen_size.x, 0),
		Vector2(0, screen_size.y),
		Vector2(screen_size.x, screen_size.y)
	]
	var max_radius = 0.0
	for corner in corners:
		max_radius = max(max_radius, center.distance_to(corner))
	
	# Choose a random radius between min_radius and max_radius
	var radius = randf_range(min_radius, max_radius)
	var offset = Vector2(cos(angle), sin(angle)) * radius
	return center + offset
