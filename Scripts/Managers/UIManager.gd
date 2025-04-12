extends Node2D
class_name UIManager

@export var money_label: Label
@export var xp_label: Label
@export var level_label: Label

#@export var tab_container: TabContainer
@export var shop: Inventory
@export var inventory: Inventory

var enabled: bool = true

func _ready() -> void:
	call_deferred("_connect_signals")

func _connect_signals():
	GameManager.instance.toggle_inventory.connect(toggle_inventory)

func toggle_inventory() -> void:
	print("toggle")
	enabled = !enabled
	visible = enabled
	#propagate_call("set", ["visible", enabled])
	if enabled:
		propagate_call("set", ["process_mode", PROCESS_MODE_INHERIT])
		pass
		#tab_container.get_current_tab_control().visible = false
		#set_mouse_filter_recursive(MouseFilter.MOUSE_FILTER_PASS)
	else:
		propagate_call("set", ["process_mode", PROCESS_MODE_DISABLED])
		pass#set_mouse_filter_recursive(MouseFilter.MOUSE_FILTER_IGNORE)

func set_level(value: String) -> void:
	level_label.text = value

func set_xp(value: String) -> void:
	xp_label.text = value

func set_money(value: String) -> void:
	money_label.text = value

func add_shop_items(items: Array[ItemUI]) -> void:
	if enabled:
		for item in items:
			var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
			i.set_item(item)
			shop.add(item)

func _process(delta: float) -> void: 
	pass
