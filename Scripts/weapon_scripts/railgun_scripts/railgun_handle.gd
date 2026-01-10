extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_handle.tscn")

##Static Slot and always points in one of the cardinal directions

## Always ready_to_fire
func ProcessAlwaysAtMouse(delta: float) -> void:
	super(delta)
	ready_to_fire = true

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.DURATION, randf_range(1, 5), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DURATION, randf_range(-1, 1), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.6, 1.8), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.RANGE, randf_range(-0.6, 15), 0.01, 0)
	return newstats
