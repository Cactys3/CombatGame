extends Area2D
class_name Components
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	var level: float = itemdata.level
	var level_multiplier: float = (1 + (level / 10))
	## First Upgrade
	var u1_rarity: ItemData.item_rarities = get_weighted_rarity(level)
	var u1: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	u1.setup(StatsResource.DAMAGE, u1_rarity, false, get_damage_upgrade(level, u1_rarity))
	arr.append(u1)
	return arr
## Return a damage upgrade value based on level/rarity, this is to keep things consistent amoungst weapons as damage is a universal stat
static func get_damage_upgrade(level: float, rarity: float) -> float:
	var level_multiplier: float = (1 + (level / 10))
	var rarity_multiplier: float = (1 + (float(rarity) / 3))
	return randf_range(2, 4) * rarity_multiplier * level_multiplier
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
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var stats: StatsResource = StatsResource.new()
	stats.set_stat_base(StatsResource.DAMAGE, randf_range(-1, 4))
	stats.parent_object_name = "RNGrolls"
	return stats
## Applies Stats into everything that uses it, eg: animation speed
func apply_stats():
	pass

func get_stats():
	return null
