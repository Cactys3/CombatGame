extends Area2D
class_name Components
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	arr.append(get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 3), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = StatsResource.new()
	print(itemdata.item_name + ".Damage: " + str(newstats.get_stat_base(StatsResource.DAMAGE)))
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.5), 0.01, 0)
	newstats.parent_object_name = "RNGrolls"
	print("Damage: " + str(newstats.get_stat_base(StatsResource.DAMAGE)))
	return newstats
## Returns a random rarity based on weights
static func get_weighted_rarity(level: float) -> ItemData.item_rarities:
	## TODO: these weights are fine? they are semi-random
	var roll: float = randf_range(0, 0.73)
	var ret: ItemData.item_rarities = ItemData.item_rarities.common
	if roll < 0.25:
		ret = ItemData.item_rarities.common
	elif roll < 0.4375:
		ret = ItemData.item_rarities.rare
	elif roll < 0.578125:
		ret = ItemData.item_rarities.epic
	elif roll < 0.653125:
		ret = ItemData.item_rarities.legendary
	elif roll < 0.693125:
		ret = ItemData.item_rarities.exclusive
	return ret
static func set_stat_randomize(stats: StatsResource, stat: String, roll: float, chance_to_double: float, chance_to_not_add: float) -> StatsResource:
	if randf() < chance_to_double:
		roll = roll * 2
	elif randf() < chance_to_not_add:
		return stats
	stats.set_stat_base(stat, roll)
	return stats
## Return a Stat upgrade value based on level/rarity
static func get_stat_upgrade(stat: String, roll: float, level: float, rarity: float, chance_to_be_double: float, chance_to_be_zero: float) -> ItemData.LevelUpgrade:
	if randf() < chance_to_be_double:
		roll = roll * 2
	elif randf() < chance_to_be_zero:
		roll = 0
	var level_multiplier: float = (1 + (level / 10))
	var rarity_multiplier: float = (1 + (float(rarity) / 3))
	var upgrade_rarity: ItemData.item_rarities = get_weighted_rarity(level)
	var upgrade: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	upgrade.setup(stat, upgrade_rarity, false, roll * rarity_multiplier * level_multiplier)
	return upgrade
## Applies Stats into everything that uses it, eg: animation speed
func apply_stats():
	pass
func get_stats():
	return null
