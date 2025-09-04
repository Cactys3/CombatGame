extends Inventory

## AutoRestock when items are removed
@export var auto_restock: bool = false
@export var delete_on_sell: bool = true
@export var num_of_items: int = 3
@export var drop_visual: Panel
@export var drop_text: Label
var showing_drop: bool = false

func _ready() -> void:
	drop_visual.visible = false
	super()

func _process(delta: float) -> void:
	super(delta)
	handle_drop_visual()

func handle_drop_visual():
	if !showing_drop && !toggle_button.hide_ui && ItemUI.dragging_some_item:
		showing_drop = true
		if !ItemUI.dragging_item.inventory == self:
			drop_text.text = "Drop to Sell: $" + str(ItemUI.dragging_item.data.item_buy_cost * ItemUI.dragging_item.data.item_sell_cost_modifier)
		else:
			drop_text.text = "Take to Buy: $" + str(ItemUI.dragging_item.data.item_buy_cost)
		drop_visual.visible = true
	
	if showing_drop && (!ItemUI.dragging_some_item || toggle_button.hide_ui):
		showing_drop = false
		drop_visual.visible = false

func reroll() -> bool:
	clear()
	for i in range(num_of_items):
		var item = (ShopManager.make_itemUI(ShopManager.get_rand_equipment()))
		
		new_add(item)
	return true

func stock(count: int) -> bool:
	for i in range(count):
		var item = (ShopManager.make_itemUI(ShopManager.get_rand_equipment()))
		
		new_add(item)
	return true

## Override
func get_type() -> String:
	print("get type: shop")
	return SHOP

func can_add(item: ItemUI) -> bool:
	print("can_add_shop")
	return is_valid_type(item)

func can_remove(item: ItemUI) -> bool:
	print("can_remove_shop")
	return is_instance_valid(item) && items.has(item) && GameManager.instance.can_buy(item.data.item_buy_cost)
