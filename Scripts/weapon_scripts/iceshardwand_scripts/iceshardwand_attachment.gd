extends Attachment

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func attack():
	super()

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	## Don't do super(), adding in lesser values for AS/Dmg
	var arr: Array[ItemData.LevelUpgrade] = []
	arr.append(get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 1), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.35))
	arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 0.6), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.4))
	arr.append(get_stat_upgrade(StatsResource.DURATION, randf_range(0.4, 3), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	arr.append(get_stat_upgrade(StatsResource.PIERCING, randf_range(0.8, 4.2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	arr.append(get_stat_upgrade(StatsResource.SIZE, randf_range(0.3, 0.89), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.1))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DURATION, randf_range(-0.9, 4), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.PIERCING, randf_range(-0.8, 3), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.SIZE, randf_range(-0.5, 2), 0.01, 0)
	return newstats
