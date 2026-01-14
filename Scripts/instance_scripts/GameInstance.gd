extends Node2D
## Must be inherited by a Map to function fully
## Handles: Losing/Winning Game, Stopwatch, Spawning Enemies, Bosses, Shops, Forges, Events, Map Tiles
class_name GameInstance

static var instance: GameInstance
var TITLE_SCENE
## Nodes
var character: Character
var global_stats: StatsResource
var camera: Camera2D
var game_man: GameManager
var ui_man: UIManager
var background_parent: Node2D
var event_parent: Node2D
var enemy_parent: Node2D
var xp_parent: Node2D
var character_parent: Node2D
var weapon_parent: Node2D
## Images
const TileBlank = preload("uid://doyhfeyvrpplf")
var TILES: Array = []
## Enemies
## Bosses
## Proximity Events
const FORGE = preload("uid://le5tbb8urp88")
const LOOT_CHEST = preload("uid://cll8qcsho5mrw")
const SHOP = preload("uid://cytotq02c1x2a")
const STAT_SCROLL = preload("uid://bqo1xj4v5qth7")
var events: Array[EventSpawn] # stores event objects of all spawnable events
var enemies: Array[EnemySpawn] # stores enemies to spawn 
var enemy_events: Array[EnemyEventSpawn]
var bosses: Array[BossSpawn] # stores bosses to spawn
var phases: Array[SpawningPhase] # stores the phases to spawn enemies in
var current_phase: SpawningPhase
## Chances
static var enemy_chance_to_drop_component: float = 0.01
static var next_enemy_drops_component: bool = false
var enemies_since_component: int = 0
var enemies_per_component: int = 150
static var next_enemy_drops_forge: bool = true
var enemies_since_forge: int = 0
var enemies_per_forge: int = 50
## Spawning Stuff
var win_time: float = 10
var total_stopwatch: float = 0
var spawning_stopwatch: float = 0
var spawning_cooldown: float = 1
var spawning_phase: int = -1
var event_arr: Array
var map_height: int = 10 ## this many chunks tall
var map_width: int = 10 ## this many chunks wide
const spawn_area_size: float = 650
const spawn_deadzone_size: float = 400
## Enemies
static var enemies_spawned: int = 0
static var enemies_killed: int = 0
static var enemies_alive: int = 0
static var min_enemies: int = 30
static var max_enemies: int = 90
static var default_min_enemies: int = 30 ## Fallback values for when max/min_enemies is changed
static var default_max_enemies: int = 90
static var enemy_max_distance_to_player: float = 1000 ## Max distance enemies cane from player before being freed
## Enemy Events
static var enemy_events_alive: int = 0
static var enemy_events_spawned: int = 0
## Bosses
static var bosses_spawned: int = 0
static var bosses_killed: int = 0
static var bosses_alive: int = 0
## kills until next boss spawn
var kills_needed: float = 50 
## kills aquired since last boss spawn
var kills_left: float = 0 
## Player Level, calculated in enemy health
var level: float:
	get():
		return game_man.level
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
func setup(new_character: Character, new_weapon: int, new_global_stats: StatsResource, run_modifiers) -> void:
	character_parent.add_child(new_character)
	camera.reparent(new_character)
	TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	chunk_rect = ColorRect.new()
	call_deferred("connect_signals")
	setup_events()
	game_man.setup(new_character, new_weapon, new_global_stats)
	character = new_character
	global_stats = new_global_stats
	add_tiles()
func connect_signals():
	game_man.EnemyKilled.connect(enemy_killed)
	game_man.BossKilled.connect(boss_killed)
## Adds all events for this map to events - Override
func setup_events(): 
	pass
func _process(delta: float) -> void:
	if !instance:
		instance = self
	var pos = character.position #game_man.player.position
	ui_man.set_fps(Engine.get_frames_per_second())
	if game_man && game_man.paused == false:
		handle_stopwatch(delta)
		handle_enemy_spawning(delta, pos)
	handle_spawn_phases()
	handle_chunks(pos)
	if enemies_alive > max_enemies:
		despawn_enemies(game_man.player.global_position, enemies_alive - max_enemies)
	elif enemies_alive < min_enemies:
		spawn_backups(game_man.player.global_position, min_enemies - enemies_alive)
## Creates MainMenu Scene and removes current Scene
func return_to_main_menu() -> void:
	## Tell Player They Won
	ui_man.toggle_you_win(true)
	get_tree().paused = true
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	## Change Scenes
	if TITLE_SCENE == null:
		TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	get_tree().current_scene.queue_free()
	var new_instance = TITLE_SCENE.instantiate()
	get_tree().root.add_child(new_instance)
	get_tree().current_scene = new_instance
