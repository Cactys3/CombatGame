extends Control
class_name Option

#@export var button_stylebox: StyleBox
#@export var button_hover_stylebox: StyleBox
#
#@export var main_panel_stylebox: StyleBox
#@export var secondary_panel_stylebox: StyleBox
#
#@export var main_panels: Array[Panel]
#@export var secondary_panels: Array[Panel]
#
#@export var title_text_color: Color
#@export var body_text_color: Color
#@export var rarity_text_color: Color
#@export var price_text_color: Color

@export var button: Button
@export var image: TextureRect
@export var title: Label
@export var rarity: Label
@export var body: RichTextLabel 
@export var price: Label
var method: Callable
var hover_method: Callable
var data: ItemData

func setup(new_data: ItemData, new_method: Callable, new_hover_method: Callable):
	body.bbcode_enabled = true
	body.scroll_active = true
	body.clip_contents = true
	data = new_data
	method = new_method
	hover_method = new_hover_method
	set_title(data.item_name)
	set_body(data.get_item_description())
	set_image(data.item_image)
	set_rarity(ItemData.get_rarity(data.item_rarity))
	set_price(str(data.get_cost(false)))
	#if main_panel_stylebox:
		#for panel in main_panels:
			#panel.add_theme_stylebox_override("panel", main_panel_stylebox)
	#if secondary_panel_stylebox:
		#for panel in secondary_panels:
			#panel.add_theme_stylebox_override("panel", secondary_panel_stylebox)
	#if button_stylebox:
		#button.add_theme_stylebox_override("normal", button_stylebox)
	#if button_hover_stylebox:
		#button.add_theme_stylebox_override("pressed", button_hover_stylebox)
		#button.add_theme_stylebox_override("hover", button_hover_stylebox)
		#button.add_theme_stylebox_override("focus", button_hover_stylebox)
	#if title_text_color:
		#if title:
			#title.add_theme_color_override("font_color", title_text_color)
	#if rarity_text_color:
		#if rarity:
			#rarity.add_theme_color_override("font_color", rarity_text_color)
	#if body_text_color:
		#if body:
			#body.add_theme_color_override("font_color", body_text_color)
	#if price_text_color:
		#price.add_theme_color_override("font_color", price_text_color)
func set_price(text: String):
	if price:
		price.text = text
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

func reset():
	set_title("")
	set_body("")
	set_image(Texture2D.new())
	set_rarity("")
	set_price("")

func _on_button_pressed() -> void:
	if method:
		if method.call(data):
			queue_free()
func _on_button_mouse_entered() -> void:
	if data && data.stats:
		hover_method.call(data)
