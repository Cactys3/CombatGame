extends Inventory

@export var ItemParent: Control
@export var WeaponParent: Control

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
	print("add")
	if check_item(item):
		_add_item(item)
		return true
	print("add false")
	return false

## Item requested to be moved into this inventory
func move(item: ItemUI) -> bool:
	print("move: " + str(check_item(item)))
	if check_item(item) && item.inventory.remove(item):
		_add_item(item)
		return true
	return false

func _add_item(item: ItemUI) -> void:
	match(item.data.item_type):
		ItemData.WEAPON:
			GameManager.instance.add_item_to_player(item.item)
			item.inventory = self
			item.item_parent = WeaponParent
			item.position = Vector2.ZERO
			WeaponParent.add_child(item)
			WeaponParent.queue_sort()
			items.append(item) #TODO: seperate weapon list from item list ? 
		ItemData.ITEM:
			GameManager.instance.add_item_to_player(item.item)
			item.inventory = self
			item.item_parent = ItemParent
			item.position = Vector2.ZERO
			ItemParent.add_child(item)
			ItemParent.queue_sort()
			items.append(item) #TODO: seperate weapon list from item list ? 

## Weapon crafting popout
# handled by weapon frame?

## Check is not null and is an ITEM or complete WEAPON (not component)
func check_item(item: ItemUI) -> bool:
	print("check: " + str(super(item)) + str((item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)) + str(item))
	return super(item) && (item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
