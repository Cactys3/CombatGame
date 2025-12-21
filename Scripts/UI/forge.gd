extends Inventory

class_name Forge



#@export var ModsPage: Control
#@export var StatsPage: Control
#@export var HandleHolder: Control
#@export var AttachmentHolder: Control
#@export var ProjectileHolder: Control
#@export var ModHolder: Control
@export var handle_option: Option 
@export var attachment_option: Option 
@export var projectile_option: Option 
@export var stats_display: StatsDisplay
var handle: ItemUI = null
var attachment: ItemUI = null
var projectile: ItemUI = null


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
		## Make weapon and check if can add to equipment
		var weapon: ItemData = ItemData.new()
		weapon.setup(false, ShopManager.random_rarity())
		weapon.set_components(attachment.data, handle.data, projectile.data)
		if GameManager.instance.ui_man.equipment.ui_add(ShopManager.make_itemUI(weapon)):
			backend_remove(handle)
			backend_remove(attachment)
			backend_remove(projectile)
			crafted_weapon.emit()
			return true
	return false

## Override
func is_valid_type(item: ItemUI):
	return super(item) && (item.data.item_type == ItemData.item_types.attachment || item.data.item_type == ItemData.item_types.handle || item.data.item_type == ItemData.item_types.projectile)
func get_type() -> String:
	return CRAFTING
func can_add(item: ItemUI) -> bool:
	return is_valid_type(item)
func can_remove(item: ItemUI) -> bool:
	return is_instance_valid(item) && items.has(item) 
func backend_add(item: ItemUI):
	items.append(item)
	item.inventory = self
	default_item_parent.add_child(item)
	item.item_parent = default_item_parent
	item.position = Vector2.ZERO
	match item.data.item_type:
		ItemData.item_types.attachment:
			if attachment != null:
				var a: ItemUI = attachment
				backend_remove(attachment)
				GameManager.instance.ui_man.inventory.backend_add(a)
			attachment = item
			attachment_option.setup(item.data, hover_option, choose_option)
		ItemData.item_types.handle:
			if handle != null:
				var h: ItemUI = handle
				backend_remove(handle)
				GameManager.instance.ui_man.inventory.backend_add(h)
			handle = item
			handle_option.setup(item.data, hover_option, choose_option)
		ItemData.item_types.projectile:
			if projectile != null:
				var proj: ItemUI = projectile
				backend_remove(projectile)
				GameManager.instance.ui_man.inventory.backend_add(proj)
			projectile = item
			projectile_option.setup(item.data, hover_option, choose_option)
		_:
			printerr("backend add to forge called for invalid item")
func backend_remove(item: ItemUI):
	if item.get_parent():
		item.get_parent().remove_child(item)
	items.erase(item)
	match item.data.item_type:
		ItemData.item_types.attachment:
			if attachment == item:
				attachment = null
				attachment_option.reset()
		ItemData.item_types.handle:
			if handle == item:
				handle = null
				handle_option.reset()
		ItemData.item_types.projectile:
			if projectile == item:
				projectile = null
				projectile_option.reset()
		ItemData.item_types.mod:
			pass
		_:
			print("bad bad bad this is bad bad this bad") ## uhm
## Remove, for now, not good, should redo
func choose_option(data: ItemData):
	if handle_option.data == data:
		backend_remove(handle)
	if attachment_option.data == data:
		backend_remove(attachment)
	if projectile_option.data == data:
		backend_remove(projectile)
func hover_option(data: ItemData):
	if data && data.has_stats:
		stats_display.set_stats(data.stats, data.item_name)
