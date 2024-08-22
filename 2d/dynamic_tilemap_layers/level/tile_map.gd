extends TileMap

# You can have multiple layers if you make this an array.
var secret_layer := 0
var player_in_secret := false
var layer_alpha := 1.0

func _init() -> void:
	for i in get_layers_count():
		# Find the secret layer by name.
		if get_layer_name(i) == "Secret":
			secret_layer = i


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if player_in_secret:
		if layer_alpha > 0.3:
			# Animate the layer transparency.
			layer_alpha = move_toward(layer_alpha, 0.3, delta)
			set_layer_modulate(secret_layer, Color(1, 1, 1, layer_alpha))
		else:
			set_process(false)
	else:
		if layer_alpha < 1.0:
			layer_alpha = move_toward(layer_alpha, 1.0, delta)
			set_layer_modulate(secret_layer, Color(1, 1, 1, layer_alpha))
		else:
			set_process(false)


func _use_tile_data_runtime_update(layer: int, _coords: Vector2i) -> bool:
	return layer == secret_layer


func _tile_data_runtime_update(_layer: int, _coords: Vector2i, tile_data: TileData) -> void:
	# Remove collision for secret layer.
	tile_data.set_collision_polygons_count(0, 0)


func _on_secret_detector_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		# Detect the player only.
		return

	player_in_secret = true
	set_process(true)


func _on_secret_detector_body_exited(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	player_in_secret = false
	set_process(true)
