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

const ITEM = preload("res://Scenes/UI/item.tscn")

func add(new_underlying_item) -> void:
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
