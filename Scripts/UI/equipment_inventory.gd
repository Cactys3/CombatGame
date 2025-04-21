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
	#print("started add")
	if check_item(item):
		_add_item(item)
	return false

## Item requested to be moved away from this inventory
func remove(item: ItemUI) -> bool:
	if is_instance_valid(item) && items.has(item):
		match(item.data.item_type):
			ItemData.WEAPON:
				if GameManager.instance.remove_weapon_from_player(item.item):
					WeaponParent.remove_child(item)
					WeaponParent.queue_sort()
					items.erase(item) #TODO: seperate weapon list from item list ? 
					#print("remove weapon")
					return true
			ItemData.ITEM:
				if GameManager.instance.remove_item_from_player(item.item):
					ItemParent.remove_child(item)
					ItemParent.queue_sort()
					items.erase(item) #TODO: seperate weapon list from item list ? 
					#print("remove item")
					return true
	#print("childs: " + str(get_children()))
	return false

## Item requested to be moved into this inventory
func move(item: ItemUI) -> bool:
	#print("move: " + str(check_item(item)))
	if check_item(item) && item.inventory.remove(item):
		_add_item(item)
		return true
	return false

func _add_item(item: ItemUI) -> void:
	match(item.data.item_type):
		ItemData.WEAPON:
			if GameManager.instance.add_weapon_to_player(item.item):
				#print("added weapon!")
				_add_equipment_weapon(item)
		ItemData.ITEM:
			if GameManager.instance.add_item_to_player(item.item):
				#print("added item!")
				_add_equipment_item(item)

func _add_equipment_item(item: ItemUI) -> void:
	item.inventory = self
	item.item_parent = ItemParent
	item.position = Vector2.ZERO
	ItemParent.add_child(item)
	ItemParent.queue_sort()
	items.append(item) #TODO: seperate weapon list from item list ? 

func _add_equipment_weapon(item: ItemUI) -> void:
	item.inventory = self
	item.item_parent = WeaponParent
	item.position = Vector2.ZERO
	WeaponParent.add_child(item)
	WeaponParent.queue_sort()
	items.append(item) #TODO: seperate weapon list from item list ? 

## Weapon crafting popout
# handled by weapon frame?

## Check is not null and is an ITEM or complete WEAPON (not component)
func check_item(item: ItemUI) -> bool:
	return super(item) && (item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
