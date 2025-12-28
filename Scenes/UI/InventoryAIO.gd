extends Inventory

const RIGHTCLICKMENU = preload("uid://cgxs2sfst46t4")
static var right_clicking_item: ItemUI = null
static var right_click_menu: Control = null

@export var side_panel: Control 
@export var feed_panel: Control 

func _ready() -> void:
	super()
	show_side()

func _process(delta: float) -> void:
	super(delta)

func RightClick(item: ItemUI, pos: Vector2) -> Control:
	clear_right_click()
	if item.data.can_sell || item.data.can_feed:
		var ret: Control = RIGHTCLICKMENU.instantiate()
		ret.setup(item, item.data.can_feed, item.data.can_sell, feed_method, sell_method)
		item.add_child(ret)
		ret.global_position = pos
		right_clicking_item = item
		right_click_menu = ret
		return ret
	return null

func feed_method(item: ItemUI):
	if show_feed():
		feed_panel.setup(self, item)
	clear_right_click()

func show_feed() -> bool:
	if side_panel && feed_panel:
		side_panel.visible = false
		feed_panel.visible = true
		return true
	return false

func show_side() -> bool:
	if side_panel && feed_panel:
		side_panel.visible = true
		feed_panel.visible = false
		return true
	return false

func sell_method():
	GameManager.instance.sell_item(right_clicking_item.data)
	right_clicking_item.free_draggable_ui()
	clear_right_click()

func clear_right_click():
	if right_clicking_item:
		right_clicking_item.right_clicking = false
		right_clicking_item = null
	if right_click_menu:
		right_click_menu.kill()
		right_click_menu = null
