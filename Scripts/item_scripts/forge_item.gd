extends Item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var stats: StatsResource = StatsResource.BLANK_STATS.duplicate()
	stats.setup("RNGrolls")
	stats.set_stat_base(StatsResource.DAMAGE, randi_range(0, 10))
	return stats
## Sets up a RightClickMenu for this component
func setup_right_click_menu(menu: RightClickMenu):
	menu.set_bools(false, false, true, false)
