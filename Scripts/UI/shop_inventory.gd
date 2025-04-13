extends Inventory

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

func check_item(item: ItemUI) -> bool:
	return is_instance_valid(item) # && item.data.item_type == "Attachment"

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
		item.set_inventory(self)
		items.append(item)
		return true
	#print("check: " + str(check_item(item)) + " rm: " + str(item.inventory.remove(item)))
	return false

## Item requested to be moved away from this inventory
func remove(item: ItemUI) -> bool:
	if is_instance_valid(item) && items.has(item) && GameManager.instance.buy_item(item):
		item.get_parent().remove_child(item)
		items.erase(item)
		return true
	return false
