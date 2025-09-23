extends Node2D

class_name InstanceManager
const Tile1 = preload("uid://w8o0ryem7012")
const FLUB = preload("uid://ckhl8l6bj1bvv")
const GRUB = preload("uid://dojorw4mt1dsw")
const JUB = preload("uid://b4ljdiupnggrv")
const THUB = preload("uid://drjvl1sgqrjuy")

var total_stopwatch: float
var spawning_stopwatch: float
var spawning_cooldown: float
@export var spawn_area: CollisionShape2D
@export var spawn_deadzone: CollisionShape2D
@export var background_parent: Node2D
var spawning: bool = false

var loaded_chunk_position: Vector2 = Vector2.ZERO
var chunk_y: float = 360
var chunk_x: float = 640
var chunk_grid: Vector2 = Vector2.ZERO
var chunk_rect: ColorRect
var chunks: Array[Sprite2D]
var loaded_chunk: Sprite2D

var chunks_dic: Dictionary

## Handles Spawning Enemies Based on Instance State variables
## Handles Spawning Bosses
## Handles Spawning Shops
## Handles Spawning Forges

# https://www.youtube.com/watch?v=0tPFpL977eY

func _ready() -> void:
	total_stopwatch = 0
	spawning_stopwatch = 0 
	spawning_cooldown = 1
	chunk_rect = ColorRect.new()

func _process(delta: float) -> void:
	handle_chunks()
	
	total_stopwatch += delta
	if spawning:
		spawning_stopwatch += delta
	## Set Stopwatch Label
	GameManager.instance.ui_man.stopwatch_label.text = str(int(total_stopwatch / 60)) + ":" + str(int(fmod(total_stopwatch, 60.0))) 
	
	if spawning_stopwatch > spawning_cooldown:
		if spawning_cooldown > 0.1:
			spawning_cooldown -= 0.001
		spawning_stopwatch = 0
		spawn_random_enemy(random_position())
		print("spawn enemy")

func handle_chunks():
	var refresh: bool = true
	var pos = GameManager.instance.player.position
	if pos.x >= loaded_chunk_position.x + (chunk_x / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x + chunk_x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x + 1, chunk_grid.y)
	elif pos.x <= loaded_chunk_position.x - (chunk_x / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x - chunk_x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x - 1, chunk_grid.y)
	elif pos.y >= loaded_chunk_position.y + (chunk_y / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y + chunk_y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y + 1)
	elif pos.y <= loaded_chunk_position.y - (chunk_y / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y - chunk_y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y - 1)
	else:
		refresh = false
	if refresh:
		draw_new_visual()
		loaded_chunk
		var new_chunk: Sprite2D = Sprite2D.new()
		new_chunk.texture = Tile1
		background_parent.add_child(new_chunk)
		new_chunk.position = (chunk_grid * Vector2(640, 360))
		chunks.append(new_chunk)
		chunks_dic.get_or_add(chunk_grid, new_chunk)
		loaded_chunk = new_chunk
		
		##TODO: Run a chunks_dic.has(chunk_grid) before making each new background
		var new_chunk_north: Sprite2D = Sprite2D.new()
		new_chunk_north.texture = Tile1
		background_parent.add_child(new_chunk_north)
		new_chunk_north.position = ((chunk_grid + Vector2(0, 1)) * Vector2(640, 360))
		chunks.append(new_chunk_north)
		chunks_dic.get_or_add(chunk_grid + Vector2(0, 1), new_chunk_north)
		var new_chunk_south: Sprite2D = Sprite2D.new()
		new_chunk_south.texture = Tile1
		background_parent.add_child(new_chunk_south)
		new_chunk_south.position = ((chunk_grid + Vector2(0, -1)) * Vector2(640, 360))
		chunks.append(new_chunk_south)
		chunks_dic.get_or_add(chunk_grid + Vector2(0, -1), new_chunk_south)
		var new_chunk_east: Sprite2D = Sprite2D.new()
		new_chunk_east.texture = Tile1
		background_parent.add_child(new_chunk_east)
		new_chunk_east.position = ((chunk_grid + Vector2(1, 0)) * Vector2(640, 360))
		chunks.append(new_chunk_east)
		chunks_dic.get_or_add(chunk_grid + Vector2(1, 0), new_chunk_east)
		var new_chunk_west: Sprite2D = Sprite2D.new()
		new_chunk_west.texture = Tile1
		background_parent.add_child(new_chunk_west)
		new_chunk_west.position = ((chunk_grid + Vector2(-1, 0)) * Vector2(640, 360))
		chunks.append(new_chunk_west)
		chunks_dic.get_or_add(chunk_grid + Vector2(-1, 0), new_chunk_west)
		
		var new_chunk_north_west: Sprite2D = Sprite2D.new()
		new_chunk_north_west.texture = Tile1
		background_parent.add_child(new_chunk_north_west)
		new_chunk_north_west.position = ((chunk_grid + Vector2(-1, 1)) * Vector2(640, 360))
		chunks.append(new_chunk_north_west)
		chunks_dic.get_or_add(chunk_grid + Vector2(-1, 1), new_chunk_north_west)
		var new_chunk_south_west: Sprite2D = Sprite2D.new()
		new_chunk_south_west.texture = Tile1
		background_parent.add_child(new_chunk_south_west)
		new_chunk_south_west.position = ((chunk_grid + Vector2(-1, -1)) * Vector2(640, 360))
		chunks.append(new_chunk_south_west)
		chunks_dic.get_or_add(chunk_grid + Vector2(-1, -1), new_chunk_south_west)
		var new_chunk_north_east: Sprite2D = Sprite2D.new()
		new_chunk_north_east.texture = Tile1
		background_parent.add_child(new_chunk_north_east)
		new_chunk_north_east.position = ((chunk_grid + Vector2(1, 1)) * Vector2(640, 360))
		chunks.append(new_chunk_north_east)
		chunks_dic.get_or_add(chunk_grid + Vector2(1, 1), new_chunk_north_east)
		var new_chunk_south_east: Sprite2D = Sprite2D.new()
		new_chunk_south_east.texture = Tile1
		background_parent.add_child(new_chunk_south_east)
		new_chunk_south_east.position = ((chunk_grid + Vector2(1, -1)) * Vector2(640, 360))
		chunks.append(new_chunk_south_east)
		chunks_dic.get_or_add(chunk_grid + Vector2(1, -1), new_chunk_south_east)


func draw_new_visual():
	chunk_rect.color = Color(0, 0, 0, 0)
	chunk_rect = ColorRect.new()
	chunk_rect.position = loaded_chunk_position - Vector2(chunk_x / 2, chunk_y / 2)
	chunk_rect.size = Vector2(chunk_x, chunk_y)
	chunk_rect.color = Color(1, 0, 0, .1)
	GameManager.instance.xp_parent.add_child(chunk_rect)

func spawn_random_enemy(pos: Vector2):
	var enemy = GRUB.instantiate()
	enemy.visible = false
	GameManager.instance.enemy_parent.add_child(enemy)
	enemy.global_position = pos
	enemy.visible = true

func toggle_spawning(value: bool):
	spawning = value

func random_position() -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area.shape.radius - spawn_deadzone.shape.radius) + spawn_deadzone.shape.radius
	# Return global position + random offset
	return GameManager.instance.player.global_position + Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))) * r



func SpawningButtonPressed() -> void:
	toggle_spawning(!spawning)
