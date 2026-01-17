extends Handle

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.BUILDUP, randf_range(0.4, 2), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.ATTACKSPEED, randf_range(-1.2, 1), 0.01, 0)
	return newstats
