extends Control
@onready var price: Label = $HBoxContainer/Price
@onready var image: TextureRect = $HBoxContainer/Button/HBoxContainer/Panel2/image
@onready var title: Label = $HBoxContainer/Button/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Title
@onready var rarity: Label = $HBoxContainer/Button/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Rarity
@onready var body: Label = $HBoxContainer/Button/HBoxContainer/Panel/VBoxContainer/HBoxContainer2/Body

var method: Callable
var data: ItemData
var hover_method: Callable
func setup(new_data: ItemData, new_method: Callable, new_hover_method: Callable):
	data = new_data
	method = new_method
	hover_method = new_hover_method
	set_title(data.item_name)
	set_body(data.item_description)
	set_image(data.item_image)
	set_rarity(ItemData.get_rarity(data.item_rarity))
	set_price("$" + str(roundi(data.item_buy_cost)))
func set_title(text: String):
	title.text = text
func set_body(text: String):
	body.text = text
func set_price(text: String):
	price.text = text
func set_rarity(text: String):
	rarity.text = text
func set_image(text: Texture2D):
	image.texture = text
func _on_button_pressed() -> void:
	if method:
		if method.call(data):
			queue_free()
func _on_button_mouse_entered() -> void:
	if data && data.stats:
		hover_method.call(data.stats)
