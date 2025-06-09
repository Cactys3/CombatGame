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
	if !showing_drop && ItemUI.dragging_some_item:
		showing_drop = true
		if !ItemUI.dragging_item.inventory == self:
			drop_text.text = "Drop to Sell: $" + str(ItemUI.dragging_item.data.item_buy_cost * ItemUI.dragging_item.data.item_sell_cost_modifier)
		else:
			drop_text.text = "Take to Buy: $" + str(ItemUI.dragging_item.data.item_buy_cost)
		drop_visual.visible = true
	
	if showing_drop && !ItemUI.dragging_some_item:
		showing_drop = false
		drop_visual.visible = false

## Item is not null and item is a valid itemtype
func check_item(item: ItemUI) -> bool:
	return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.ITEM|| item.data.item_type == ItemData.WEAPON)

func drop(item: ItemUI) -> void:
	if item.inventory == self:
		# dropping item back to shop
		pass
	else:
		# ask game manager if they can sell item
			move(item)

## Item requested to be moved into this inventory
func move(item: ItemUI) -> bool:
	if check_item(item) && item.inventory.remove(item) && GameManager.instance.sell_item(item):
		if delete_on_sell:
			item.free_draggable_ui()
		else: 
			_add_item(item)
		return true
	return false

## Item requested to be moved away from this inventory
func remove(item: ItemUI) -> bool:
	if is_instance_valid(item) && items.has(item) && GameManager.instance.buy_item(item):
		item.get_parent().remove_child(item)
		items.erase(item)
		if auto_restock:
			add(ShopManager.make_itemUI(ShopManager.get_rand_item()))
		return true
	return false

func reroll() -> bool:
	clear()
	for i in range(num_of_items):
		var item = (ShopManager.make_itemUI(ShopManager.get_rand_item()))
		
		add(item)
	return true

func stock(count: int) -> bool:
	for i in range(count):
		var item = (ShopManager.make_itemUI(ShopManager.get_rand_item()))
		
		add(item)
	return true

## New Implementation

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
