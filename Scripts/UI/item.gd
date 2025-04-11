extends Control
class_name Item
## This class is the visual representation of potentially anything that can be shown in UI

## Given by UIManager
var item
var manager: Inventory
var grid: GridContainer
var draggable: bool
var base_position: Vector2
var position_offset: Vector2
var string: String = "hello  \n"

static var IDindex: int = 1
var ID = 0
## Given by Item's Variables
var data: ItemData = ItemData.new()

## Control Nodes Visual Representation
@export var NameLabel: Label
@export var IconTexture: TextureRect
@export var BackgroundTexture: TextureRect
@export var DescriptionPanel: Panel
@export var DescriptionLabel: RichTextLabel
const DescriptionMaxY: float = 50
const DescriptionMaxX: float = 38

var showing_details: bool = false
var mouse_hover: bool = false
var dragging: bool = false
static var dragging_some_item: bool = false
static var dragging_item: Item 
static var dragging_item_from_inventory: Inventory
var offset: Vector2
var offset2: Vector2
## ideas for future
#var sound_on_hover
#var animation_on_hover
#var limited_time_offer # dissapears from shop after time
#var sellable
#var placeable
#var extra_lore
#var ID: String


func _ready() -> void:
	ID = IDindex
	IDindex += 1
	#custom_minimum_size = IconTexture.texture.get_size() + Vector2(5, 5)
	if is_instance_valid(DescriptionLabel.get_v_scroll_bar()):
		DescriptionLabel.get_v_scroll_bar().mouse_filter = Control.MOUSE_FILTER_PASS
	DescriptionPanel.visible = false

func setup(new_underlying_item : Node, new_manager: Inventory):
	item = new_underlying_item
	if item.has_method("getdata"):
		item.setdata()
		data = item.getdata()
		if data.ready:
			print("item work: " + item.name)
			NameLabel.text = data.item_name
			DescriptionLabel.text = data.item_description
			DescriptionPanel.modulate = data.item_color
			IconTexture.texture = data.item_image
			print("hello?? texutere: " + data.item_image.resource_path)
			BackgroundTexture.texture = data.item_image
		else:
			print("!item.data.ready: " + item.name)
	else:
		print("item no getdata: " + item.name)
	manager = new_manager
	grid = manager.inventory_grid
	position = Vector2.ZERO
	grid.add_child(self)
	grid.queue_sort()
	#NameLabel.text = "" #TODO: set variables based on item stuff, add them to all possible item classes
#	draggable = can_drag
#	base_position = new_position
#	manager = new_manager

func show_details():
	if data.ready:
		DescriptionLabel.text = "[font_size=5]" + " ID: " + str(ID) + "\n Pos: " + "[font_size=4]" + str(position) + "[/font_size]"  + "\nDescription: " + data.item_description + "[/font_size]"
	else:
		DescriptionLabel.text = "[font_size=5]" + " ID: " + str(ID) + "\n Pos: " + "[font_size=4]" + str(position) + "[/font_size]" + "[/font_size]"
	#DescriptionPanel.size = Vector2(DescriptionMaxX, clampf(DescriptionLabel.get_content_height() + 4, 1, DescriptionMaxY)) TODO: for if i want scrolling back
	#DescriptionLabel.size = Vector2(DescriptionMaxX, clampf(DescriptionLabel.get_content_height(), 1, DescriptionMaxY - 3))
	DescriptionLabel.size = Vector2(DescriptionMaxX,DescriptionLabel.get_content_height() )
	DescriptionPanel.size = Vector2(DescriptionMaxX + 2, DescriptionLabel.get_content_height() + 1)
	DescriptionPanel.visible = true
	showing_details = true

func hide_details():
	DescriptionPanel.visible = false
	showing_details = false

func _process(delta: float) -> void:
	if visible:
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = true
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = false
		
		if dragging && Input.is_action_just_released("left_click"):
			dragging = false
			top_level = false
			z_index = 2
			manager.dragging_my_item = false
			dragging_some_item = false
			dragging_item_from_inventory = null
			#position = Vector2.ZERO
			grid.queue_sort()
			print("dragging OFF: " + str(ID))
		
		if !dragging_some_item && mouse_hover && Input.is_action_just_pressed("left_click"):
			dragging = true
			offset = global_position
			offset2 = get_global_mouse_position()
			top_level = true
			z_index = 10
			manager.dragging_my_item = true
			dragging_some_item = true
			dragging_item = self
			dragging_item_from_inventory = manager
			print("dragging ON: " + str(ID))
			global_position = offset
		
		if showing_details && (!mouse_hover || dragging_some_item):
			hide_details()
			showing_details = false
		
		if !showing_details && (mouse_hover && !dragging_some_item):
			show_details()
		
		if dragging:
			#global_position = get_global_mouse_position() - Vector2(20, 20)
			global_position = lerp(global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
		
	if dragging && process_mode == PROCESS_MODE_DISABLED:
		dragging_some_item = false
	if (mouse_hover || dragging || showing_details || dragging_some_item) && process_mode == PROCESS_MODE_DISABLED:
		print("hello")
		mouse_hover = false
		dragging = false
		showing_details = false
		hide_details()
