extends Attachment

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func create_projectiles():
	#unique mechanic: spawn projectile ontop of enemy
	var enemy = frame.get_nearest_enemy()
	#print(enemy)
	if enemy != null:
		var enemypos = enemy.global_position
		# Create the first bullet by default
		init_projectile(enemypos, Vector2(cos(frame.rotation), sin(frame.rotation)))
		# Create any extra bullets using @export values to offset them by angle and position
		var offset: int = 0
		for i:int in frame.get_stat(StatsResource.COUNT) - 1:
			if i % 2 == 0:
				offset += 1
			MultipleProjectileOffset *= -1
			MultipleProjectileAngleOffset *= -1
			init_projectile(enemypos + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (offset), Vector2(cos(frame.rotation), sin(frame.rotation)))

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = []
	arr.append(get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 1.2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 0.3), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.ATTACKSPEED, randf_range(-0.5, 0.3), 0.01, 0)
	return newstats
