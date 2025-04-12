extends Container
class_name Inventory

@export var drag_bar: DragBar
@export var color: Color
@export var label_text: String
## visually creates the columns and rows of items
@export var inventory_scroll: ScrollContainer
@export var inventory_grid: GridContainer
@export var vbox: VBoxContainer
var dragging_my_item: bool = false

var mouse_hover: bool = false
var dragging: bool = false
var offset: Vector2
var offset2: Vector2

static var dragging_some_inventory: bool = false

const ITEM = preload("res://Scenes/UI/item_ui.tscn")

func check_item(item: ItemUI) -> bool:
	return is_instance_valid(item)

func add(new_underlying_item : ItemUI) -> bool:
	if check_item(new_underlying_item):
		#var item: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		new_underlying_item.set_inventory(self)
		return true
	return false

func remove(item: ItemUI) -> bool:
	if is_instance_valid(item):
		remove_child(item)
		item.queue_free()
		return true
	return false

func move(item: ItemUI) -> bool:
	if check_item(item):
		item.get_parent().remove_child(item)
		item.set_inventory(self)
		return true
	return false


func _ready() -> void:
	if color:
		drag_bar.modulate = color
	if label_text:
		drag_bar.label.text = label_text

func _process(delta: float) -> void:
	if ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: ItemUI = ItemUI.dragging_item
		call_deferred("drop", item)
		print("0")
	elif ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()):
		print("1")
	elif ItemUI.dragging_some_item && Input.is_action_just_released("left_click"):
		print("2")
	elif get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		print("3")
	
	return #TODO: remove below, replace with dragbar
	
	if visible && !ItemUI.dragging_some_item:
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = true
			#print("hover true")
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = false
			#print("hover false")
		
		if dragging && !Input.is_action_pressed("left_click"):
			dragging = false
			dragging_some_inventory = false
			z_index = 2
			#print("dragging false")
		
		if mouse_hover && Input.is_action_just_pressed("left_click"):
			dragging = true
			dragging_some_inventory = true
			z_index = 50
			offset = global_position
			offset2 = get_global_mouse_position()
			#print("dragging true")
		
		if dragging:
			global_position = lerp(global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
		
	else:
		mouse_hover = false
		if dragging:
			dragging_some_inventory = false
			dragging = false
		z_index = 2

func drop(item: ItemUI) -> void:
	# TODO: if item.has_cost type shit 
	if dragging_my_item:
		print("sell")
		remove(item)
	else:
		print("move")
		move(item)
