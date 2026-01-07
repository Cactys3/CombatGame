extends Projectile

func _process(delta: float) -> void:
	super(delta)

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.PIERCING, 0, 0.01, 0)
	return newstats
