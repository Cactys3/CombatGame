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
const CLARN = preload("uid://d08kal5b45b0x")
## Enemy Events
const KLE_CLUSTER = preload("uid://cpbkathjul2cc")
## Bosses
const SHLARNGUH = preload("uid://cxv2mja6rt14")
## Events
const ROCKS = preload("uid://cmcbroiw30fy8")
const PUDDLE = preload("uid://dxv17gll2bx2l")
const SPIKES = preload("uid://bj2nfedstjwtm")
const BALL = preload("uid://dyk1bgwdqiq2d")
const LOOTCHEST = preload("uid://ceycsndkpdg1t")

func _ready() -> void:
	super()
	default_min_enemies = 30
	default_max_enemies = 90
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
	win_time = 60*20
	enemy_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new("Easy Start", 60, phase_one)) # wave 1, small guys, allows you to setup
	phases.append(SpawningPhase.new("Introduce Clarn", 60, phase_two)) # wave 2, same as 1 + big guys
	phases.append(SpawningPhase.new("Swarm!", 60, phase_three)) # big swap, everything new
	phases.append(SpawningPhase.new("Everyone!", 60, phase_four)) # gatekeeper of this level, big swarm of enemies
	phases.append(SpawningPhase.new("Change it up!", 60, phase_five)) # harder?
	phases.append(SpawningPhase.new("Now with Bugs!", 60, phase_six)) # 
	phases.append(SpawningPhase.new("Big and Small!", 60, phase_seven)) # 
	phases.append(SpawningPhase.new("Clarn is back!", 60, phase_eight)) # 
	phases.append(SpawningPhase.new("They are so cute!", 60, phase_nine)) # 
	phases.append(SpawningPhase.new("Boss time.", 60, phase_twenty)) # spawn the final boss
	## Does Nothing
	events.append(EventSpawn.new("Rocks", ROCKS, 0.25, -1, 1))
	events.append(EventSpawn.new("Spikes", SPIKES, 0.25, -1, 1))
	events.append(EventSpawn.new("Puddle", PUDDLE, 0.25, -1, 1))
	events.append(EventSpawn.new("Ball", BALL, 0.25, -1, 1))
	## Proximity
	#events.append(EventSpawn.new("Shop", SHOP, 0.15, -1, 1))
	#events.append(EventSpawn.new("Forge", FORGE, 0.20, -1, 1))
	## Interactable
	events.append(EventSpawn.new("LootChest", LOOTCHEST, 0.3, -1, 3))
	events.append(EventSpawn.new("StatScroll", STAT_SCROLL, 0.1, -1, 1))
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
func generic_phase_setup_dont_clear(phase_num: int):
	spawning_phase = phase_num
func phase_one():
	print("PHASE 1 - Easy Start")
	generic_phase_setup(1)
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.2, 1))
func phase_two():
	print("PHASE 2 - Introduce Big Guy")
	generic_phase_setup(2)
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.4, 1))
	enemies.append(EnemySpawn.new("CLARN", CLARN, 0.2, 1))
func phase_three():
	print("PHASE 3 - Swarm")
	generic_phase_setup(3)
	max_enemies += 15
	min_enemies += 15
	enemies.append(EnemySpawn.new("KLE", KLE, 0.4, 5))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.1, false, 1))
func phase_four():
	print("PHASE 4 - Everyone!")
	generic_phase_setup(4)
	enemies.append(EnemySpawn.new("KLE", KLE, 0.1, 1))
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.2, 1))
	enemies.append(EnemySpawn.new("CLARN", CLARN, 0.2, 1))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.1, false, 1))
func phase_five():
	print("PHASE 5 - Change it up!")
	generic_phase_setup(5)
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.05, 1))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.5, 1))
func phase_six():
	print("PHASE 6 - Now with Bugs!")
	generic_phase_setup(6)
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.4, 1))
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.05, 1))
func phase_seven():
	print("PHASE 7 - Big and Small!")
	generic_phase_setup(7)
	enemies.append(EnemySpawn.new("KLE", KLE, 0.5, 1))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.2, 1))
	enemy_events.append(EnemyEventSpawn.new("KLE_CLUSTER", KLE_CLUSTER, 0.1, false, 1))
func phase_eight():
	print("PHASE 8 - Clarn is back!")
	generic_phase_setup(8)
	enemies.append(EnemySpawn.new("CLARN", CLARN, 0.5, 2))
func phase_nine():
	print("PHASE 9 - They're so cute!")
	generic_phase_setup(9)
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.3, 1))
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 1))
func phase_ten():
	print("PHASE 01 - !")
	generic_phase_setup(10)
	
func phase_eleven():
	print("PHASE 11 - !")
	generic_phase_setup(11)
	
func phase_twenty():
	generic_phase_setup(20)
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.2, 1))
	## Spawn boss that will end the game once killed
	spawn_final_boss(SHLARNGUH, random_position(character.position))
