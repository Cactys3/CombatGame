extends Handle

## Shoots projectile that then returns to sender

## TODO: return to sender

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.DURATION, randf_range(0.5, 2.2), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DURATION, randf_range(-1, 4), 0.01, 0)
	return newstats
