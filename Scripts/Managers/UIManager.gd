extends Control
class_name UIManager
## Labels
@export var money_label: Label
@export var xp_label: Label
@export var level_label: Label
@export var hp_label: Label
@export var fps_label: Label
@export var stopwatch_label: Label
@export var enemies_killed_label: Label
@export var bosses_killed_label: Label
@export var you_win: Label
## Parents
@export var tab_menu_parent: Control
@export var esc_menu_parent: Control
@export var level_up_parent: Control
@export var static_ui_parent: Control
@export var misc_parent: Control
## Inventories
@export var AIOman: AIO_Manager
@export var cheat_inventory: Inventory 
## Other
@export var hud: HUD
var inventory: Inventory
var equipment: EquipmentInventory
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
	inventory = AIOman.inventory
	equipment = AIOman.equipment
	if tab_menu_parent.visible:
		tab_menu_parent.visible = false
	if esc_menu_parent.visible:
		esc_menu_parent.visible = false
	if misc_parent.visible:
		misc_parent.visible = false

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
		if tab_menu_parent.visible:
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

func set_max_hp(percent: float) -> void:
	hud.set_max_hp(percent)

func set_shield(value: String, percent: float) -> void:
	hud.set_shield(percent)

func set_hp(value: String, percent: float) -> void:
	hp_label.text = value
	hud.set_hp(percent)
	
func set_xp(value: String, percent: float) -> void:
	xp_label.text = value
	hud.set_xp(percent)

func set_money(value: float) -> void:
	money_label.text = str(roundi(value))
	hud.set_money(value)

func set_stopwatch(value: float) -> void:
	stopwatch_label.text = str(int(value / 60)) + ":" + str(int(fmod(value, 60.0)))
	hud.set_time(value)

func set_kills(value: float) -> void:
	hud.set_kills(value)
	enemies_killed_label.text = str(value)

func set_fps(value: float) -> void:
	fps_label.text = str(roundi(value))

func toggle_you_win(value: bool) -> void:
	you_win.visible = value
