extends Panel
@onready var title: Label = $Title
@onready var image: TextureRect = $Image
@onready var rarity_or_new: Label = $RarityOrNew
@onready var type: Label = $Type
@onready var body: Label = $Body
var data: LevelUpData
var method: Callable
func set_data(new_data: LevelUpData):
	data = new_data
	set_title(data.option_name)
	set_body(data.description)
	set_image(data.image)
	set_type(data.get_type_name(data.type))
func set_title(text: String):
	title.text = text
func set_body(text: String):
	body.text = text
func set_type(text: String):
	type.text = text
func set_image(text: Texture2D):
	image.texture = text
func connect_signal(new_method: Callable):
	method = new_method

func _on_button_pressed() -> void:
	if method:
		method.call(data)
