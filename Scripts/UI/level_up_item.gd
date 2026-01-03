extends Panel
@onready var title: Label = $Title
@onready var image: TextureRect = $Image
@onready var rarity: Label = $RarityOrNew
@onready var type: Label = $Type
@onready var body: RichTextLabel = $Body
var data: LevelUpData
var method: Callable
var hover_method: Callable
func set_data(new_data: LevelUpData, new_hover_method: Callable):
	data = new_data
	set_title(data.option_name)
	set_body(data.description)
	set_image(data.image)
	set_type(data.get_type_name(data.type))
	set_rarity(data.rarity)
	hover_method = new_hover_method
	
func set_title(text: String):
	title.text = text
func set_body(text: String):
	body.text = text
func set_type(text: String):
	type.text = text
func set_image(text: Texture2D):
	image.texture = text
func set_rarity(text: String):
	rarity.text = text
func connect_signal(new_method: Callable):
	method = new_method

func _on_button_pressed() -> void:
	if method:
		method.call(data)

func _mouse_entered() -> void:
	hover_method.call(data)
