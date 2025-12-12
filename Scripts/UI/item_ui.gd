extends DraggableUI
class_name ItemUI
## This class is the visual representation of potentially anything that can be shown in UI

const SCENE = preload("res://Scenes/UI/item_ui.tscn")

## Given by UIManager
#var item
var data: ItemData
var inventory: Inventory
var item_parent: Control
var draggable: bool
var base_position: Vector2
var position_offset: Vector2
var string: String = "hello  \n"

static var IDindex: int = 1
var ID = 0
## Given by Item's Variables
#var data: ItemData = ItemData.new()

## Control Nodes Visual Representation
@export var NameLabel: Label
@export var IconTexture: TextureRect
@export var BackgroundTexture: TextureRect
@export var DescriptionPanel: Panel
@export var DescriptionLabel: RichTextLabel
@export var HandleVisual: TextureRect
@export var AttachmentVisual: TextureRect 
@export var HandleBackground: TextureRect
@export var AttachmentBackground: TextureRect
@export var AttachmentParent: Control
@export var HandleParent: Control
@export var ShowComponentVisuals: bool = false
const DescriptionMaxY: float = 120
const DescriptionMaxX: float = 120

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
	if is_instance_valid(DescriptionLabel.get_v_scroll_bar()):
		DescriptionLabel.get_v_scroll_bar().mouse_filter = Control.MOUSE_FILTER_PASS
	DescriptionPanel.visible = false
	z_index = 0
	call_deferred("connect_signals")

func connect_signals():
	if !GameManager.instance.is_connected("toggle_inventory", toggle_ui):
		GameManager.instance.connect("toggle_inventory", toggle_ui)

func reset_item():
	#print("reset item")
	set_item(data)

func set_item(new_data: ItemData):
	data = new_data
	if !data.is_connected("DataUpdated", reset_item):
		data.connect("DataUpdated", reset_item)
	NameLabel.text = data.item_name
	DescriptionLabel.text = data.item_description
	DescriptionPanel.self_modulate = data.item_color
	IconTexture.texture = data.item_image
	BackgroundTexture.self_modulate = data.border_color
	if data.item_type == ItemData.item_types.weapon:
		AttachmentVisual.texture = data.attachment_visual
		HandleVisual.texture = data.handle_visual
		AttachmentVisual.visible = true
		HandleVisual.visible = true
		IconTexture.visible = false

func get_item():
	return data.get_item()

func show_details():
	DescriptionPanel.visible = true
	showing_details = true
	
	inventory.set_description(data)
	#print(ItemData.get_rarity(data.item_rarity) + " - " + data.item_name)

func hide_details():
	DescriptionPanel.visible = false
	showing_details = false

func show_component_visuals():
	#print("Showing")
	HandleBackground.self_modulate = data.handle.border_color
	AttachmentBackground.self_modulate = data.attachment.border_color	
	ShowComponentVisuals = true
	HandleParent.visible = true
	AttachmentParent.visible = true
	size = Vector2(360, size.y)

func hide_component_visuals():
	ShowComponentVisuals = false
	HandleParent.visible = false
	AttachmentParent.visible = false
	size = Vector2(120, size.y)

func _process(delta: float) -> void:
	if !is_instance_valid(dragging_item):
		dragging_item = null
		dragging_some_item = false
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
		
		if dragging && dragging_some_ui:
			dragging_some_ui = false
			inventory.z_index = 3
		
		if mouse_hover && Input.is_action_just_pressed("left_click"):
			var good: bool = true
			for bar in hovered:
				if !is_instance_valid(bar):
					pass
				else:
					if bar != self && bar.get_priority() > parent.get_priority():
						good = false
			if good:
				dragging = true
				dragging_some_ui = true
				offset = global_position
				offset2 = get_global_mouse_position()
				top_level = true
				z_index = 50
				dragging_some_item = true
				dragging_item = self
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

func toggle_ui():
	if dragging:
		dragging_some_item = false
		dragging_item = null
	super()

func get_priority() -> int:
	return inventory.z_index
