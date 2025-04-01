extends Control
class_name Item
## This class is the visual representation of potentially anything that can be shown in UI

## Given by UIManager
var item
var manager: Inventory
var draggable: bool
var base_position: Vector2
var position_offset: Vector2

## Control Nodes Visual Representation
@export var NameLabel: Label
@export var IconTexture: TextureRect
@export var BackgroundTexture: TextureRect
@export var DescriptionLabel: RichTextLabel
## ideas for future
#var sound_on_hover
#var animation_on_hover
#var limited_time_offer # dissapears from shop after time
#var sellable
#var placeable
#var extra_lore
#var ID: String


#func _init(new_item, new_manager: Inventory, can_drag: bool, new_position: Vector2) -> void:
#	item = new_item
#	draggable = can_drag
#	base_position = new_position
#	manager = new_manager

func _ready() -> void:
	custom_minimum_size = IconTexture.texture.get_size() + Vector2(5, 5)
	if is_instance_valid(DescriptionLabel.get_v_scroll_bar()):
		DescriptionLabel.get_v_scroll_bar().mouse_filter = Control.MOUSE_FILTER_PASS
	DescriptionLabel.visible = false

func show_details():
	DescriptionLabel.text = "[font_size=5]" + DescriptionLabel.text + "[/font_size]"
	DescriptionLabel.visible = true
	print("details: " + name)

func hide_details():
	DescriptionLabel.visible = false
	print("details bye bye: " + name)

func _on_mouse_entered() -> void:
	print("man")
	show_details()

func _on_mouse_exited() -> void:
	hide_details()
