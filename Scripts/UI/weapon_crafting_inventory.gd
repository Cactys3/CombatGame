extends Inventory


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

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func check_item(item: ItemUI) -> bool:
	return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.MOD)

func _add_item(item: ItemUI) -> void:
	match item.data.item_type:
		ItemData.ATTACHMENT:
			if attachment != null:
				var a: ItemUI = attachment
				remove(attachment)
				GameManager.instance.ui_man.inventory.add(a) # TODO: rework into real code
			attachment = item
			AttachmentHolder.add_child(item)
			item.item_parent = AttachmentHolder
		ItemData.HANDLE:
			if handle != null:
				var h: ItemUI = handle
				remove(handle)
				GameManager.instance.ui_man.inventory.add(h) # TODO: rework into real code
			handle = item
			HandleHolder.add_child(item)
			item.item_parent = HandleHolder
		ItemData.PROJECTILE:
			if projectile != null:
				var p: ItemUI = projectile
				remove(projectile)
				GameManager.instance.ui_man.inventory.add(p) # TODO: rework into real code
			projectile = item
			ProjectileHolder.add_child(item)
			item.item_parent = ProjectileHolder
		ItemData.MOD:
			if mods.size() >= 2: # TODO: max mod size reached?
				pass
			mods.append(item)
			ModHolder.add_child(item)
			item.item_parent = ModHolder
		_:
			printerr("baddd")
			return
	items.append(item)
	item.inventory = self
	item.position = Vector2.ZERO

## Item requested to be moved away from this inventory
func remove(item: ItemUI) -> bool:
	if is_instance_valid(item):
		match item.data.item_type:
			ItemData.ATTACHMENT:
				if attachment == item:
					item.get_parent().remove_child(item)
					attachment = null
					return true
			ItemData.HANDLE:
				if handle == item:
					item.get_parent().remove_child(item)
					handle = null
					return true
			ItemData.PROJECTILE:
				if projectile == item:
					item.get_parent().remove_child(item)
					projectile = null
					#print(str(projectile == item) + str(projectile == null) + str(item == ItemUI.new()) + str(projectile == flyweight) + str(flyweight == item) + str(is_instance_valid(projectile)))
					return true
			ItemData.MOD:
				if items.has(item):
					item.get_parent().remove_child(item)
					items.erase(item)
					return true
	print("Remove item false for weapon_crafting, item: " + item.data.item_name)
	return false # TODO: this reports false when this inven doesn't have the item, is that good..?

## If successful: Adds weapon to player, adds weapon UI to equipment UI, destroys this weapon crafting menu
func make_weapon() -> bool:
	if handle != null && attachment != null && projectile != null:
		return GameManager.instance.add_weapon_to_player(handle, attachment, projectile) # TODO: make weaponUI a seperate thing or smth
	print("make weapon bad")
	return false
