extends Control
const SHOP_OPTION = preload("uid://b7qlnftpauy23")
@onready var stats_display: StatsDisplay = $PanelContainer/VBoxContainer/Top/StatsDisplay
@onready var option_parent: VBoxContainer = $PanelContainer/VBoxContainer/Bottom/OptionParent
@onready var max_purchases: Label = $PanelContainer/VBoxContainer/Top/MaxPurchases
var method: Callable
func setup(new_method: Callable, max_choices: int):
	method = new_method
	max_purchases.text = "Max Purchases: " + str(max_choices)
## Instantiate a shop option for the given data
func add_option(data: ItemData):
	var option = SHOP_OPTION.instantiate()
	option_parent.add_child(option)
	option.setup(data, method, set_stat)
func set_stat(stats: StatsResource):
	stats_display.set_stats(stats, stats.parent_object_name)
	stats_display.only_show_changed = true
