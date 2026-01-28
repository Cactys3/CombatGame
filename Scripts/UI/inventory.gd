extends Control
class_name Inventory

const STORAGE: String = "storage"
const SHOP: String = "shop"
const EQUIPMENT: String = "equipment"
const CRAFTING: String = "crafting"
@export var default_item_parent: Control
var items: Array[ItemUI] = []
@export var description_body: RichTextLabel
@export var description_title: RichTextLabel
@export var description_stats: StatsDisplay
var showing_item: ItemData = null

var item_count: int:
	get():
		return _get_item_count()
var weapon_count: int:
	get():
		return _get_weapon_count()
var component_count: int:
	get():
		return _get_component_count()

func clear() -> bool:
	for item in items:
		item.free_draggable_ui()
	items.clear()
	return true
func _ready() -> void:
	pass
## Handles calling Drop when an item is dropped over this inventory rect
func _process(_delta: float) -> void:
	if ItemUI.dragging_some_item && get_global_rect().has_point(get_global_mouse_position()) && Input.is_action_just_released("left_click"):
		var item: ItemUI = ItemUI.dragging_item
		if item.inventory != self:
			call_deferred("ui_add", item)
## Returns if item is valid for this inventory
func is_valid_type(item: ItemUI) -> bool:
	return is_instance_valid(item)
## Adds Item Through Game Manager
func ui_add(item: ItemUI) -> bool:
	if !GameManager.instance.move_item(item, item.inventory, self):
		return false
	return true
## Removes Item Through Game Manager
func ui_remove(item: ItemUI):
	if !GameManager.instance.remove_item(item, self):
		print("Can't Remove: " + item.data.item_name)
## Removes an Item from the backend
func backend_remove(item: ItemUI):
	if item.get_parent():
		item.get_parent().remove_child(item)
	items.erase(item)
	if showing_item == item.data:
		reset_description()
## Adds an Item to the backend
func backend_add(item: ItemUI):
	item.inventory = self
	item.item_parent = default_item_parent
	item.position = Vector2.ZERO
	default_item_parent.add_child(item)
	default_item_parent.queue_sort()
	items.append(item)
	#GameManager.instance.player.player_stats.print_stats()
## Returns the type this inventory is
func get_type() -> String:
	return STORAGE
## Returns if item can currently be added to self
func can_add(item: ItemUI) -> bool:
	return is_valid_type(item)
## Returns if item can currently be removed from self
func can_remove(item: ItemUI) -> bool:
	return is_instance_valid(item) && items.has(item)
## Add Functionality:
# Can sort items array via: Alphabetical, etc
# Can show only items of a certian type: components, etc
## Sets the description page
func set_description(data: ItemData):
	reset_description()
	showing_item = data
	if description_stats && data.stats:
		description_stats.setup_substats(data.stats, data.item_name)
		description_stats.visible = true
	if description_body:
		description_body.text = data.item_description
		if data.has_rarity:
			description_body.text += "\n" + "Rarity: " + ItemData.get_rarity(data.item_rarity)
		if data.level:
			description_body.text += "\n" + "Level: " + str(data.level)
		if description_title:
			description_title.text = data.item_name
## Sets description boxes to be default
func reset_description():
	showing_item = null
	if description_body:
		description_body.text = "Item Description"
	if description_title:
		description_title.text = "Hover an Item first!"
	if description_stats:
		description_stats.visible = false
## Sets up RightClick UI for the ItemUI or returns null
func RightClick(item: ItemUI, pos: Vector2) -> Control:
	return null
## Sorting Functions, Reorders items as children
func sort_random():
	items.shuffle()
	reset_children()
func sort_type():
	items.sort_custom(func(a: ItemUI, b: ItemUI): 
		return a.data.item_type > b.data.item_type)
	reset_children()
func sort_reverse_type():
	items.sort_custom(func(a: ItemUI, b: ItemUI): 
		return a.data.item_type < b.data.item_type)
	reset_children()
func sort_rarity():
	items.sort_custom(func(a: ItemUI, b: ItemUI): 
		if !a.data.has_rarity:
			return false
		if !b.data.has_rarity:
			return true
		return a.data.item_rarity > b.data.item_rarity)
	reset_children()
func sort_reverse_rarity():
	items.sort_custom(func(a: ItemUI, b: ItemUI): 
		if !a.data.has_rarity:
			return false
		if !b.data.has_rarity:
			return true
		return a.data.item_rarity > b.data.item_rarity)
	reset_children()
func sort_reverse_alphabetically():
	items.sort_custom(func(a, b): return a.data.item_name > b.data.item_name)
	reset_children()
func sort_alphabetically():
	items.sort_custom(func(a, b): return a.data.item_name < b.data.item_name)
	reset_children()
## Sets item children in order of array index
func reset_children():
	for i in range(items.size()):
		default_item_parent.move_child(items[i], i)
var last_clicked: int = -1
func button1():
	if last_clicked == 1:
		sort_reverse_alphabetically()
		last_clicked = -1
	else:
		sort_alphabetically()
		last_clicked = 1
func button2():
	if last_clicked == 2:
		sort_reverse_rarity()
		last_clicked = -1
	else:
		sort_rarity()
		last_clicked = 2
func button3():
	if last_clicked == 3:
		sort_reverse_type()
		last_clicked = -1
	else:
		sort_type()
		last_clicked = 3
func button4():
	sort_random()
	last_clicked = 4

func _get_item_count() -> int:
	var ret: int = 0
	for item in items:
		if item.data.item_type == ItemData.item_types.item:
			ret += 1
	return ret
func _get_weapon_count() -> int:
	var ret: int = 0
	for item in items:
		if item.data.item_type == ItemData.item_types.weapon:
			ret += 1
	return ret
func _get_component_count() -> int:
	var ret: int = 0
	for item in items:
		if item.data.is_component():
			ret += 1
	return ret
