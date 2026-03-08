extends Node
class_name TitleManager
## Nodes
@export var main: Control
@export var settings: Control 
@export var collection: Control 
@export var shop: Control 
@export var page_title: RichTextLabel 
@export var button_back: Button
@export var character_selection: Control 
@export var map_selection: Control 
@export var weapon_selection: Control
@export var text_character: RichTextLabel
@export var text_map: RichTextLabel
@export var text_weapon: RichTextLabel
@export var achievement_parent: Control
@export var weapon_parent: Control
@export var item_parent: Control
static var file_slot: int = 0

const BaseScene: String = "res://Scenes/Main/BaseScene.tscn"
## Instances
var HELL: duple = duple.new("HELL", "res://Scenes/Instances/hell_instance.tscn")
var TEST: duple = duple.new("TEST", "res://Scenes/Instances/test_instance.tscn")
var FRUITS_AND_VEGGIES: duple = duple.new("FRUITS_AND_VEGGIES", "res://Scenes/Instances/fruits_and_veggies_instance.tscn")
## Characters [global_stats][character scene]
var WEBFISHER: duple = duple.new("res://Resources/Characters/webfisher_global_stats.tres", "res://Scenes/Characters/character.tscn")
## Weapons
var PISTOL: duple_int = duple_int.new("PISTOL", ShopManager.pistol_index)
var SWORD: duple_int = duple_int.new("SWORD", ShopManager.sword_index)
var FLAMETHROWER: duple_int = duple_int.new("FLAMETHROWER", ShopManager.flamethrower_index)
var RAILGUN: duple_int = duple_int.new("RAILGUN", ShopManager.railgun_index)
var ROCKETLAUNCHER: duple_int = duple_int.new("ROCKETLAUNCHER", ShopManager.rocketlauncher_index)
var MINIGUN: duple_int = duple_int.new("MINIGUN", ShopManager.minigun_index)
var PLAYINGCARD: duple_int = duple_int.new("PLAYINGCARD", ShopManager.playingcard_index)
var LIGHTNINGWAND: duple_int = duple_int.new("LIGHTNINGWAND", ShopManager.lightningwand_index)
## Choice Variables
var character: int ## Chosen character
var map: int ## Chosen map
var weapon: int ## Chosen weapon
var characters: Array[duple] = [WEBFISHER]
var maps: Array[duple] = [HELL, TEST, FRUITS_AND_VEGGIES]
var weapons: Array[duple_int] = [PISTOL, SWORD, FLAMETHROWER, RAILGUN, ROCKETLAUNCHER, MINIGUN, PLAYINGCARD, LIGHTNINGWAND]

var global_stats: StatsResource = StatsResource.BLANK_STATS.duplicate()

var array: Array[Control] = [main, settings, collection, shop, character_selection, map_selection]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## For testing:
	global_stats.setup("Globals")
	GameInstance.is_game_over = false
	
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
	
	#print("connect signals")
	button_back.button_down.connect(set_main)
	#print("Tree paused: ", get_tree().paused)

	## Make sure file is created
	call_deferred("save")
