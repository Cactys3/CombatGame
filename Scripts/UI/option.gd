extends Control
class_name Option

@export var outline_color: Color
@export var inside_color: Color
@export var title_text_color: Color
@export var normal_text_color: Color

@export var image: TextureRect
@export var title: Label
@export var rarity: Label
@export var body: Label 

var method: Callable
var hover_method: Callable
var data: ItemData

func setup(new_data: ItemData, new_method: Callable, new_hover_method: Callable):
	data = new_data
	method = new_method
	hover_method = new_hover_method
	set_title(data.item_name)
	set_body(data.item_description)
	set_image(data.item_image)
	set_rarity(ItemData.get_rarity(data.item_rarity))

func set_title(text: String):
	if title:
		title.text = text
func set_body(text: String):
	if body:
		body.text = text
func set_rarity(text: String):
	if rarity:
		rarity.text = text
func set_image(text: Texture2D):
	if image:
		image.texture = text

func _on_button_pressed() -> void:
	if method:
		if method.call(data):
			queue_free()
func _on_button_mouse_entered() -> void:
	if data && data.stats:
		hover_method.call(data)
