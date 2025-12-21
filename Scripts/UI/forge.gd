extends Control
class_name Forge

@export var handle_option: Option 
@export var attachment_option: Option 
@export var projectile_option: Option 
@export var stats_display: StatsDisplay
var handle: ItemUI = null
var attachment: ItemUI = null
var projectile: ItemUI = null

signal crafted_weapon
## Try to 'add' item if dropped onto forge
func _process(delta: float) -> void:
	if ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: ItemUI = ItemUI.dragging_item
		call_deferred("add", item)
## If successful: Adds weapon to player, adds weapon UI to equipment UI, destroys this weapon crafting menu
func make_weapon() -> void:
	print("make weapon: " + str(handle) + str(attachment) + str(projectile))
	if handle == null || attachment == null || projectile == null:
		return
	## Make weapon and check if can add to equipment
	var weapon: ItemData = ItemData.new()
	weapon.setup(false, ShopManager.random_rarity())
	weapon.set_components(attachment.data, handle.data, projectile.data)
	if GameManager.instance.ui_man.equipment.ui_add(ShopManager.make_itemUI(weapon)):
		handle.inventory.backend_remove(handle)
		attachment.inventory.backend_remove(attachment)
		projectile.inventory.backend_remove(projectile)
		crafted_weapon.emit()
func clear():
	if attachment:
		attachment = null
		attachment_option.reset()
	if handle:
		handle = null
		handle_option.reset()
	if projectile:
		projectile = null
		projectile_option.reset()
## If component from Storage, setup option
func add(item: ItemUI):
	if item.inventory.get_type() == Inventory.STORAGE:
		match item.data.item_type:
			ItemData.item_types.attachment:
				attachment = item
				attachment_option.setup(item.data, hover_option, choose_option)
			ItemData.item_types.handle:
				handle = item
				handle_option.setup(item.data, hover_option, choose_option)
			ItemData.item_types.projectile:
				projectile = item
				projectile_option.setup(item.data, hover_option, choose_option)
## If component, reset option
func remove(item: ItemUI):
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
## Reset options when clicked on
func choose_option(data: ItemData):
	if handle_option.data == data:
		remove(handle)
	if attachment_option.data == data:
		remove(attachment)
	if projectile_option.data == data:
		remove(projectile)
## Display stats of hovered component
func hover_option(data: ItemData):
	if data && data.has_stats:
		stats_display.set_stats(data.stats, data.item_name)
