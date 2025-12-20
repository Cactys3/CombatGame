extends Inventory

class_name forge_inventory

@export var ModsPage: Control
@export var StatsPage: Control
@export var HandleHolder: Control
@export var AttachmentHolder: Control
@export var ProjectileHolder: Control
@export var ModHolder: Control
var handle: ItemUI = null
var attachment: ItemUI = null
var projectile: ItemUI = null
var mods: Array[ItemUI]
const flyweight: ItemUI = null

signal crafted_weapon

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## If successful: Adds weapon to player, adds weapon UI to equipment UI, destroys this weapon crafting menu
func make_weapon() -> bool:
	if handle != null && attachment != null && projectile != null:
		if ItemUI.dragging_some_item:
			ItemUI.dragging_item.dragging = false # TODO: bug when make weapon button overlaps with item, this 'if' doesn't fix
			ItemUI.dragging_some_item = false
			ItemUI.dragging_some_ui = false
		if GameManager.instance.craft_weapon(handle, attachment, projectile): # TODO: Next the weapon is added to the player's equipment inventory, in this script OR GameManager
			backend_remove(handle) ## TODO: replaced remove with new_remove
			backend_remove(attachment)
			backend_remove(projectile) # TODO: handle if remove fails (remove by force)
			crafted_weapon.emit()
			return true
	return false

## Override
func is_valid_type(item: ItemUI):
	return super(item) && (item.data.item_type == ItemData.item_types.attachment || item.data.item_type == ItemData.item_types.handle || item.data.item_type == ItemData.item_types.projectile)

func get_type() -> String:
	#print("get type: crafting")
	return CRAFTING

func can_add(item: ItemUI) -> bool:
	return is_valid_type(item)

func can_remove(item: ItemUI) -> bool:
	return is_instance_valid(item) && items.has(item) 

func backend_add(item: ItemUI):
	items.append(item)
	item.inventory = self
	item.position = Vector2.ZERO
	match item.data.item_type:
		ItemData.item_types.attachment:
			if attachment != null:
				var a: ItemUI = attachment
				backend_remove(attachment)
				GameManager.instance.ui_man.inventory.backend_add(a) # TODO: rework into real code
			attachment = item
			AttachmentHolder.add_child(item)
			item.item_parent = AttachmentHolder
		ItemData.item_types.handle:
			if handle != null:
				var h: ItemUI = handle
				backend_remove(handle)
				GameManager.instance.ui_man.inventory.backend_add(h) # TODO: rework into real code
			handle = item
			HandleHolder.add_child(item)
			item.item_parent = HandleHolder
		ItemData.item_types.projectile:
			if projectile != null:
				var proj: ItemUI = projectile
				backend_remove(projectile)
				GameManager.instance.ui_man.inventory.backend_add(proj) # TODO: rework into real code
			projectile = item
			ProjectileHolder.add_child(item)
			item.item_parent = ProjectileHolder
		ItemData.item_types.mod:
			if mods.size() >= 2: # TODO: max mod size reached?
				pass
			mods.append(item)
			ModHolder.add_child(item)
			item.item_parent = ModHolder
		_:
			printerr("baddd")

func backend_remove(item: ItemUI):
	#print("new_remove_crafting")
	if item.get_parent():
		item.get_parent().remove_child(item)
	items.erase(item)
	match item.data.item_type:
		ItemData.item_types.attachment:
			if attachment == item:
				attachment = null
		ItemData.item_types.handle:
			if handle == item:
				handle = null
		ItemData.item_types.projectile:
			if projectile == item:
				projectile = null
		ItemData.item_types.mod:
			pass
		_:
			print("bad bad bad this is bad bad this bad") ## uhm
