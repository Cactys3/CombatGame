extends Attachment

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Initializes and returns one projectile in the style of this attachment
func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	## Lightingwand change: spawn ontop of enemy 
	var enemy = frame.get_nearest_enemy()
	if enemy:
		return super(enemy.global_position + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized(), new_direction)
	else:
		return super(new_position, new_direction)

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
