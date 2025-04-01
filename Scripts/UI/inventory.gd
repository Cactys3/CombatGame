extends MarginContainer
class_name Inventory

## visually creates the columns and rows of items
@export var inventory_scroll: ScrollContainer
@export var inventory_grid: GridContainer

const ITEM = preload("res://Scenes/UI/item.tscn")

func add(item: Item) -> void:
	pass


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ability1") && is_instance_valid(inventory_grid):
		var item: Item = ITEM.instantiate()
		item.position = Vector2.ZERO
		inventory_grid.add_child(item)
		inventory_grid.queue_sort()
		print("omg!: " + name)
	if !is_instance_valid(inventory_grid):
		print("bad")
