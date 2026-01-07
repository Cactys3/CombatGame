extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/sword/sword_handle.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	for item in arr:
		if item.name == StatsResource.RANGE:
			item.value -= 5
	for item in arr:
		if item.name == StatsResource.DAMAGE:
			item.value += 0.6
	arr.append(get_stat_upgrade(StatsResource.INACCURACY, randf_range(-3, -1), itemdata.level, get_weighted_rarity(itemdata.level), 0, 0.1))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.5), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.RANGE, randf_range(-5, 19), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.INACCURACY, randf_range(-2, -1), 0.01, 0)
	return newstats
