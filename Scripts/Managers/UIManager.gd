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
@export var relative_to_game_parent: Control
@export var top_level_labels_parent: Control
## Inventories
@export var AIOman: AIO_Manager
@export var cheat_inventory: Inventory 
## Other
@export var hud: HUD
var inventory: Inventory
var equipment: EquipmentInventory
var enabled: bool = true


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
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape_Menu"):
		escape_pressed()
	if Input.is_action_just_pressed("Tab_Menu"):
		tab_pressed()
func _connect_signals():
	pass#GameManager.instance.toggle_inventory.connect(toggle_inventory)
## Pause Queue
class PauseItem:
	func _init(UnpauseMethod: Callable, PauseType: PauseTypes, CanEscape: bool, ShowTab: bool, PauseParent: Control) -> void:
		unpause_method = UnpauseMethod
		type = PauseType
		can_escape = CanEscape
		show_tab = ShowTab
		pause_parent = PauseParent
	enum PauseTypes {gameplay, ui, level, tab, escape}
	var unpause_method: Callable
	var type: PauseTypes
	var can_escape: bool 
	var show_tab: bool
	var pause_parent: Control
	func get_priority() -> int:
		return type
var PauseQueue: Array[PauseItem]
var current_pause_item: PauseItem = null
## Pause Bools
var paused: bool = false ## Is Game Instance Paused or Not
var paused_for_esc: bool = false
var paused_for_tab: bool = false
var paused_for_level_up: bool = false
var paused_for_proximity: bool = false
var paused_for_misc: bool = false
## Pause Methods
## Called when Escape is pressed
func escape_pressed():
	if current_pause_item == null:
		## If no current pause, simply pause for escape menu
		print("current_pause_item == null")
		PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.escape, true, false, esc_menu_parent))
		next_pause_or_unpause()
	else:
		print("current_pause_item != null")
		if current_pause_item.can_escape:
			## If pressing escape should escape current pause, escape current pause
			print("current_pause_item.can_escape:")
			next_pause_or_unpause()
		else:
			print("!current_pause_item.can_escape:")
			## Press Esc while smth of lower priority is active = queue the other thing after new Esc pause
			PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.escape, true, false, esc_menu_parent))
			PauseQueue.append(current_pause_item)
			next_pause_or_unpause()
## Called when Escape is pressed
func tab_pressed():
	if current_pause_item == null:
		## If no current pause, simply pause for tab menu
		PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.tab, true, false, tab_menu_parent))
		next_pause_or_unpause()
	else:
		if PauseItem.PauseTypes.tab == current_pause_item.get_priority():
			## Press Tab while Tab is active = Deactivate Tab
			next_pause_or_unpause()
		elif PauseItem.PauseTypes.tab > current_pause_item.get_priority():
			## Press Tab while smth of lower priority is active = queue the other thing after tab
			if !current_pause_item.show_tab: ## And we aren't already showing tab
				PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.tab, true, false, tab_menu_parent))
				PauseQueue.append(current_pause_item)
				next_pause_or_unpause()
		else:
			pass ## Do Nothing if we are lower priority, don't want to queue a bunch of tab pauses
## Called when pausing for a given pause_item
func pause(pause_item: PauseItem):
	## We add the pause item to queue in all cases
	PauseQueue.append(pause_item)
	if current_pause_item == null:
		## If no current pause, simply pause for new pause_item
		next_pause_or_unpause()
	else:
		if PauseItem.PauseTypes.tab > current_pause_item.get_priority():
			## Pause while smth of lower priority is active = queue the other thing after new pause
			PauseQueue.append(current_pause_item)
			next_pause_or_unpause()
		else:
			pass ## We already Queued the pause item
## Called when wishing to unpause, checks PauseQueue first
func next_pause_or_unpause():
	if current_pause_item:
		current_pause_item.pause_parent.visible = false
		current_pause_item.pause_parent.propagate_call("set", ["process_mode", PROCESS_MODE_DISABLED])
		## If PauseQueue.has(current_pause_item), then that pause isn't removed, just postponed, so don't call it's 'delete pause' method
		if !PauseQueue.has(current_pause_item) && current_pause_item.unpause_method != null && current_pause_item.unpause_method.is_valid():
			current_pause_item.unpause_method.call()
		current_pause_item = null
	if PauseQueue.is_empty():
		GameManager.instance.pause(false)
		tab_menu_parent.visible = false ## always hide tab because some pauses show it 
	else:
		var priority_item = PauseQueue[0]
		for item in PauseQueue:
			if item.get_priority() > priority_item.get_priority():
				priority_item = item
		priority_item.pause_parent.visible = true
		priority_item.pause_parent.propagate_call("set", ["process_mode", PROCESS_MODE_ALWAYS])
		current_pause_item = priority_item
		if current_pause_item.show_tab:
			tab_menu_parent.visible = true
			tab_menu_parent.propagate_call("set", ["process_mode", PROCESS_MODE_ALWAYS])
		if current_pause_item.pause_parent.get_parent() == self:
			## Maybe this is good, or maybe they should have permanent heiarchy.
			#move_child(current_pause_item.pause_parent, max(0, get_child_count() - 1))
			pass
		PauseQueue.erase(priority_item)
		GameManager.instance.pause(true)
## Called to unpause or remove pause_item from PauseQueue
func unpause(pause_item: PauseItem):
	if pause_item == null:
		return
	if current_pause_item == pause_item:
		current_pause_item = null
		next_pause_or_unpause()
	elif PauseQueue.has(pause_item):
		PauseQueue.erase(pause_item)

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
