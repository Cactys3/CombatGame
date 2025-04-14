extends Control
class_name Inventory

@export var drag_bar: DraggableUI
@export var color: Color
@export var label_text: String
## visually creates the columns and rows of items
@export var default_item_parent: Control
#@export var vbox: VBoxContainer
#@export var inventory_scroll: ScrollContainer

var items: Array[ItemUI] = []

func check_item(item: ItemUI) -> bool:
	return is_instance_valid(item)

func add(item : ItemUI) -> bool:
	if check_item(item):
		_add_item(item)
		return true
	return false

## Item requested to be moved away from this inventory
func remove(item: ItemUI) -> bool:
	if is_instance_valid(item) && items.has(item):
		item.get_parent().remove_child(item)
		items.erase(item)
		return true
	print("childs: " + str(get_children()))
	return false

## Item requested to be moved into this inventory
func move(item: ItemUI) -> bool:
	if check_item(item) && item.inventory.remove(item):
		_add_item(item)
		return true
	return false

## Item Dragged and Dropped over this inventory
func drop(item: ItemUI) -> void:
	if item.inventory == self:
		pass
	else:
		move(item)

func _add_item(item: ItemUI) -> void:
	item.inventory = self
	item.item_parent = default_item_parent
	item.position = Vector2.ZERO
	default_item_parent.add_child(item)
	default_item_parent.queue_sort()
	items.append(item)

func _ready() -> void:
	if color:
		drag_bar.modulate = color
	if label_text:
		drag_bar.set_label(label_text)

## Handles calling Drop when an item is dropped over this inventory rect
func _process(delta: float) -> void:
	if ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: ItemUI = ItemUI.dragging_item
		call_deferred("drop", item)