func handle_stopwatch(delta: float):
	total_stopwatch += delta
	ui_man.set_stopwatch(total_stopwatch)
	if total_stopwatch >= win_time:
		return_to_main_menu()
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
		#draw_new_visual()
		#print("refresh: " + str(chunk_grid))
		
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
## Only spawn enemies / check to spawn bosses every so often
func handle_enemy_spawning(delta: float, pos: Vector2):
	spawning_stopwatch += delta
	if spawning_stopwatch > spawning_cooldown:
		spawning_stopwatch = 0
		spawn_enemies(pos)
		spawn_bosses(pos)
		spawn_enemy_events(pos)
func load_chunk(chunk_id: Vector2):
	var new_chunk: Sprite2D = Sprite2D.new()
	new_chunk.visible = false
	# if chunk is without of map bounds
	if abs(chunk_id.x) > abs(map_width) || abs(chunk_id.y) > abs(map_height):
		new_chunk.texture = TileBlank
	else:
		new_chunk.texture = get_rand_tile()
		spawn_events(chunk_id)
	background_parent.add_child(new_chunk)
	new_chunk.position = ((chunk_id) * Vector2(640, 360))
	chunks.append(new_chunk)
	chunks_dic.get_or_add(chunk_id, new_chunk)
	new_chunk.visible = true
## Despawns the enemy that is farthest from position
func despawn_enemies(pos: Vector2, num: int):
	print("Too many enemies, Despawning " + str(num) + "!")
	var enemie: Array = get_tree().get_nodes_in_group("enemy")
	enemie.sort_custom(func(a, b): return a.global_position.distance_to(pos) > b.global_position.distance_to(pos))
	for i: int in num:
		if enemie.size() > 0:
			var enemy: Enemy = enemie[0]
			enemie.erase(enemy)
			remove_enemy(enemy)
## Removes enemy from game without triggering death things like gain xp/money
func remove_enemy(enemy: Enemy):
	enemy.queue_free()
	enemies_alive -= 1
	enemies_spawned -= 1
## Spawns backup enemies until min_enemies is met
func spawn_backups(pos: Vector2, num: int):
	print("Not enough enemies, Spawning " + str(num) + "!")
	var counter: int = 0
	var enemies_added: int = 0
	var initial_enemies: int = enemies_alive
	while(enemies_added < num && counter < 500):
		spawn_enemies(game_man.player.global_position)
		enemies_added = enemies_alive - initial_enemies
		counter += 1
## Spawns any events that should be spawned in newly created chunk
func spawn_events(chunk_id: Vector2):
	for event in events:
		if event.can_spawn():
			for i in event.max_per_tile:
				if randf() < event.spawn_chance:
					load_event(event.scene, chunk_id)
					event.spawn_count += 1
## Goes through enemies in enemies and spawns based on data
func spawn_enemies(pos: Vector2):
	for enemy in enemies:
		if enemy.can_spawn():
			for i in enemy.max_attempts:
				if randf() < enemy.spawn_chance:
					spawn_enemy(enemy.scene, random_position(pos))
## Goes through enemy events in enemy_events and spawns based on data
func spawn_enemy_events(pos: Vector2):
	for event in enemy_events:
		if event.can_spawn():
			if randf() < event.spawn_chance:
				spawn_enemy_event(event.scene, random_position(pos), event)
				event.curr_spawns += 1
## Goes through enemies in enemies and spawns based on data
func spawn_bosses(pos: Vector2):
	for boss in bosses:
		if boss.can_spawn():
			if boss.spawn_once_on_start:
				boss.spawn_once_on_start = false
				spawn_boss(boss.scene, random_position(pos))
			for i in boss.get_spawns(enemies_killed, total_stopwatch):
				spawn_boss(boss.scene, random_position(pos))
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
	if new_event.has_method("setup"):
		new_event.setup(level)
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
	enemy.initialize(level)
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
func spawn_enemy_event(scene: PackedScene, pos: Vector2, enemy_event_spawn: EnemyEventSpawn):
	enemy_events_alive += 1
	enemy_events_spawned += 1
	var event = scene.instantiate()
	event.visible = false
	event.global_position = pos
	game_man.enemy_parent.add_child(event)
	event.visible = true
	event.initialize(level, game_man.player.global_position, enemy_event_spawn)
func spawn_final_boss(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	var boss: Boss = scene.instantiate()
	boss.visible = false
	boss.global_position = pos
	game_man.enemy_parent.add_child(boss)
	boss.visible = true
	
	boss.death.connect(final_boss_death)
func final_boss_death(boss_position: Vector2):
	return_to_main_menu()
func enemy_killed():
	enemies_alive -= 1
	enemies_killed += 1
	ui_man.set_kills(enemies_killed)
	#print("Killed: " + str(enemies_killed))
	if enemies_since_forge >= enemies_per_forge:
		enemies_since_forge = 0
		next_enemy_drops_forge = true
	if enemies_since_component >= enemies_per_component:
		enemies_since_component = 0
		next_enemy_drops_component = true
	if kills_left <= 0:
		kills_needed = kills_needed * 0.95
		kills_left = kills_needed
		#spawn_boss(TESTBOSS, random_position(game_man.player.position))
func boss_killed():
	bosses_killed += 1
	bosses_alive -= 1
	ui_man.bosses_killed_label.text = str(bosses_killed)
func enemy_event_killed():
	enemy_events_alive -= 1
static func random_position(player_pos: Vector2) -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area_size - spawn_deadzone_size) + spawn_deadzone_size
	# Return global position + random offset
	var angle = Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))).normalized()
	var pos = player_pos + angle * r
	return pos
