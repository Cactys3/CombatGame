extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_handle.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	## Remove Range
	for item in arr:
		if item.name == StatsResource.RANGE:
			arr.erase(item)
	arr.append(get_stat_upgrade(StatsResource.SIZE, randf_range(0.01, 0.4), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	newstats.set_stat_base(StatsResource.RANGE, 0)
	set_stat_randomize(newstats, StatsResource.SIZE, randf_range(-0.2, 0.4), 0.01, 0)
	return newstats
