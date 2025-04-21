extends Inventory

## AutoRestock when items are removed
@export var auto_restock: bool = false
@export var delete_on_sell: bool = true

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
	return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.ITEM)

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
			item.queue_free()
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
			var new_item: ItemUI = ItemUI.new()
			new_item.set_item(ShopManager.get_rand_weapon())
			_add_item(new_item)
		return true
	return false
