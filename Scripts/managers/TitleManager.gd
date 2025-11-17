extends Node

@export var main: Control
@export var settings: Control 
@export var collection: Control 
@export var shop: Control 
@export var page_title: RichTextLabel 
@export var button_back: Button
@export var character_selection: Control 
@export var map_selection: Control 
const GAME_SCENE = preload("res://Scenes/Main/BaseScene.tscn")



var array: Array[Control] = [main, settings, collection, shop, character_selection, map_selection]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window = get_window()
	## Set to saved screen size
	window.size = Vector2(1920, 1080)
	## Setup Titlescreen window settings (make sure to resetup when changing to game scene)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	window.move_to_center()
	set_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
## Sets up main buttons to be visible
func set_main():
	print("Main")
	main.visible = true
	settings.visible = false
	collection.visible = false
	shop.visible = false
	button_back.visible = true
	page_title.text = "Titlescreen"
## Return to previous screen
func press_back() -> void:
	print("back")
	set_main()
## Go to Character Selection
func press_play() -> void:
	print("play")
	press_character_select()
## Go to Settings
func press_settings() -> void:
	print("setting")
	main.visible = false
	settings.visible = true
	collection.visible = false
	shop.visible = false
	button_back.visible = true
	page_title.text = "Settings"
## Go to Collection
func press_collection() -> void:
	print("collection")
	main.visible = false
	settings.visible = false
	collection.visible = true
	shop.visible = false
	button_back.visible = true
	page_title.text = "Collection"
## Go to Shop
func press_shop() -> void:
	print("shop")
	main.visible = false
	settings.visible = false
	collection.visible = false
	shop.visible = true
	button_back.visible = true
	page_title.text = "Shop"
## Go to Character Select
func press_character_select():
	pass
## Go to Map Select
func press_map_select():
	pass
## Go to Game Scene
func press_start_game():
	pass

func set_visible(nodes: Array[Control]):
	
	for node in nodes:
		node.visible = true
