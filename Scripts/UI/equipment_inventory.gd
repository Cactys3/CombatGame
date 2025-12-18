extends Inventory
class_name EquipmentInventory

@export var ItemParent: Control
@export var WeaponParent: Control

@export var ItemCountLabel: Label
@export var WeaponCountLabel: Label
@export var WeaponCapacity: int = 5
var WeaponCount: int = 0
var ItemCount: int = 0


func _ready() -> void:
	super()
	set_item_count(ItemCount)
	set_weapon_count(WeaponCount)

func _process(delta: float) -> void:
	super(delta)

## Override
func is_valid_type(item: ItemUI):
	#print("testing: " + item.data.item_type)
	#print(item.data.item_type == ItemData.ITEM || item.data.item_type == ItemData.WEAPON)
	#print(super(item))
	return super(item) && (item.data.item_type == ItemData.item_types.item || item.data.item_type == ItemData.item_types.weapon)

func get_type() -> String:
	#print("get type: equipment")
	return EQUIPMENT

func can_add(item: ItemUI) -> bool:
	#print("can_add_equipment")
	if (item.data.item_type == ItemData.item_types.weapon) && WeaponCount >= WeaponCapacity:
		return false
	return is_valid_type(item) && GameManager.instance.can_equip(item) 

func can_remove(item: ItemUI) -> bool:
	return is_instance_valid(item) && items.has(item) && GameManager.instance.can_unequip(item)

func backend_add(item: ItemUI):
	item.inventory = self
	item.position = Vector2.ZERO
	items.append(item)
	match(item.data.item_type):
		ItemData.item_types.weapon:
			item.item_parent = WeaponParent
			item.show_component_visuals()
			WeaponParent.add_child(item)
			WeaponParent.queue_sort()
			set_weapon_count(WeaponCount + 1)
		ItemData.item_types.item:
			item.item_parent = ItemParent
			ItemParent.add_child(item)
			ItemParent.queue_sort()
			item.get_item().enable()
			set_item_count(ItemCount + 1)

func backend_remove(item: ItemUI):
	super(item)
	match(item.data.item_type):
		ItemData.item_types.weapon:
			item.hide_component_visuals()
			WeaponParent.queue_sort()
			set_weapon_count(WeaponCount - 1)
		ItemData.item_types.item:
			ItemParent.queue_sort()
			item.get_item().disable()
			set_item_count(ItemCount - 1)

func set_weapon_count(count: int):
	WeaponCount = count
	WeaponCountLabel.text = str(count) + " / " + str(WeaponCapacity) + " Weapons"

func set_item_count(count: int):
	ItemCount = count
	ItemCountLabel.text = str(count) + " Items"
