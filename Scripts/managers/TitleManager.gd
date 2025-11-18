extends Node

@export var main: Control
@export var settings: Control 
@export var collection: Control 
@export var shop: Control 
@export var page_title: RichTextLabel 
@export var button_back: Button
@export var character_selection: Control 
@export var map_selection: Control 
@export var text_character: RichTextLabel
@export var text_map: RichTextLabel
@onready var choose_cat: Button = $"../Character_Selection/ScrollContainer/GridContainer/Choose_Cat"
@onready var choose_dog: Button = $"../Character_Selection/ScrollContainer/GridContainer/Choose_Dog"
@onready var choose_cow: Button = $"../Character_Selection/ScrollContainer/GridContainer/Choose_Cow"
@onready var choose_desert: Button = $"../Map_Selection/ScrollContainer/GridContainer/Choose_Desert"
@onready var choose_ocean: Button = $"../Map_Selection/ScrollContainer/GridContainer/Choose_Ocean"
@onready var choose_forest: Button = $"../Map_Selection/ScrollContainer/GridContainer/Choose_Forest"

var GAME_SCENE

var character: String ## Chosen character
var map: String ## Chosen map


var array: Array[Control] = [main, settings, collection, shop, character_selection, map_selection]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	set_process_unhandled_input(true)
	# For buttons specifically:
	process_mode = Node.PROCESS_MODE_INHERIT
	
	var window = get_window()
	## Set to saved screen size
	window.size = Vector2(1920, 1080)
	## Setup Titlescreen window settings (make sure to resetup when changing to game scene)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	window.move_to_center()
	set_main()
	
	print("connect signals")
	button_back.button_down.connect(set_main)
	print("Tree paused: ", get_tree().paused)
	
	GAME_SCENE = load("res://Scenes/Main/BaseScene.tscn")
	## Make sure file is created
	Save.create_file(0)
	
	print(Save.load_data(0, Save.TEST_FLOAT))
	print(Save.load_data(0, Save.TEST_INT))
	print(Save.load_data(0, Save.TEST_STRING))
	print(Save.load_data(0, Save.TEST_BOOL))
	
	Save.save_data(0, Save.TEST_FLOAT, 123)
	Save.save_data(0, Save.Arrows, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_character(new_char: String):
	character = new_char
	text_character.text = "Character: " + new_char
func set_map(new_map: String):
	map = new_map
	text_map.text = "Map: " + new_map

### UI Code
## Sets up main buttons to be visible
func set_main():
	print("Main")
	set_visible([main])
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
	set_visible([settings])
	page_title.text = "Settings"
## Go to Collection
func press_collection() -> void:
	print("collection")
	set_visible([collection])
	page_title.text = "Collection"
## Go to Shop
func press_shop() -> void:
	print("shop")
	set_visible([shop])
	page_title.text = "Shop"
## Go to Character Select
func press_character_select():
	print("character_select")
	set_visible([character_selection])
	page_title.text = "Character Selection"
## Go to Map Select
func press_map_select():
	print("map_select")
	set_visible([map_selection])
	page_title.text = "Map Selection"
## Go to Game Scene
func press_start_game():
	if GAME_SCENE == null:
		GAME_SCENE = load("res://Scenes/Main/BaseScene.tscn")
	# setup window for game
	var window = get_window()
	window.size = Vector2(3840, 2160)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	#change scene
	get_tree().current_scene.queue_free()
	var instance = GAME_SCENE.instantiate()
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance
	
	#get_tree().change_scene_to_file("res://Scenes/Main/BaseScene.tscn")
## Sets only parameter as visible
func set_visible(nodes: Array[Control]):
	main.visible = false
	settings.visible = false
	collection.visible = false
	shop.visible = false
	character_selection.visible = false
	map_selection.visible = false
	for node in nodes:
		node.visible = true
