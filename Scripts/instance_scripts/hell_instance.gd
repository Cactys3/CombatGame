extends GameInstance

## Hell

## Images
const TILE1 = preload("uid://lxfss4n84nxu")

## Enemies
const FLUUE = preload("uid://d1v8l8ulmvpo")
const JARRE = preload("uid://b1me3l65aoeu1")
const KLE = preload("uid://i0ead3kcc77p")
const SCLARNK = preload("uid://bpx8cildenn6g")
## Bosses

## Events
const ROCKS = preload("uid://cmcbroiw30fy8")


func _ready() -> void:
	win_time = 60*20
	spawning_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new(0, 45, phase_one))
	phases.append(SpawningPhase.new(45, 60, phase_two))
	phases.append(SpawningPhase.new(60+45, 20, phase_two))
	events.append(EventSpawn.new("Rocks", ROCKS, 0.1, -1, 4))
func _process(delta: float) -> void:
	super(delta)
## Overrides
func add_tiles():
	TILES.append(TILE1) 
func handle_stopwatch(delta: float):
	super(delta)
func phase_one():
	print("PHASE 1")
	spawning_phase = 1
	enemies.clear()
	enemies.append(EnemySpawn.new("KLE", KLE, 0.3, 3))
func phase_two():
	print("PHASE 2")
	spawning_phase = 2
	enemies.clear()
	enemies.append(EnemySpawn.new("KLE", KLE, 0.6, 6))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0, 1))
func phase_three():
	print("PHASE 3")
	spawning_phase = 3
	enemies.clear()
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.1, 3))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.5, 5))
func phase_four():
	print("PHASE 4")
	spawning_phase = 4
	enemies.clear()
	enemies.append(EnemySpawn.new("SCLARNK", SCLARNK, 0.3, 2))
	enemies.append(EnemySpawn.new("FLUUE", FLUUE, 0.4, 3))
	enemies.append(EnemySpawn.new("JARRE", JARRE, 0.3, 3))
func phase_five():
	pass
