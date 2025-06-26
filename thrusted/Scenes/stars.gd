extends Node2D

@export var star_count: int = 150
@export var star_color: Color = Color.WHITE
@export var star_size_range: Vector2 = Vector2(1.0, 2.5)
@export var star_layers: int = 3
@export var drift_speed_range: Vector2 = Vector2(2.0, 5.0)
@export var twinkle_duration_range: Vector2 = Vector2(2.0, 4.0)
@export var drift_offset_range: Vector2 = Vector2(10.0, 20.0)
@export var layer_scale_dampening: float = 0.2
@export var allow_rotation: bool = false

class StarData:
	var node: Sprite2D
	var drift_origin: Vector2
	var drift_offset: Vector2
	var drift_speed: float
	var drift_timer: float = 0.0

var stars: Array[StarData] = []

func _ready():
	randomize()
	var viewport_size = get_viewport_rect().size
	var white_texture = _create_white_texture()

	for i in range(star_count):
		var star = Sprite2D.new()
		star.texture = white_texture
		star.modulate = _random_star_color()
		star.modulate.a = randf_range(0.2, 0.6)

		var mat = CanvasItemMaterial.new()
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		star.material = mat

		var layer = randi_range(0, star_layers - 1)
		star.z_index = layer

		var size = randf_range(star_size_range.x, star_size_range.y) * (1.0 - layer * layer_scale_dampening)
		star.scale = Vector2(size, size)

		var position = Vector2(
			randf_range(-viewport_size.x / 2, viewport_size.x / 2),
			randf_range(-viewport_size.y / 2, viewport_size.y / 2)
		)
		star.position = position

		if allow_rotation:
			star.rotation = randf_range(0, TAU)

		add_child(star)

		# Twinkle
		var alpha_from = randf_range(0.2, 0.4)
		var alpha_to = randf_range(0.8, 1.0)
		var duration = randf_range(twinkle_duration_range.x, twinkle_duration_range.y)

		var twinkle = create_tween().set_loops()
		twinkle.tween_property(star, "modulate:a", alpha_to, duration).from(alpha_from).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		twinkle.tween_property(star, "modulate:a", alpha_from, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		# Drift
		var drift = StarData.new()
		drift.node = star
		drift.drift_origin = position
		drift.drift_offset = Vector2(
			randf_range(-drift_offset_range.x, drift_offset_range.x),
			randf_range(-drift_offset_range.y, drift_offset_range.y)
		)
		drift.drift_speed = randf_range(drift_speed_range.x, drift_speed_range.y)
		stars.append(drift)

func _process(delta):
	for drift in stars:
		drift.drift_timer += delta * drift.drift_speed
		var t = sin(drift.drift_timer)
		drift.node.position = drift.drift_origin + drift.drift_offset * t

func _create_white_texture() -> Texture2D:
	var img = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	return ImageTexture.create_from_image(img)

func _random_star_color() -> Color:
	var hues = [0.1, 0.6, 0.0]
	var hue = hues[randi() % hues.size()] + randf_range(-0.05, 0.05)
	var sat = randf_range(0.05, 0.2)
	var val = randf_range(0.9, 1.0)
	return Color.from_hsv(hue, sat, val)
