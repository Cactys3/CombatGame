extends GameInstance

## Hell

## Images
const TILE1 = preload("uid://lxfss4n84nxu")
const TILE2 = preload("uid://b0a3oqmb2tg1w")
const TILE3 = preload("uid://d3nouxti5p02i")
const TILE4 = preload("uid://c3t4kda6cwqs8")
const TILE5 = preload("uid://dn7pcp5orn4l8")
## Enemies
const FLUUE = preload("uid://d1v8l8ulmvpo")
const JARRE = preload("uid://b1me3l65aoeu1")
const KLE = preload("uid://i0ead3kcc77p")
const SCLARNK = preload("uid://bpx8cildenn6g")
const GUREL = preload("uid://d3y8ffd1nwhp4")
## Enemy Events
const KLE_CLUSTER = preload("uid://cpbkathjul2cc")
## Bosses
const SHLARNGUH = preload("uid://cxv2mja6rt14")
## Events
const ROCKS = preload("uid://cmcbroiw30fy8")
const PUDDLE = preload("uid://dxv17gll2bx2l")
const SPIKES = preload("uid://bj2nfedstjwtm")
const BALL = preload("uid://dyk1bgwdqiq2d")

func _ready() -> void:
	default_min_enemies = 30
	default_max_enemies = 90
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
	win_time = 60*20
	spawning_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new("Easy Start", 50, phase_one)) # wave 1, small guys
	phases.append(SpawningPhase.new("Introduce Big Guy", 30, phase_two)) # wave 2, same as 1 + big guys
	phases.append(SpawningPhase.new("Change it up", 60, phase_three)) # big swap, everything new
	phases.append(SpawningPhase.new("Swarm!", 25, phase_four)) # gatekeeper of this level, big swarm of enemies
	phases.append(SpawningPhase.new("Make it harder, everyone!", 10, phase_five)) # harder?
	phases.append(SpawningPhase.new("Boss time.", 10, phase_six)) # spawn the final boss
	events.append(EventSpawn.new("Rocks", ROCKS, 0.25, -1, 1))
	events.append(EventSpawn.new("Spikes", SPIKES, 0.25, -1, 1))
	events.append(EventSpawn.new("Puddle", PUDDLE, 0.25, -1, 1))
	events.append(EventSpawn.new("Ball", BALL, 0.25, -1, 1))
func _process(delta: float) -> void:
	super(delta)
## Overrides
func add_tiles():
	TILES.append(TILE1) 
	TILES.append(TILE2) 
	TILES.append(TILE3) 
	TILES.append(TILE4) 
	TILES.append(TILE5) 
func handle_stopwatch(delta: float):
	super(delta)
func generic_phase_setup(phase_num: int):
	enemies.clear()
	enemy_events.clear()
	spawning_phase = phase_num
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
func phase_one():
	#print("PHASE 1 - Easy Start")
	generic_phase_setup(1)
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 3))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.1, false, 1))
func phase_two():
	#print("PHASE 2 - Introduce Big Guy")
	generic_phase_setup(2)
	enemies.append(EnemySpawn.new("KLE", KLE, 0.6, 6))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.3, 1))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.25, false, 4))
func phase_three():
	#print("PHASE 3 - Change it up")
	generic_phase_setup(3)
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.1, 3))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.5, 5))
func phase_four():
	#print("PHASE 4 - Swarm!")
	generic_phase_setup(4)
	min_enemies = default_min_enemies + 20
	max_enemies = default_max_enemies + 40 ## Swarming, so can spawn more enemies than usual
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 2))
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.4, 10))
func phase_five():
	#print("PHASE 5 - Make it harder, everyone!")
	generic_phase_setup(5)
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.3, 2))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.4, 3))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.3, 3))
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 1))
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.4, 3))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.25, false, 2))
func phase_six():
	#print("PHASE 6 - Boss Time")
	generic_phase_setup(6)
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.25, 4))
	## Spawn boss that will end the game once killed
	spawn_final_boss(SHLARNGUH, random_position(character.position))
	
