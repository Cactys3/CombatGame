extends GameInstance

## Test map that includes random enemies I've made for testing

## Images
const Test1 = preload("uid://w8o0ryem7012")
const TileGrass = preload("uid://dvumjquc3ofs4")
## Enemies
const GRUB = preload("uid://dojorw4mt1dsw")
const FLUB = preload("uid://ckhl8l6bj1bvv")
const JUB = preload("uid://b4ljdiupnggrv")
const THUB = preload("uid://drjvl1sgqrjuy")
## Bosses
const TESTBOSS = preload("uid://davhmwwacx2xv")
## Proximity Events
## Spawning Phases

func _ready() -> void:
	win_time = 60
	spawning_cooldown = 1000000
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new("phase 1", 20, phase_one))
	phases.append(SpawningPhase.new("phase 2", 20, phase_two))
	phases.append(SpawningPhase.new("phase 3", 20, phase_two))
func _process(delta: float) -> void:
	super(delta)
## Overrides
func add_tiles():
	TILES.append(TileGrass) 
func handle_stopwatch(delta: float):
	super(delta)
func phase_one():
	#print("PHASE 1")
	spawning_phase = 1
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", GRUB, 0.3, 3))
	enemies.append(EnemySpawn.new("flub", FLUB, 0.3, 3))
	enemies.append(EnemySpawn.new("jub", JUB, 0.3, 3))
	enemies.append(EnemySpawn.new("thub", THUB, 0.3, 3))
func phase_two():
	#print("PHASE 2")
	spawning_phase = 2
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", GRUB, 0.6, 6))
	enemies.append(EnemySpawn.new("flub", FLUB, 0, 1))
	enemies.append(EnemySpawn.new("jub", JUB, 0, 1))
	enemies.append(EnemySpawn.new("thub", THUB, .3, 1))
func phase_three():
	#print("PHASE 3")
	spawning_phase = 3
	enemies.clear()
	enemies.append(EnemySpawn.new("grub", GRUB, 0.1, 3))
	enemies.append(EnemySpawn.new("flub", FLUB, 0.6, 3))
	enemies.append(EnemySpawn.new("jub", JUB, 0.6, 2))
	enemies.append(EnemySpawn.new("thub", THUB, 0.4, 4))
func handle_enemy_spawning(delta: float, pos: Vector2):
	super(delta, pos)
func setup_events(): 
	super()
