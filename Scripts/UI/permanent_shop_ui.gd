extends Control
const SHOP_OPTION = preload("uid://b7qlnftpauy23")
@export var stats_display: StatsDisplay
@export var weapon_parent: VBoxContainer
@export var item_parent: VBoxContainer
@export var component_parent: VBoxContainer
@export var forge_parent: Control
var method: Callable
func setup(new_method: Callable):
	method = new_method
## Instantiate a shop option for the given data
func add_option(data: ItemData):
	var option = SHOP_OPTION.instantiate()
	if data.is_component():
		component_parent.add_child(option)
	elif data.item_type == ItemData.item_types.weapon:
		weapon_parent.add_child(option)
	elif data.item_type == ItemData.item_types.item:
		if data.get_item().is_forge():
			forge_parent.add_child(option)
			## Make Free
			data.item_buy_cost = 0
		else:
			item_parent.add_child(option)
	else:
		printerr("adding wrong thing to permanent shop")
		return
	option.setup(data, method, set_stat)
func set_stat(data: ItemData):
	if data.has_stats:
		var stats = data.stats
		stats_display.setup_substats(stats, stats.parent_object_name)
		stats_display.only_show_changed = true
