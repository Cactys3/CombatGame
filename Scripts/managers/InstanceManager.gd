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

## Bosses
const TESTBOSS = preload("uid://davhmwwacx2xv")


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
@export var event_parent: Node2D
var spawning: bool = false
var event_arr: Array
var map_height: int = 10 ## this many chunks tall
var map_width: int = 10 ## this many chunks wide

## Enemies
static var enemies_spawned: int = 0
static var enemies_killed: int = 0
static var enemies_alive: int = 0
## Bosses
static var bosses_spawned: int = 0
static var bosses_killed: int = 0
static var bosses_alive: int = 0

## kills until next boss spawn
var kills_needed: int = 50 
## kills aquired since last boss spawn
var kills_left: int = 0 

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
	call_deferred("connect_signals")

func connect_signals():
	GameManager.instance.EnemyKilled.connect(enemy_killed)
	GameManager.instance.BossKilled.connect(boss_killed)

func _process(delta: float) -> void:
	var pos = GameManager.instance.player.position
	GameManager.instance.ui_man.fps_label.text = str(Engine.get_frames_per_second())
	handle_chunks(pos)
	handle_enemy_spawns(delta, pos)

func handle_enemy_spawns(delta: float, pos: Vector2):
	total_stopwatch += delta
	if spawning:
		spawning_stopwatch += delta
	## Set Stopwatch Label
	GameManager.instance.ui_man.stopwatch_label.text = str(int(total_stopwatch / 60)) + ":" + str(int(fmod(total_stopwatch, 60.0))) 
	if spawning_stopwatch > spawning_cooldown:
		if spawning_cooldown > 0.1:
			spawning_cooldown -= 0.001
		spawning_stopwatch = 0
		spawn_enemy(GRUB, random_position(pos))

## Handles spawning new chunks and calculating whats inside them
func handle_chunks(pos: Vector2):
	var refresh: bool = true
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
		print("refresh: " + str(chunk_grid))
		
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
	var generate_shop: int = 0
	var generate_forge: int = 0
	if abs(chunk_id.x) > abs(map_width) || abs(chunk_id.y) > abs(map_height):
		new_chunk.texture = TileBlank
	else:
		new_chunk.texture = Tile1
		while randf() > 0.95:
			generate_forge += 1
		while randf() > 0.85:
			generate_shop += 1
	while generate_shop > 0:
		generate_shop -= 1
		load_event(SHOP, chunk_id)
	while generate_forge > 0:
		generate_forge -= 1
		load_event(FORGE, chunk_id)
	background_parent.add_child(new_chunk)
	new_chunk.position = ((chunk_id) * Vector2(640, 360))
	chunks.append(new_chunk)
	chunks_dic.get_or_add(chunk_id, new_chunk)
	new_chunk.visible = true

func load_event(scene: PackedScene, chunk: Vector2):
	var new_event = scene.instantiate()
	event_parent.add_child(new_event)
	## Get random point inside the chunk and spawn event
	var center := Vector2(chunk.x * chunk_x, chunk.y * chunk_y)
	var half := Vector2(chunk_x, chunk_y) / 2.0
	var new_min := center - half
	var new_max := center + half
	new_event.position = Vector2(randf_range(new_min.x, new_max.x), randf_range(new_min.y, new_max.y))
	event_arr.append(new_event)
	#print("Load in Chunk: " + str(chunk) + " Event at: " + str(new_event.position))

func draw_new_visual():
	chunk_rect.color = Color(0, 0, 0, 0)
	chunk_rect = ColorRect.new()
	chunk_rect.position = loaded_chunk_position - Vector2(chunk_x / 2, chunk_y / 2)
	chunk_rect.size = Vector2(chunk_x, chunk_y)
	chunk_rect.color = Color(1, 0, 0, .1)
	background_parent.add_child(chunk_rect)

func spawn_enemy(scene: PackedScene, pos: Vector2):
	enemies_alive += 1
	enemies_spawned += 1
	var enemy = scene.instantiate()
	enemy.visible = false
	enemy.global_position = pos
	GameManager.instance.enemy_parent.add_child(enemy)
	enemy.visible = true

func spawn_boss(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	var boss = scene.instantiate()
	boss.visible = false
	boss.global_position = pos
	GameManager.instance.enemy_parent.add_child(boss)
	boss.visible = true

func enemy_killed():
	enemies_alive -= 1
	enemies_killed += 1
	GameManager.instance.ui_man.enemies_killed_label.text = str(enemies_killed)
	print("Killed: " + str(enemies_killed))
	if kills_left <= 0:
		kills_needed = kills_needed * 0.95
		kills_left = kills_needed
		spawn_boss(TESTBOSS, random_position(GameManager.instance.player.position))

func boss_killed():
	bosses_killed += 1
	bosses_alive -= 1
	GameManager.instance.ui_man.bosses_killed_label.text = str(bosses_killed)

func toggle_spawning(value: bool):
	spawning = value

func random_position(player_pos: Vector2) -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area.shape.radius - spawn_deadzone.shape.radius) + spawn_deadzone.shape.radius
	# Return global position + random offset
	var angle = Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))).normalized()
	var pos = player_pos + angle * r
	#print("radius: " + str(r))
	#print("angle: " + str(angle))
	#print("position: " + str(pos))
	#print("distance to player: " + str(player_pos.distance_to(pos)))
	return pos

func SpawningButtonPressed() -> void:
	toggle_spawning(!spawning)