func save():
	if !Save.check_save_data(0):
		Save.create_file(0)
	Save.load_file(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

### UI Code
## Sets up main buttons to be visible
func set_main():
	#print("Main")
	set_visible([main])
	page_title.text = "Titlescreen"
## Return to previous screen
func press_back() -> void:
	#print("back")
	set_main()
## Go to Character Selection
func press_play() -> void:
	#print("play")
	press_character_select()
## Go to Settings
func press_settings() -> void:
	#print("setting")
	set_visible([settings])
	page_title.text = "Settings"
## Go to Collection
func press_collection() -> void:
	#print("collection")
	setup_achievements()
	set_visible([collection])
	page_title.text = "Collection"
## Go to Shop
func press_shop() -> void:
	#print("shop")
	set_visible([shop])
	page_title.text = "Shop"
## Go to Character Select
func press_character_select():
	#print("character_select")
	set_visible([character_selection])
	page_title.text = "Character Selection"
func press_weapon_select():
	#print("weapon_selection")
	set_visible([weapon_selection])
	page_title.text = "Weapon Select"
## Go to Map Select
func press_map_select():
	#print("map_select")
	set_visible([map_selection])
	page_title.text = "Map Selection"
## Go to Game Scene
func press_start_game():
	var window = get_window()
	window.size = Vector2(3840, 2160)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	#change scene
	get_tree().paused = true
	get_tree().current_scene.queue_free()
	
	var base_scene: Node2D = load(BaseScene).instantiate()
	var instance: GameInstance = setup_instance(base_scene)
	get_tree().root.add_child(base_scene)
	get_tree().current_scene = base_scene
## Creates Instance with Chosen Values
func setup_instance(base_scene) -> GameInstance:
	#print("Creating instance with Map: " + maps[map].key + ", Char: " + characters[character].key)
	var game_instance: GameInstance = get_instance()
	var chosen_character: Character = get_character()
	var chosen_weapon: int = get_weapon()
	setup_global_stats()
	base_scene.add_child(game_instance)
	base_scene.setup_instance(game_instance)
	game_instance.setup(chosen_character, chosen_weapon, global_stats, null)
	## 
	return game_instance
## Returns chosen instance
func get_instance() -> GameInstance:
	return load(maps[map].value).instantiate()
func get_character() -> Character:
	return load(characters[character].value).instantiate()
func get_weapon() -> int:
	return weapons[weapon].value
func set_map(index: int):
	if maps.size() > index:
		map = index
		text_map.text = "Map: " + maps[map].key
func set_character(index: int):
	if characters.size() > index:
		character = index
		text_character.text = "Character: " + characters[character].key
func set_weapon(index: int):
	if weapons.size() > index:
		weapon = index
		text_weapon.text = "Weapon: " + weapons[weapon].key
func setup_global_stats():
	global_stats = (load(characters[character].key))
	global_stats.setup(global_stats.parent_object_name)
## Sets only parameter as visible
func set_visible(nodes: Array[Control]):
	main.visible = false
	settings.visible = false
	collection.visible = false
	shop.visible = false
	character_selection.visible = false
	map_selection.visible = false
	weapon_selection.visible = false
	for node in nodes:
		node.visible = true
func _quickstart():
	character = 0
	map = 2
	weapon = 0
	press_start_game()
## Setup the achievements visual based on Save Data
func setup_achievements():
	for child in achievement_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	for child in weapon_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	for child in item_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	## Setup Achievements
	var first = true
	for a in Save.ACHIEVEMENTS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		achievement_parent.add_child(new_visual)
		new_visual.text = " " + str(a) + ": "
		if Save.ACHIEVEMENTS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.ACHIEVEMENTS_DICT[a]) + "[/color]"
			achievement_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.ACHIEVEMENTS_DICT[a]) + "[/color]"
			achievement_parent.move_child(new_visual, achievement_parent.get_child_count())
		setup_label(new_visual)
	## Setup Weapon Unlocks
	first = true
	for a in Save.WEAPON_UNLOCKS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		new_visual.text = " Unlocked " + str(a) + ": " 
		weapon_parent.add_child(new_visual)
		if Save.WEAPON_UNLOCKS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.WEAPON_UNLOCKS_DICT[a]) + "[/color]"
			weapon_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.WEAPON_UNLOCKS_DICT[a]) + "[/color]"
			weapon_parent.move_child(new_visual, weapon_parent.get_child_count())
		setup_label(new_visual)
	## Setup Item Unlocks
	first = true
	for a in Save.ITEM_UNLOCKS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		new_visual.text = " Unlocked " + str(a) + ": "
		item_parent.add_child(new_visual)
		if Save.ITEM_UNLOCKS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.ITEM_UNLOCKS_DICT[a]) + "[/color]"
			item_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.ITEM_UNLOCKS_DICT[a]) + "[/color]"
			item_parent.move_child(new_visual, item_parent.get_child_count())
		setup_label(new_visual)

func setup_label(label: RichTextLabel) -> RichTextLabel:
		label.bbcode_enabled = true
		label.fit_content = true
		label.scroll_active = false
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.add_theme_font_size_override("normal_font_size", 64)
		label.name += "delete_this"
		return label

class duple:
	var key: String
	var value: String
	func _init(new_key: String, new_value: String):
		key = new_key
		value = new_value
class duple_int:
	var key: String
	var value: int
	func _init(new_key: String, new_value: int):
		key = new_key
		value = new_value


func _on_choose_0_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.
