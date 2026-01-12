extends Inventory
class_name MainInventory
const FORGE = preload("uid://bxdeumld7epke")
const RIGHTCLICKMENU = preload("uid://cgxs2sfst46t4")
static var right_clicking_item: ItemUI = null
static var right_click_menu: Control = null
var forge: Control = null
@export var side_panel: Control 
@export var feed_panel: FeedPanel 
@export var dismantle_panel: DismantlePanel
func _ready() -> void:
	super()
	show_side()
func _process(delta: float) -> void:
	super(delta)
## If valid, displays the RightClickMenu for the item
func RightClick(itemui: ItemUI, pos: Vector2) -> RightClickMenu:
	clear_right_click()
	var item = itemui.data.get_item()
	if item.has_method("setup_right_click_menu"):
		var menu: RightClickMenu = RIGHTCLICKMENU.instantiate()
		item.setup_right_click_menu(menu)
		menu.set_methods(itemui, feed_method, sell_method, forge_method, dismantle_method)
		itemui.add_child(menu)
		menu.global_position = pos
		right_clicking_item = itemui
		right_click_menu = menu
		return menu
	print("no method:")
	return null
## Right Click Methods
func feed_method():
	if show_feed():
		feed_panel.setup(self, right_clicking_item)
	clear_right_click()
func sell_method():
	GameManager.instance.sell_item(right_clicking_item.data)
	right_clicking_item.free_draggable_ui()
	clear_right_click()
func forge_method():
	if show_forge():
		forge = FORGE.instantiate()
		forge.die.connect(delete_forge)
		GameManager.instance.ui_man.tab_menu_parent.add_child(forge)
		forge.position = Vector2(1389.0, 289.0)
		forge.clear()
	clear_right_click()
func dismantle_method():
	if show_dismantle():
		dismantle_panel.setup(self, right_clicking_item)
	clear_right_click()
## Right Click Shows
func show_dismantle() -> bool:
	print("SHOW")
	if side_panel && feed_panel && dismantle_panel:
		side_panel.visible = false
		feed_panel.visible = false
		dismantle_panel.visible = true
		return true
	return false
func show_forge() -> bool:
	delete_forge()
	return true
func show_feed() -> bool:
	if side_panel && feed_panel && dismantle_panel:
		side_panel.visible = false
		feed_panel.visible = true
		dismantle_panel.visible = false
		return true
	return false
func show_side() -> bool:
	if side_panel && feed_panel && dismantle_panel:
		side_panel.visible = true
		feed_panel.visible = false
		dismantle_panel.visible = false
		return true
	return false
## Clears Right Click Menu
func clear_right_click():
	if right_clicking_item:
		right_clicking_item.right_clicking = false
		right_clicking_item = null
	if right_click_menu:
		right_click_menu.kill()
		right_click_menu = null

func delete_forge():
	if forge:
		forge.clear()
		forge.queue_free()
		forge = null
