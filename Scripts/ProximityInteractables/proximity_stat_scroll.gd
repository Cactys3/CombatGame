extends CircleActivator
class_name StatScrollEvent
const BLANK_STATS = preload("uid://djwbly6iawrk")
const STAT_SCROLL_EVENT_UI = preload("uid://bqxl1c0t7c6ac")
var stats: StatsResource = BLANK_STATS
var is_setup: bool = false
var ui: Control
## Calculate and assign a rarity
func setup(new_time: int, new_level: int):
	stats.setup("Damage+ Scroll")
	stats.set_stat_base(StatsResource.DAMAGE, new_level)
	is_setup = true
	## Make a rarity based on level TODO: stat scroll
	## set the animation_speed based on that rarity
	## Get a random stat from list of KEY/MAJOR stats
	## Set that base stat bbased on rarity + stat
	## Get a chance to add a second stat, repeat the process if true
	## Get a chance to add a negative stat
## Override done() to show accept/deny stat anvil UI
func done():
	if !is_setup:
		## Backup setup for when set on basescene in editor
		setup(1, 1)
	is_done = true
	if anim.speed_scale > 0:
		await stat_scroll_function()
		is_done = true
		queue_free()
func stat_scroll_function():
	ui = STAT_SCROLL_EVENT_UI.instantiate()
	var ui_man = GameManager.instance.ui_man
	ui_man.misc_parent.add_child(ui)
	var pause: UIManager.PauseItem
	pause = UIManager.PauseItem.new(Callable(), UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.misc_parent)
	ui_man.pause(pause)
	ui.global_position = Vector2(500, 100)
	ui.setup(stats)
	await ui.decision_made
	print("awaited!")
	## TODO: Unpause, can this cause issues? what if something else is higher priority, we would just unpause that instead of the scroll pause..
	ui_man.unpause(pause)
	if ui.decision:
		GameManager.instance.global_stats.add_stats(stats)
	delete_scroll()
func delete_scroll():
	if ui:
		ui.queue_free()
		ui = null
	queue_free()
