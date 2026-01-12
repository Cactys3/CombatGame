extends Control
class_name RightClickMenu
@export var feed: Button
@export var sell: Button
@export var forge: Button
@export var dismantle: Button


## Connects methods to buttons
func set_bools(show_feed: bool, show_sell: bool, show_forge: bool, show_dismantle: bool):
	feed.visible = show_feed
	sell.visible = show_sell
	forge.visible = show_forge
	dismantle.visible = show_dismantle

func set_methods(item: ItemUI, feed_method: Callable, sell_method: Callable, forge_method: Callable, dismantle_method: Callable):
	feed.pressed.connect(kill)
	sell.pressed.connect(kill)
	forge.pressed.connect(kill)
	dismantle.pressed.connect(kill)
	sell.pressed.connect(sell_method)
	feed.pressed.connect(feed_method)
	forge.pressed.connect(forge_method)
	dismantle.pressed.connect(dismantle_method)
	sell.text = "Sell: $" + str(item.data.get_cost(true))

func showing_something() -> bool:
	return feed.visible || sell.visible

func kill():
	if is_instance_valid(self):
		queue_free()
