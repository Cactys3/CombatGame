extends Container
class_name Inventory

## visually creates the columns and rows of items
@export var inventory_scroll: ScrollContainer
@export var inventory_grid: GridContainer
@export var vbox: VBoxContainer
@export var drop_visual: Panel
@export var drop_text: Label
var dragging_my_item: bool = false

var showing_drop: bool = false
var mouse_hover: bool = false
var dragging: bool = false
var offset: Vector2
var offset2: Vector2

const ITEM = preload("res://Scenes/UI/item.tscn")

func add(new_underlying_item : Node) -> void:
	if is_instance_valid(inventory_grid):
		var item: Item = ITEM.instantiate()
		item.setup(new_underlying_item, self)

func remove(item: Item) -> void:
	if is_instance_valid(item):
		remove_child(item)

func move(item: Item) -> void:
	if is_instance_valid(item):
		item.get_parent().remove_child(item)
		item.setup(item.item,  self)
	else:
		print("bad instance?")

func _ready() -> void:
	drop_visual.visible = false

func _process(delta: float) -> void:
	if !showing_drop && Item.dragging_some_item:
		showing_drop = true
		if dragging_my_item:
			drop_text.text = "Drop to Delete!"
		else:
			drop_text.text = "Drop to Move!"
		drop_visual.visible = true
	
	if visible && !Item.dragging_some_item:
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = true
			print("hover true")
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = false
			print("hover false")
		
		if dragging && !Input.is_action_pressed("left_click"):
			dragging = false
			print("dragging false")
		
		if mouse_hover && Input.is_action_just_pressed("left_click"):
			dragging = true
			offset = global_position
			offset2 = get_global_mouse_position()
			print("dragging true")
		
		if dragging:
			global_position = lerp(global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
		
	else:
		mouse_hover = false
		dragging = false
	
	if showing_drop && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: Item = Item.dragging_item
		call_deferred("drop", item)
	
	if showing_drop && !Item.dragging_some_item:
		showing_drop = false
		drop_visual.visible = false

func drop(item: Item) -> void:
	# TODO: if item.has_cost type shit 
	if dragging_my_item:
		print("sell")
		remove(item)
	else:
		print("move")
		move(item)
