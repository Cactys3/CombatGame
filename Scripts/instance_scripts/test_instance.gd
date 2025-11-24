extends GameInstance

## Test map that includes random enemies I've made for testing

## Images
const Test1 = preload("uid://w8o0ryem7012")
const Tile1 = preload("uid://dvumjquc3ofs4")
## Enemies
const FLUB = preload("uid://ckhl8l6bj1bvv")
const GRUB = preload("uid://dojorw4mt1dsw")
const JUB = preload("uid://b4ljdiupnggrv")
const THUB = preload("uid://drjvl1sgqrjuy")
## Bosses
const TESTBOSS = preload("uid://davhmwwacx2xv")
## Proximity Events

func _process(delta: float) -> void:
	super(delta)

## Overrides

## Gets random tile for map
func get_rand_tile() -> Texture2D:
	return Tile1
## Called each frame
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
## Adds all events for this map to events - Override
func setup_events(): 
	super()
