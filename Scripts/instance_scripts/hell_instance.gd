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
## Bosses
const SHLARNGUH = preload("uid://cxv2mja6rt14")
## Events
const ROCKS = preload("uid://cmcbroiw30fy8")
const PUDDLE = preload("uid://dxv17gll2bx2l")
const SPIKES = preload("uid://bj2nfedstjwtm")
const BALL = preload("uid://dyk1bgwdqiq2d")

func _ready() -> void:
	win_time = 60*20
	spawning_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new("Easy Start", 10, phase_one)) # 0 -> 45
	phases.append(SpawningPhase.new("Introduce Big Guy", 10, phase_two)) # 45 -> 105
	phases.append(SpawningPhase.new("Change it up", 10, phase_three)) # 105 -> 125
	phases.append(SpawningPhase.new("Swarm!", 10, phase_four)) # 125 -> 135
	phases.append(SpawningPhase.new("Make it harder, everyone!", 10, phase_five)) # 135 -> 195
	phases.append(SpawningPhase.new("Boss time.", 10, phase_six)) # 135 -> 195
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
func phase_one():
	#print("PHASE 1 - Easy Start")
	spawning_phase = 1
	enemies.clear()
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 3))
func phase_two():
	#print("PHASE 2 - Introduce Big Guy")
	spawning_phase = 2
	enemies.clear()
	enemies.append(EnemySpawn.new("KLE", KLE, 0.6, 6))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.3, 1))
func phase_three():
	#print("PHASE 3 - Change it up")
	spawning_phase = 3
	enemies.clear()
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.1, 3))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.5, 5))
func phase_four():
	#print("PHASE 4 - Swarm!")
	spawning_phase = 4
	enemies.clear()
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 2))
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.4, 10))
func phase_five():
	#print("PHASE 5 - Make it harder, everyone!")
	spawning_phase = 5
	enemies.clear()
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.3, 2))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.4, 3))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.3, 3))
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 1))
	enemies.append(EnemySpawn.new("GUREL", GUREL, 0.4, 3))
func phase_six():
	#print("PHASE 6 - Boss Time")
	spawning_phase = 6
	enemies.clear()
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.25, 4))
	## Spawn boss that will end the game once killed
	spawn_final_boss(SHLARNGUH, random_position(character.position))
	
