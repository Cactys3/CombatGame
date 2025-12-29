extends Area2D
class_name Components
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	## This gets a random stat and adds 15-30
	var arr: Array[ItemData.LevelUpgrade]
	var u1: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	u1.setup(StatsResource.get_rand_stat(), false, randf_range(15, 30))
	arr.append(u1)
	return arr

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var stats: StatsResource = StatsResource.new()
	stats.set_stat_base(StatsResource.DAMAGE, randi_range(0, 20))
	stats.set_stat_base(StatsResource.RANGE, randi_range(0, 20))
	stats.set_stat_base(StatsResource.SIZE, randf())
	stats.set_stat_base(StatsResource.VELOCITY, randf_range(0, 20))
	stats.parent_object_name = "RNGrolls"
	return stats
