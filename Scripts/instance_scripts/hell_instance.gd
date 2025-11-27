extends GameInstance

## Hell

## Images

## Enemies
const FLUUE = preload("uid://d1v8l8ulmvpo")
const JARRE = preload("uid://b1me3l65aoeu1")
const KLE = preload("uid://i0ead3kcc77p")
const SCLARNK = preload("uid://bpx8cildenn6g")
## Bosses

## Proximity Events

func _ready() -> void:
	win_time = 60
	spawning_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
func _process(delta: float) -> void:
	super(delta)
## Overrides
func get_rand_tile() -> Texture2D:
	return TileBlank
func handle_stopwatch(delta: float):
	super(delta)
func phase_one():
	print("PHASE 1")
	spawning_phase = 1
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", KLE, 0.3, 3))
func phase_two():
	print("PHASE 2")
	spawning_phase = 2
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", KLE, 0.6, 6))
	enemies.append(EnemySpawn.new("flub", JARRE, 0, 1))
func phase_three():
	print("PHASE 3")
	spawning_phase = 3
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", SCLARNK, 0.1, 3))
	enemies.append(EnemySpawn.new("flub", FLUUE, 0.6, 3))
func phase_four():
	print("PHASE 4")
	spawning_phase = 4
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", SCLARNK, 0.1, 3))
	enemies.append(EnemySpawn.new("flub", FLUUE, 0.6, 3))
func phase_five():
	pass
