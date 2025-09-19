extends Inventory
class_name EquipmentInventory

@export var ItemParent: Control
@export var WeaponParent: Control

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Override
func is_valid_type(item: ItemUI):
	#print("testing: " + item.data.item_type)
	#print(item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
	print(super(item))
	return super(item) && (item.data.item_type == ItemData.item_types.item || item.data.item_type == ItemData.item_types.weapon)

func get_type() -> String:
	print("get type: equipment")
	return EQUIPMENT

func can_add(item: ItemUI) -> bool:
	print("can_add_equipment")
	return is_valid_type(item) && GameManager.instance.can_equip(item)

func can_remove(item: ItemUI) -> bool:
	print("can_remove_equipment")
	return is_instance_valid(item) && items.has(item) && GameManager.instance.can_unequip(item)

func new_add(item: ItemUI):
	print("new_add_equiptment")
	item.inventory = self
	item.position = Vector2.ZERO
	items.append(item)
	match(item.data.item_type):
		ItemData.item_types.weapon:
			item.item_parent = WeaponParent
			item.show_component_visuals()
			WeaponParent.add_child(item)
			WeaponParent.queue_sort()
		ItemData.item_types.item:
			item.item_parent = ItemParent
			ItemParent.add_child(item)
			ItemParent.queue_sort()

func new_remove(item: ItemUI):
	print("new_remove_equipment")
	match(item.data.item_type):
		ItemData.item_types.weapon:
			item.hide_component_visuals()
			WeaponParent.remove_child(item)
			WeaponParent.queue_sort()
		ItemData.item_types.item:
			ItemParent.remove_child(item)
			ItemParent.queue_sort()
	items.erase(item)

## Old Implementation:
#func add(item : ItemUI) -> bool:
	##print("started add")
	#if check_item(item):
		#_add_item(item)
	#return false
#
### Item requested to be moved away from this inventory
#func remove(item: ItemUI) -> bool:
	#if is_instance_valid(item) && items.has(item):
		#match(item.data.item_type):
			#ItemData.WEAPON:
				#if GameManager.instance.remove_weapon_from_player(item.item):
					#WeaponParent.remove_child(item)
					#WeaponParent.queue_sort()
					#items.erase(item) #TODO: seperate weapon list from item list ? 
					##print("remove weapon")
					#return true
			#ItemData.ITEM:
				#if GameManager.instance.remove_item_from_player(item.item):
					#ItemParent.remove_child(item)
					#ItemParent.queue_sort()
					#items.erase(item) #TODO: seperate weapon list from item list ? 
					##print("remove item")
					#return true
	##print("childs: " + str(get_children()))
	#return false
#
### Item requested to be moved into this inventory
#func move(item: ItemUI) -> bool:
	##print("move: " + str(check_item(item)))
	#if check_item(item) && item.inventory.remove(item):
		#_add_item(item)
		#return true
	#return false
#
#func _add_item(item: ItemUI) -> void:
	#match(item.data.item_type):
		#ItemData.WEAPON:
			#if GameManager.instance.add_weapon_to_player(item.item):
				#print("add OLD STYLE ADD!")
				#_add_equipment_weapon(item)
		#ItemData.ITEM:
			#if GameManager.instance.add_item_to_player(item.item):
				##print("added item!")
				#_add_equipment_item(item)
#
#func _add_equipment_item(item: ItemUI) -> void:
	#item.inventory = self
	#item.item_parent = ItemParent
	#item.position = Vector2.ZERO
	#ItemParent.add_child(item)
	#ItemParent.queue_sort()
	#items.append(item) #TODO: seperate weapon list from item list ? 
#
#func _add_equipment_weapon(item: ItemUI) -> void:
	#item.inventory = self
	#item.item_parent = WeaponParent
	#item.position = Vector2.ZERO
	#WeaponParent.add_child(item)
	#WeaponParent.queue_sort()
	#items.append(item) #TODO: seperate weapon list from item list ? 
#
### Check is not null and is an ITEM or complete WEAPON (not component)
#func check_item(item: ItemUI) -> bool:
	#return super(item) && (item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
