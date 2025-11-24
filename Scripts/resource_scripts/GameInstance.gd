extends Node2D
## Must be inherited by a Map to function fully
## Handles: Losing/Winning Game, Stopwatch, Spawning Enemies, Bosses, Shops, Forges, Events, Map Tiles
class_name GameInstance

static var instance: GameInstance
var TITLE_SCENE
## Nodes
var camera: Camera2D
var game_man: GameManager
var ui_man: UIManager
var background_parent: Node2D
var event_parent: Node2D
var enemy_parent: Node2D
var xp_parent: Node2D
var character_parent: Node2D
var weapon_parent: Node2D
var spawn_area: CollisionShape2D
var spawn_deadzone: CollisionShape2D
## Images
const TileBlank = preload("uid://doyhfeyvrpplf")
const TileExample = preload("uid://dvumjquc3ofs4")
## Enemies
## Bosses
## Proximity Events
const FORGE = preload("uid://le5tbb8urp88")
const LOOT_CHEST = preload("uid://cll8qcsho5mrw")
const SHOP = preload("uid://cytotq02c1x2a")
var events: Array[Event] # stores event objects of all spawnable events
## Spawning Stuff
var total_stopwatch: float = 0
var spawning_stopwatch: float = 0
var spawning_cooldown: float = 1
var spawning_phase: int = 1
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
var kills_needed: float = 50 
## kills aquired since last boss spawn
var kills_left: float = 0 
## Chunks
var loaded_chunk_position: Vector2 = Vector2.ZERO
var chunk_y: float = 360
var chunk_x: float = 640
var chunk_grid: Vector2 = Vector2.ZERO
var chunk_rect: ColorRect
var chunks: Array[Sprite2D]
var loaded_chunk: Sprite2D
var chunks_dic: Dictionary
## Rounds
# have different 'events' that decide what enemies to spawn
var started: bool = false
# https://www.youtube.com/watch?v=0tPFpL977eY
func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
## Sets up the GameInstance by giving parameter values (character should be resource so can change default values?)
func setup(character: Character, run_modifiers) -> void:
	character_parent.add_child(character)
	camera.reparent(character)
	TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	chunk_rect = ColorRect.new()
	call_deferred("connect_signals")
	setup_events()
	game_man.setup(character)
func connect_signals():
	game_man.EnemyKilled.connect(enemy_killed)
	game_man.BossKilled.connect(boss_killed)
## Adds all events for this map to events - Override
func setup_events(): 
	var shop: Event = Event.new()
	var forge: Event = Event.new()
	shop.setup("shop", SHOP, 0.15, -1, 1)
	forge.setup("forge", FORGE, 0.20, -1, 1)
func _process(delta: float) -> void:
	var pos = game_man.player.position
	## Set Temporary Labels
	ui_man.stopwatch_label.text = str(int(total_stopwatch / 60)) + ":" + str(int(fmod(total_stopwatch, 60.0))) 
	ui_man.fps_label.text = str(Engine.get_frames_per_second())
	handle_chunks(pos)
	handle_enemy_spawns(delta, pos)
## Creates MainMenu Scene and removes current Scene
func return_to_main_menu() -> void:
	if TITLE_SCENE == null:
		TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	get_tree().paused = false
	#change scene
	get_tree().current_scene.queue_free()
	var new_instance = TITLE_SCENE.instantiate()
	get_tree().root.add_child(new_instance)
	get_tree().current_scene = new_instance

