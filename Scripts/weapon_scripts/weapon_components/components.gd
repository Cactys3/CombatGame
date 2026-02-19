extends Area2D
class_name Components
@export var stats: StatsResource
var data: ItemData = ShopManager.BLANK_ITEMDATA.duplicate()
const RIGHTCLICKMENU = preload("uid://cgxs2sfst46t4")


func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.05).timeout
	visible = true

## Functions to Override:
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	arr.append(get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 3), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = StatsResource.BLANK_STATS.duplicate()
	newstats.setup(itemdata.item_name + " Rolls")
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.5), 0.01, 0)
	return newstats
static func set_stat_randomize(stats: StatsResource, stat: String, roll: float, chance_to_double: float, chance_to_not_add: float) -> StatsResource:
	if randf() < chance_to_double:
		roll = roll * 2
	elif randf() < chance_to_not_add:
		return stats
	stats.set_stat_base(stat, roll)
	return stats
## Return a Stat upgrade value based on level/rarity
static func get_stat_upgrade(stat: String, roll: float, level: float, rarity: ItemData.item_rarities, chance_to_be_double: float, chance_to_be_zero: float) -> ItemData.LevelUpgrade:
	if randf() < chance_to_be_double:
		roll = roll * 2
	elif randf() < chance_to_be_zero:
		roll = 0
	var level_multiplier: float = StatsResource.calculate_stat_upgrade_level_multiplier(level)
	var rarity_multiplier: float = ItemData.calculate_stat_upgrade_rarity_multiplier(rarity)
	var upgrade: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	upgrade.setup(stat, rarity, false, roll * rarity_multiplier * level_multiplier)
	return upgrade
## Applies Stats into everything that uses it, eg: animation speed
func apply_stats():
	pass
## Returns StatsObject
func get_stats() -> StatsResource:
	return stats
## Returns ItemData
func get_data() -> ItemData:
	return data
## Sets up a RightClickMenu for this component
func setup_right_click_menu(menu: RightClickMenu):
	menu.set_bools(data.can_feed, data.can_sell, true, false)


# copy and paste fodder
### Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
#static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	#var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	#arr.append(get_stat_upgrade(StatsResource.DURATION, randf_range(1, 1), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	#return arr
### Returns a randomized stat object, using the given itemdata's variables like rarity
#static func randomize_stats(itemdata: ItemData) -> StatsResource:
	#var newstats: StatsResource = super(itemdata)
	#set_stat_randomize(newstats, StatsResource.DURATION, randf_range(-1, 1), 0.01, 0)
	#return newstats
