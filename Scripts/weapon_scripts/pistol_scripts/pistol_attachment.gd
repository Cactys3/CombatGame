extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Should handle creating a projectile, shooting it, and reseting cooldown
func attack(): 
	await create_projectiles()
	# Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false

## Reload Mechanic: Fires COUNT rounds (in ~1.5 second) before reloading for x / DURATION seconds
func create_projectiles():
	var count: float = frame.get_stat(StatsResource.COUNT)
	var total_time: float = 1.5
	var time_inbetween_projectiles: float = total_time / count
	var stopwatch: Timer = Timer.new()
	add_child(stopwatch)
	stopwatch.wait_time = time_inbetween_projectiles
	var inaccuracy: float =  stats.get_stat(StatsResource.INACCURACY) 
	var direction = Vector2(cos(frame.rotation), sin(frame.rotation)).rotated(deg_to_rad(randf_range(-inaccuracy, inaccuracy)))
	init_projectile(global_position, direction)
	print("First projectile")
	var proj_offset: int = 0
	for i:int in count - 1:
		stopwatch.start()
		await stopwatch.timeout
		if i % 2 == 0:
			proj_offset += 1
		## Projectile Offsets are set to 0 for pistol attachment (in @export)
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		print(str(i) + "'th projectile")
		init_projectile(global_position + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (proj_offset), Vector2(cos(frame.rotation), sin(frame.rotation)))
	stopwatch.queue_free()


static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.COUNT, randf_range(0.5, 3), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.COUNT, randf_range(-0.9, 5), 0.01, 0)
	return newstats
