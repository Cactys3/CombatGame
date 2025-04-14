extends Inventory

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## ADD:
# can only 'add' items or weapons. not components, mods, ect.
# check if weapon or item
# check if space for weapon/item
# add and activate weapon
# add weapon and add weapon to player via game manager
# makes sure if we added a weapon, empty weapon_frame is still the first or last? or in right spot?

func add(item : ItemUI) -> bool:
	if check_item(item):
		match(item.data.item_type):
			ItemData.WEAPON:
				GameManager.instance.add_item_to_player(item.item)
				item.inventory = self
				item.grid = inventory_grid
				item.position = Vector2.ZERO
				inventory_grid.add_child(item)
				inventory_grid.queue_sort()
				items.append(item) #TODO: seperate weapon list from item list ? 
				return true
			ItemData.ITEM:
				GameManager.instance.add_item_to_player(item.item)
				item.inventory = self
				item.grid = inventory_grid
				item.position = Vector2.ZERO
				inventory_grid.add_child(item)
				inventory_grid.queue_sort()
				items.append(item) #TODO: seperate weapon list from item list ? 
				return true
	return false

## Weapon crafting popout
# handled by weapon frame?

## Check is not null and is an ITEM or complete WEAPON (not component)
func check_item(item: ItemUI) -> bool:
	return super(item) && (item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
