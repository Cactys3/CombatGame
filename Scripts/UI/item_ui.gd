extends DraggableUI
class_name ItemUI
## This class is the visual representation of potentially anything that can be shown in UI

const SCENE = preload("res://Scenes/UI/item_ui.tscn")



## Given by UIManager
var item
var inventory: Inventory
var item_parent: Control
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
#var mouse_hover: bool = false
#var dragging: bool = false
static var dragging_some_item: bool = false
static var dragging_item: ItemUI = null
#var offset: Vector2
#var offset2: Vector2
## ideas for future
#var sound_on_hover
#var animation_on_hover
#var limited_time_offer # dissapears from shop after time
#var sellable
#var placeable
#var extra_lore
#var ID: String


## expanded vs small version
# Change size of 

func _ready() -> void:
	super()
	ID = IDindex
	IDindex += 1
	#custom_minimum_size = IconTexture.texture.get_size() + Vector2(5, 5)
	if is_instance_valid(DescriptionLabel.get_v_scroll_bar()):
		DescriptionLabel.get_v_scroll_bar().mouse_filter = Control.MOUSE_FILTER_PASS
	DescriptionPanel.visible = false
	z_index = 0

#func set_ui_details(is_expanded: bool, )

func set_item(new_underlying_item: Node):
	item = new_underlying_item
	if item.has_method("getdata"):
		item.setdata()
		data = item.getdata()
		if data.ready:
			NameLabel.text = data.item_name
			DescriptionLabel.text = data.item_description
			DescriptionPanel.modulate = data.item_color
			IconTexture.texture = data.item_image
			BackgroundTexture.texture = data.item_image

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
	DescriptionLabel.size = Vector2(1 , 1)
	DescriptionPanel.size = Vector2(1 , 1)
	DescriptionPanel.visible = false
	showing_details = false

func _process(delta: float) -> void:
	if !(dragging_some_ui && !dragging) && visible && process_mode != PROCESS_MODE_DISABLED:
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = true
			hovered.append(self)
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			mouse_hover = false
			hovered.erase(self)
		
		if dragging && !Input.is_action_pressed("left_click"):
			dragging = false
			dragging_some_ui = false
			top_level = false
			z_index = 0
			call_deferred("set", "dragging_some_item", false)
			item_parent.queue_sort()
			#print("dragging OFF: " + str(ID))
		
		if dragging && dragging_some_ui:
			dragging_some_ui = false
			inventory.z_index = 3
		
		if mouse_hover && Input.is_action_just_pressed("left_click"):
			var good: bool = true
			for bar in hovered:
				if bar != self && bar.get_priority() > parent.get_priority():
					good = false
				else:
					pass#print(bar.name + " lost dragging context with: " + str(bar.get_priority()))
			if good:
				#print(name + " won dragging context with: " + str(get_priority()))
				dragging = true
				dragging_some_ui = true
				offset = global_position
				offset2 = get_global_mouse_position()
				top_level = true
				z_index = 50
				dragging_some_item = true
				dragging_item = self
				#print("dragging ON: " + str(ID))
				global_position = offset
		
		if showing_details && (!mouse_hover || dragging_some_item):
			hide_details()
			showing_details = false
		
		if !showing_details && (mouse_hover && !dragging_some_item):
			show_details()
		
		if dragging:
			global_position = lerp(global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
	else:
		if z_index > 0 && dragging_some_ui && !dragging:
			z_index = 0
		if dragging:
			dragging = false
			dragging_some_item = false
			dragging_some_ui = false
		if  showing_details:
			showing_details = false
			hide_details()

func free_draggable_ui():
	if dragging:
		dragging_some_item = false
		dragging_item = null
	super()

func get_priority() -> int:
	return inventory.z_index