func SpawningButtonPressed(b: bool) -> void:
	pass

## Overrides
func add_tiles():
	pass
## Check/Change Spawn Phases, setup enemies/events accordingly
func handle_spawn_phases():
	## Check if current phase continues
	if current_phase && current_phase.should_start_or_continue(total_stopwatch):
		return
	## Find new phase since current phase is completed
	for phase in phases:
		if phase.should_start_or_continue(total_stopwatch):
			current_phase = phase
			return
	## Didn't find a phase...?
## Gets tile from matrix? - Override
func get_tile(index: int) -> Texture2D:
	if TILES.size() > index && index > -1:
		return TILES[index]
	return TileBlank
## Gets random tile for map - Override
func get_rand_tile() -> Texture2D:
	return TILES[randi_range(0, TILES.size() - 1)]
## Contains data for the data to consider each time enemies are spawned
class EnemySpawn: ## TODO: add in functionality to enemy spawn in a line across the screen? just make a scene with that tbh
	var name: String = "default"
	var scene: PackedScene
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	## number of attempts to try to spawn enemies at spawn chance
	var max_attempts: int = -1
	var ready: bool = false
	func _init(new_name: String, new_scene: PackedScene, new_spawn_chance: float, new_max_attempts: int) -> void:
		name = new_name
		scene = new_scene
		spawn_chance = new_spawn_chance
		max_attempts = new_max_attempts
		ready = true
	## returns if enemy can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		return true
## Contains data for the data to consider each time enemies are spawned
class EnemyEventSpawn: ## TODO: add in functionality to enemy spawn in a line across the screen? just make a scene with that tbh
	var name: String = "default"
	var scene: PackedScene
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	var spawn_once: bool = false
	## Max number of spawns at one time
	var max_spawns: int = 1
	var curr_spawns: int = 0
	var ready: bool = false
	func _init(new_name: String, new_scene: PackedScene, new_spawn_chance: float, new_spawn_once: bool, new_max_spawns: int) -> void:
		name = new_name
		scene = new_scene
		spawn_chance = new_spawn_chance
		spawn_once = new_spawn_once
		max_spawns = new_max_spawns
		ready = true
	## returns if enemy can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		if curr_spawns > 0 && spawn_once:
			return false
		return curr_spawns < max_spawns
## Contains data for a boss to spawn, determines when it will spawn/what makes it spawn
class BossSpawn:
	var name: String = "default"
	var scene: PackedScene
	## Number of times it can spawn max, per instance
	var max_spawns: int 
	var kills_per_spawn: int ## Number of enemy kills needed before spawning
	var time_per_spawn: float ## Amount of time needed between each spawn
	var spawn_once_on_start: bool ## If it will spawn once automatically 
	var enemies_killed: int
	var time_elapsed: float
	var ready: bool = false
	func _init(new_enemies_killed: int, new_time_elapsed: float, new_name: String, new_scene: PackedScene, new_spawn_once_on_start: bool, new_kills_per_spawn: int, new_time_per_spawn: float) -> void:
		enemies_killed = new_enemies_killed
		time_elapsed = new_time_elapsed
		name = new_name
		scene = new_scene
		kills_per_spawn = new_kills_per_spawn
		time_per_spawn = new_time_per_spawn
		spawn_once_on_start = new_spawn_once_on_start
		ready = true
	func get_spawns(new_enemies_killed: int, new_time_elapsed: float) -> int:
		var ret: int = 0
		if kills_per_spawn > 0 && new_enemies_killed - enemies_killed >= kills_per_spawn:
			ret += 1
			enemies_killed += kills_per_spawn
		if time_per_spawn > 0 && new_time_elapsed - time_elapsed >= time_per_spawn:
			ret += 1
			time_elapsed += time_per_spawn
		return ret
	## returns if boss can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		return true
## Contains data for the data to consider each time events are spawned
class EventSpawn:
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
	func _init(new_name: String, new_scene: PackedScene, new_spawn_chance: float, new_max_spawns: int, new_max_per_tile: int) -> void:
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
class SpawningPhase:
	var name: String = "default"
	var started: bool = false ## Has this phase started
	var completed: bool = false ## Has this phased completed
	var initial_time: float ## Time that the phase started
	var duration: float ## Time that the phase lasts
	var start_method: Callable ## Method to setup the phase
	func _init(new_name: String, new_duration: float, new_start_method: Callable):
		name = new_name
		duration = new_duration
		start_method = new_start_method
	func should_start_or_continue(time: float):
		if completed:
			return false
		if !started:
			started = true
			start_method.call()
			initial_time = time
			return true
		if (time - initial_time) > duration:
			completed = true
			return false
		return true
