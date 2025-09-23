extends Node2D

class_name InstanceManager
## Images
const Test1 = preload("uid://w8o0ryem7012")
const Tile1 = preload("uid://dvumjquc3ofs4")
const TileBlank = preload("uid://doyhfeyvrpplf")

## Enemies
const FLUB = preload("uid://ckhl8l6bj1bvv")
const GRUB = preload("uid://dojorw4mt1dsw")
const JUB = preload("uid://b4ljdiupnggrv")
const THUB = preload("uid://drjvl1sgqrjuy")

## Proximity Events
const FORGE = preload("uid://le5tbb8urp88")
const LOOT_CHEST = preload("uid://cll8qcsho5mrw")
const SHOP = preload("uid://cytotq02c1x2a")

## Spawning Stuff
var total_stopwatch: float
var spawning_stopwatch: float
var spawning_cooldown: float
@export var spawn_area: CollisionShape2D
@export var spawn_deadzone: CollisionShape2D
@export var background_parent: Node2D
var spawning: bool = false
var num_shops: int = 50
var num_forges: int = 50
var proximity_dic: Dictionary
var map_height: int = 10 ## this many chunks tall
var map_width: int = 10 ## this many chunks wide

## Chunks
var loaded_chunk_position: Vector2 = Vector2.ZERO
var chunk_y: float = 360
var chunk_x: float = 640
var chunk_grid: Vector2 = Vector2.ZERO
var chunk_rect: ColorRect
var chunks: Array[Sprite2D]
var loaded_chunk: Sprite2D
var chunks_dic: Dictionary

var started: bool = false

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
	for i in num_forges:
		var new_forge: Vector2 = Vector2(randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2), randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2))
		if !proximity_dic.has(new_forge):
			proximity_dic.get_or_add(new_forge, [FORGE, false])
		else:
			proximity_dic.get_or_add(Vector2(randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2), randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2)), FORGE)
	for i in num_shops:
		var new_shop: Vector2 = Vector2(randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2), randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2))
		if !proximity_dic.has(new_shop):
			proximity_dic.get_or_add(new_shop, [SHOP, false])
		else:
			proximity_dic.get_or_add(Vector2(randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2), randi_range(-(map_width * chunk_x) / 2, (map_height * chunk_y) / 2)), SHOP)

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
	## Check If Load New Chunk
	if !started:
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y)
		started = true
	elif pos.x >= loaded_chunk_position.x + (chunk_x / 2):
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
		print("refresh:")
		var spawnables: Array[PackedScene]
		
		for key in proximity_dic:
			#print("/n/nlooking at key: " + str(key))
			if Rect2(chunk_grid * Vector2(-640*1.5, -360*1.5), Vector2(640 * 3, 360 * 3)).has_point(key):
				#print("point has key: " + str(key))
				var thing: Array = proximity_dic.get(key)
				if thing[1] == false:
					#print("key is being instantiated at: " + str(key))
					proximity_dic.set(key, [thing[0], true])
					var real_thing = thing[0].instantiate()
					GameManager.instance.xp_parent.add_child(real_thing)
					real_thing.position = key
					print("new key exists: " + str(real_thing.position))
			else:
				pass#print(str(Rect2(chunk_grid * Vector2(640, 360), Vector2(640 * 6, 360 * 6))) + " does not have point: " + str(key))
		
		if !chunks_dic.has(chunk_grid):
			load_chunk(chunk_grid)
		else:
			pass#print("already had: Main")
		if !chunks_dic.has(chunk_grid + Vector2(0, -1)):
			load_chunk(chunk_grid + Vector2(0, -1))
		else:
			pass#print("already had: N")
		if !chunks_dic.has(chunk_grid + Vector2(0, 1)):
			load_chunk(chunk_grid + Vector2(0, 1))
		else:
			pass#print("already had: S")
		if !chunks_dic.has(chunk_grid + Vector2(1, 0)):
			load_chunk(chunk_grid + Vector2(1, 0))
		else:
			pass#print("already had: E")
		if !chunks_dic.has(chunk_grid + Vector2(-1, 0)):
			load_chunk(chunk_grid + Vector2(-1, 0))
		else:
			pass#print("already had: W")
		if !chunks_dic.has(chunk_grid + Vector2(-1, -1)):
			load_chunk(chunk_grid + Vector2(-1, -1))
		else:
			pass#print("already had: NW")
		if !chunks_dic.has(chunk_grid + Vector2(-1, 1)):
			load_chunk(chunk_grid + Vector2(-1, 1))
		else:
			pass#print("already had: SW")
		if !chunks_dic.has(chunk_grid + Vector2(1, -1)):
			load_chunk(chunk_grid + Vector2(1, -1))
		else:
			pass#print("already had: NE")
		if !chunks_dic.has(chunk_grid + Vector2(1, 1)):
			load_chunk(chunk_grid + Vector2(1, 1))
		else:
			pass#print("already had: SE")

func load_chunk(chunk_id: Vector2):
	var new_chunk: Sprite2D = Sprite2D.new()
	new_chunk.visible = false
	print(abs(chunk_id))
	if abs(chunk_id.x) > abs(map_width) || abs(chunk_id.y) > abs(map_height):
		new_chunk.texture = TileBlank
	else:
		new_chunk.texture = Tile1
	background_parent.add_child(new_chunk)
	new_chunk.position = ((chunk_id) * Vector2(640, 360))
	chunks.append(new_chunk)
	chunks_dic.get_or_add(chunk_id, new_chunk)
	new_chunk.visible = true

func draw_new_visual():
	chunk_rect.color = Color(0, 0, 0, 0)
	chunk_rect = ColorRect.new()
	chunk_rect.position = loaded_chunk_position - Vector2(chunk_x / 2, chunk_y / 2)
	chunk_rect.size = Vector2(chunk_x, chunk_y)
	chunk_rect.color = Color(1, 0, 0, .1)
	background_parent.add_child(chunk_rect)

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
