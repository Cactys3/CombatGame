extends Handle

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Remove Checking Enemy Nearby
func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	var temp_count: float = weapon_count
	if (temp_count < 4):
		temp_count = 4
	frame.global_position = GetOrbitPosition((TAU * (weapon_slot / temp_count)))
	ready_to_fire = true

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	for item in arr:
		if item.name == StatsResource.RANGE:
			item.value += get_stat_upgrade(StatsResource.RANGE, randf_range(4, 9), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.35).value
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	## Add more range onto the default
	set_stat_randomize(newstats, StatsResource.RANGE, randf_range(1, 8), 0.01, 0)
	return newstats