func handle_enemy_spawns(delta: float, pos: Vector2):
	## TODO: below
	## Set Enemies with percent changes of them each to spawn (ex: Grubs, 30%)
	# use the weighted thing, give each enemy a weight and calculate percents based on that
	## Set Spawning_Cooldown based on which how strong enemies are to spawn are
	if total_stopwatch < 1 * 60: ## Minute 1 Spawns
		if !(spawning_phase == 1):
			pass
	elif total_stopwatch < 2 * 60: ## Minute 2 Spawns
		if !(spawning_phase == 2):
			pass
	elif total_stopwatch < 3 * 60: ## Minute 3 Spawns
		if !(spawning_phase == 3):
			pass
	elif total_stopwatch < 4 * 60: ## Minute 4 Spawns
		if !(spawning_phase == 4):
			pass
	
	## Spawning Hordes Logic Goes Here 
	
	## Calculate which enemy will spawn
	## Set spawning_cooldown based on how strong that enemy is and the current thing
	## New Class: EnemySpawn
	# - Enemy To Spawn
	# - spawning_cooldown_modifier (added/subtracted to next spawning_cooldown)
	# - weight value (in the percent to spawn calculation) to spawn it?
	## New Class: WeightedSpawningList
	# - get_random_enemy() -> enemy
	# - add_enemy(enemy, weight)
	
	
	## Default Enemy Spawning Logic:
	total_stopwatch += delta
	if spawning:
		spawning_stopwatch += delta
	if spawning_stopwatch > spawning_cooldown:
		if spawning_cooldown > 0.1:
			spawning_cooldown -= 0.001
		spawning_stopwatch = 0
		#spawn_enemy(GRUB, random_position(pos))

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
	# if chunk is without of map bounds
	if abs(chunk_id.x) > abs(map_width) || abs(chunk_id.y) > abs(map_height):
		new_chunk.texture = TileBlank
	else:
		new_chunk.texture = get_rand_tile()
		handle_event_spawns(chunk_id)
	background_parent.add_child(new_chunk)
	new_chunk.position = ((chunk_id) * Vector2(640, 360))
	chunks.append(new_chunk)
	chunks_dic.get_or_add(chunk_id, new_chunk)
	new_chunk.visible = true
## Spawns any events that should be spawned in newly created chunk
func handle_event_spawns(chunk_id: Vector2):
	for event in events:
		if event.can_spawn():
			for i in event.max_per_tile:
				if randf() < event.spawn_chance:
					load_event(event.scene, chunk_id)

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
	game_man.enemy_parent.add_child(enemy)
	enemy.visible = true

func spawn_boss(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	var boss = scene.instantiate()
	boss.visible = false
	boss.global_position = pos
	game_man.enemy_parent.add_child(boss)
	boss.visible = true

func enemy_killed():
	enemies_alive -= 1
	enemies_killed += 1
	ui_man.enemies_killed_label.text = str(enemies_killed)
	print("Killed: " + str(enemies_killed))
	if kills_left <= 0:
		kills_needed = kills_needed * 0.95
		kills_left = kills_needed
		#spawn_boss(TESTBOSS, random_position(game_man.player.position))

func boss_killed():
	bosses_killed += 1
	bosses_alive -= 1
	ui_man.bosses_killed_label.text = str(bosses_killed)

func toggle_spawning(value: bool):
	spawning = value

func random_position(player_pos: Vector2) -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area.shape.radius - spawn_deadzone.shape.radius) + spawn_deadzone.shape.radius
	# Return global position + random offset
	var angle = Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))).normalized()
	var pos = player_pos + angle * r
	return pos

func SpawningButtonPressed(b: bool) -> void:
	toggle_spawning(b)

## Overrides

## Gets tile from matrix? - Override
func get_tile() -> Texture2D:
	return TileExample
## Gets random tile for map - Override
func get_rand_tile() -> Texture2D:
	return TileExample


class Event:
	var name: String = "default"
	var scene: PackedScene
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	## number of events that can be created per map, -1 for infinite
	var max_spawns: int = -1
	## number of events that have been spawned
	var spawn_count: int = 0
	## max number of events per tile
	var max_per_tile: int = 1
	var ready: bool = false
	func setup(new_name: String, new_scene: PackedScene, new_spawn_chance: float, new_max_spawns: int, new_max_per_tile: int):
		name = new_name
		scene = new_scene
		spawn_chance = new_spawn_chance
		max_spawns = new_max_spawns
		max_per_tile = new_max_per_tile
		ready = true
	## returns if another event can be spawned
	func can_spawn() -> bool:
		if !ready:
			return false
		if max_spawns == -1:
			return true
		return spawn_count < max_spawns
