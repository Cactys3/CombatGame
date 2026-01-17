extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")

## Reload Mechanic: Fires COUNT rounds (in ~1.5 second) before reloading for x / DURATION seconds
func create_projectiles():
	var inaccuracy: float =  stats.get_stat(StatsResource.INACCURACY) 
	var direction = get_inaccurate_direction(Vector2(cos(frame.rotation), sin(frame.rotation)), inaccuracy)
	var proj: Projectile = init_projectile(global_position, direction)
	var count: float = frame.get_stat(StatsResource.COUNT)
	var total_time: float = 1.5
	var time_inbetween_projectiles: float = total_time / count
	if !proj.can_spawn_multiple:
		## Add 0.5 seconds between shots if projectile normally can't shoot multiple TODO: should probably just not allow making multiple but this might be funny?
		time_inbetween_projectiles += 0.5
	var stopwatch: Timer = Timer.new()
	add_child(stopwatch)
	stopwatch.wait_time = time_inbetween_projectiles
	var proj_offset: int = 0
	## SKIPS the check for multiple projectiles as we are shooting them one at a time still
	for i:int in count - 1:
		stopwatch.start()
		await stopwatch.timeout
		if i % 2 == 0:
			proj_offset += 1
		## Projectile Offsets are set to 0 for pistol attachment (in @export)
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		## Get Attachment Position (default projectile position)
		var projectile_position: Vector2 = global_position
		## Offset it by position + [1 unit to the Left of default position] * [Positive offset to keep it left, negative to make it right] * [magnitude offset]
		projectile_position += (Vector2(-sin(frame.rotation), cos(frame.rotation)) * MultipleProjectileOffset * proj_offset)
		## Get Direction offset by inaccuracy
		var projectile_direction: Vector2 = get_inaccurate_direction(Vector2(cos(frame.rotation), sin(frame.rotation)), inaccuracy)
		init_projectile(projectile_position, projectile_direction)
	stopwatch.queue_free()

static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.COUNT, randf_range(0.5, 3), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.COUNT, randf_range(-0.9, 5), 0.01, 0)
	return newstats
