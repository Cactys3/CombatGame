extends CircleActivator
class_name StatScrollEvent
const BLANK_STATS = preload("uid://djwbly6iawrk")
const STAT_SCROLL_EVENT_UI = preload("uid://bqxl1c0t7c6ac")
var stats: StatsResource = BLANK_STATS

## Calculate and assign a rarity
func setup(new_level: int):
	print("setup: " + str(new_level))
	stats.setup("Damage+ Scroll")
	stats.set_stat_base(StatsResource.DAMAGE, new_level)
	## Make a rarity based on level TODO: stat scroll
	## set the animation_speed based on that rarity
	## Get a random stat from list of KEY/MAJOR stats
	## Set that base stat bbased on rarity + stat
	## Get a chance to add a second stat, repeat the process if true
	## Get a chance to add a negative stat
## Override done() to show accept/deny stat anvil UI
func done():
	is_done = true
	if anim.speed_scale > 0:
		await stat_scroll_function()
		is_done = true
		queue_free()
func stat_scroll_function():
	var ui: Control = STAT_SCROLL_EVENT_UI.instantiate()
	GameManager.instance.ui_man.misc_parent.add_child(ui)
	GameManager.instance.ui_man.pause_proximity(true)
	ui.global_position = Vector2(500, 100)
	ui.setup(stats)
	print("pause")
	await ui.decision_made
	print("unpause")
	GameManager.instance.ui_man.pause_proximity(false)
	if ui.decision:
		print("adeed stats")
		GameManager.instance.global_stats.add_stats(stats)
