extends Control
class_name Inventory

const STORAGE: String = "storage"
const SHOP: String = "shop"
const EQUIPMENT: String = "equipment"
const CRAFTING: String = "crafting"
@export var StartMinimized: bool = false
@export var toggle_button: Toggle_UI
@export var drag_bar: DraggableUI
@export var color: Color
@export var label_text: String
@export var default_item_parent: Control
var items: Array[ItemUI] = []

func clear() -> bool:
	for item in items:
		item.free_draggable_ui()
	items.clear()
	return true

func _ready() -> void:
	if not toggle_button && $VBoxContainer/DragBar/ToggleUIButton:
		toggle_button = $VBoxContainer/DragBar/ToggleUIButton
	if color:
		drag_bar.modulate = color
	if label_text:
		drag_bar.set_label(label_text)
	if StartMinimized:
		toggle_button.call_deferred("_toggled", true)

## Handles calling Drop when an item is dropped over this inventory rect
func _process(delta: float) -> void:
	if ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: ItemUI = ItemUI.dragging_item
		if item.inventory != self && !toggle_button.hide_ui: 
			call_deferred("ui_add", item)

func is_valid_type(item: ItemUI) -> bool:
	return is_instance_valid(item)
## Adds Item Through Game Manager
func ui_add(item: ItemUI) -> bool:
	print("ui_add")
	if !GameManager.instance.move_item(item, item.inventory, self):
		print("Can't Add: " + item.data.item_name)
		return false
	return true

func ui_remove(item: ItemUI):
	print("ui_remove")
	if !GameManager.instance.remove_item(item, self):
		print("Can't Remove: " + item.data.item_name)

func new_remove(item: ItemUI):
	print("new_remove")
	if item.get_parent():
		item.get_parent().remove_child(item)
	items.erase(item)

## Force Adds Item without checking with Game Manager
func new_add(item: ItemUI):
	print("new_add")
	item.inventory = self
	item.item_parent = default_item_parent
	item.position = Vector2.ZERO
	default_item_parent.add_child(item)
	default_item_parent.queue_sort()
	items.append(item)

func get_type() -> String:
	print("get type: default-storage")
	return STORAGE

func can_add(item: ItemUI) -> bool:
	print("can_add")
	return is_valid_type(item)

func can_remove(item: ItemUI) -> bool:
	print("can_remove")
	return is_instance_valid(item) && items.has(item)



## Old Implementation:
#func check_item(item: ItemUI) -> bool:
	#return is_instance_valid(item)
#
#func add(item : ItemUI) -> bool:
	#if check_item(item):
		#_add_item(item)
		#return true
	#return false
#
### Item requested to be moved away from this inventory
#func remove(item: ItemUI) -> bool:
	#if is_instance_valid(item) && items.has(item):
		#item.get_parent().remove_child(item)
		#items.erase(item)
		#return true
	#return false
#
### Item requested to be moved into this inventory
#func move(item: ItemUI) -> bool:
	#if check_item(item) && item.inventory.remove(item):
		#_add_item(item)
		#return true
	#return false
#
### Item Dragged and Dropped over this inventory
#func drop(item: ItemUI) -> void:
	#if item.inventory == self:
		#pass
	#else:
		#move(item)
#
#func _add_item(item: ItemUI) -> void:
	#item.inventory = self
	#item.item_parent = default_item_parent
	#item.position = Vector2.ZERO
	#default_item_parent.add_child(item)
	#default_item_parent.queue_sort()
	#items.append(item)
