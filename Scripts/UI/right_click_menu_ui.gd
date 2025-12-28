extends Control

@export var feed: Button
@export var sell: Button

## Connects methods to buttons
func setup(item: ItemUI, show_feed: bool, show_sell: bool, feed_method: Callable, sell_method: Callable):
	if show_feed:
		feed.pressed.connect(feed_method.bind(item))
		feed.pressed.connect(kill)
	else:
		feed.visible = false
	if show_sell:
		sell.pressed.connect(sell_method)
		sell.pressed.connect(kill)
		sell.text = "Sell: $" + str(item.data.get_cost(true))
	else:
		sell.visible = false

func kill():
	if is_instance_valid(self):
		queue_free()
