extends PanelContainer

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var title: Label = $VBoxContainer/Title
@onready var body: Label = $VBoxContainer/Body
@onready var stats: StatsDisplay = $VBoxContainer/Stats
@onready var confirm_button: Button = $VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $VBoxContainer/HBoxContainer/CancelButton
@onready var confirm_handle_button: Button = $VBoxContainer/HBoxContainer/ConfirmHandleButton
@onready var confirm_attachment_button: Button = $VBoxContainer/HBoxContainer/ConfirmAttachmentButton
@onready var confirm_projectile_button: Button = $VBoxContainer/HBoxContainer/ConfirmProjectileButton

var inventory: Inventory
var item_eating: ItemUI
var feed_items: Array[ItemUI]
var type: int
## Drag and drop ItemUI onto feed_panel to add them to feed list
## Add dragged ItemUI to Special StatsVisual 
## Wait for Confirm or Cancel buttons pressed
## Confirm button adds Dragged ItemUI's AddedStats to original ItemUI
## Cancel buttons cancels

## Can only drag in components (must dismantle weapons before feeding)

## Weapon:
# feeding components -> component's added stats goes to same component on weapon


func _process(delta: float) -> void:
	if visible && ItemUI.dragging_item && Input.is_action_just_released("left_click") && get_global_rect().has_point(get_global_mouse_position()):
		add_item(ItemUI.dragging_item)

func setup(inven: Inventory, new_item: ItemUI):
	inventory = null
	item_eating = null
	feed_items.clear()
	type = -1
	stats.clear_lists()
	
	stats.setup_single_stats(new_item.data.item_name)
	
	type = new_item.data.item_type
	print(ItemData.get_type(type))
	
	if type == ItemData.item_types.weapon:
		confirm_button.visible = false
		confirm_handle_button.visible = true
		confirm_attachment_button.visible = true
		confirm_projectile_button.visible = true
	elif new_item.data.is_component():
		confirm_button.visible = true
		confirm_handle_button.visible = false
		confirm_attachment_button.visible = false
		confirm_projectile_button.visible = false
	
	inventory = inven
	item_eating = new_item
	stats.setup_generic("Feed Stats")

func add_item(new_item: ItemUI):
	if new_item == item_eating || feed_items.has(new_item) || !new_item.data.has_stats || !new_item.data.is_component():
		return
	feed_items.append(new_item)
	stats.add_single_stats(new_item.data.added_stats)

func is_correct_type(item: ItemData):
	return item.item_type == type

func _confirm() -> void:
	## Add Added Stats
	if inventory:
		for item_to_feed in feed_items:
			item_to_feed.data.transfer_additional_stats(item_eating.data.added_stats)
			item_to_feed.free_draggable_ui()
		inventory.show_side()
func _cancel() -> void:
	if inventory:
		inventory.show_side()
func _confirm_handle() -> void:
	## Add Added Stats from handle
	if inventory:
		for item_to_feed in feed_items:
			
			item_to_feed.data.transfer_additional_stats(item_eating.data.handle.added_stats)
			item_to_feed.free_draggable_ui()
		inventory.show_side()
func _confirm_attachment() -> void:
	## Add Added Stats from handle
	if inventory:
		for item_to_feed in feed_items:
			item_to_feed.data.transfer_additional_stats(item_eating.data.attachment.added_stats)
			item_to_feed.free_draggable_ui()
		inventory.show_side()
func _confirm_projectile() -> void:
	## Add Added Stats from handle
	if inventory:
		for item_to_feed in feed_items:
			item_to_feed.data.transfer_additional_stats(item_eating.data.projectile.added_stats)
			item_to_feed.free_draggable_ui()
		inventory.show_side()
