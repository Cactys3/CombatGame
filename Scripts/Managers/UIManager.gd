extends Node2D
class_name UIManager

@export var money_label: Label
@export var xp_label: Label
@export var level_label: Label
@export var hp_label: Label
@export var fps_label: Label
@export var stopwatch_label: Label
@export var enemies_killed_label: Label
@export var bosses_killed_label: Label

@export var you_win: Label

@export var tab_menu_parent: Control
@export var esc_menu_parent: Control
@export var level_up_parent: Control
@export var static_ui_parent: Control
@export var misc_parent: Control

## FOR TESTING:
@export var shop: Inventory
@export var storage: Inventory
@export var cheat_inventory: Inventory
@export var equipment: Inventory
var enabled: bool = true

var paused: bool = false ## Is Game Instance Paused or Not
var paused_for_esc: bool = false
var paused_for_tab: bool = false
var paused_for_level_up: bool = false
var paused_for_proximity: bool = false
var paused_for_misc: bool = false

signal delete_proximity

func _ready() -> void:
	call_deferred("_connect_signals")
	process_mode = Node.PROCESS_MODE_ALWAYS

func _connect_signals():
	GameManager.instance.toggle_inventory.connect(toggle_inventory)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape_Menu"):
		pause_esc()
	if Input.is_action_just_pressed("Tab_Menu"):
		if paused_for_proximity:
			pause_proximity(false)
		else:
			pause_tab()
## paused for esc overwrites any other pauses
func pause_esc() -> bool:
	paused_for_esc = !paused_for_esc
	GameManager.instance.toggle_esc.emit()
	if paused_for_esc:
		if tab_menu_parent.visible:
			GameManager.instance.toggle_inventory.emit()
		esc_menu_parent.visible = true
		level_up_parent.visible = false
		GameManager.instance.pause(true)
		paused = paused_for_esc
	else:
		esc_menu_parent.visible = false
		if paused_for_level_up:
			level_up_parent.visible = true
		elif paused_for_tab:
			GameManager.instance.emit_signal("toggle_inventory")
		elif paused_for_proximity:
			GameManager.instance.emit_signal("toggle_inventory")
		else:
			GameManager.instance.pause(false)
			paused = paused_for_esc
	return true
## paused for proximity stuff overwrites not many
func pause_proximity(b: bool) -> bool:
	paused_for_proximity = b
	if paused_for_esc:
		return false
	if paused_for_level_up:
		return false
	if paused_for_tab:
		paused_for_tab = false
	paused = paused_for_proximity
	GameManager.instance.pause(paused_for_proximity)
	if paused_for_proximity:
		if !tab_menu_parent.visible:
			GameManager.instance.toggle_inventory.emit()
	else:
		delete_proximity.emit()
		GameManager.instance.toggle_inventory.emit()
	return true
## paused for tab loses to everything
func pause_tab() -> bool:
	if paused && !paused_for_tab:
		return false
	paused_for_tab = !paused_for_tab
	paused = paused_for_tab
	GameManager.instance.pause(paused_for_tab)
	if paused_for_tab:
		GameManager.instance.toggle_inventory.emit()
	else:
		GameManager.instance.toggle_inventory.emit()
	return true
## paused for level up overwrites tab, but can be paused by pause for esc
func pause_level_up() -> bool:
	paused_for_level_up = !paused_for_level_up
	if paused_for_esc:
		return false
	paused = paused_for_level_up
	if paused_for_level_up:
		GameManager.instance.pause(true)
		level_up_parent.visible = true
		if tab_menu_parent.visible:
			GameManager.instance.toggle_inventory.emit()
	else:
		level_up_parent.visible = false
		if paused_for_tab:
			GameManager.instance.emit_signal("toggle_inventory")
		else:
			GameManager.instance.pause(false) # only unpause if no other pauses active
	return true
## paused for misc waits for other pauses to be done
func pause_misc(value: bool):
	paused_for_misc = value
	if paused_for_esc:
		return false
	if paused_for_level_up:
		return false
	if paused_for_tab:
		return false
	paused = paused_for_misc
	GameManager.instance.pause(paused_for_misc)
	if paused_for_misc:
		misc_parent.visible = true
	else:
		misc_parent.visible = false
	return true
##
func reset():
	pause_misc(paused_for_misc)
	pause_proximity(paused_for_proximity)

func toggle_inventory() -> void:
	tab_menu_parent.visible = !tab_menu_parent.visible
	if tab_menu_parent.visible:
		tab_menu_parent.propagate_call("set", ["process_mode", PROCESS_MODE_ALWAYS])
	else:
		tab_menu_parent.propagate_call("set", ["process_mode", PROCESS_MODE_DISABLED])

func set_level(value: String) -> void:
	level_label.text = value

func set_hp(value: String) -> void:
	hp_label.text = value

func set_xp(value: String) -> void:
	xp_label.text = value

func set_money(value: String) -> void:
	money_label.text = value

func set_stopwatch(value: String) -> void:
	stopwatch_label.text = value

func set_fps(value: String) -> void:
	fps_label.text = value

func toggle_you_win(value: bool) -> void:
	you_win.visible = value

func add_shop_items(items: Array[ItemData]) -> void:
	if enabled:
		for item in items:
			var item_ui: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
			item_ui.set_item(item)
			shop.add(item_ui)
