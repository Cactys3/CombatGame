extends Button
class_name Toggle_UI

@export var StartDisabled: bool = false

const TOGGLE_UI_BUTTON_OFF = preload("res://Art/UI/ToggleUIButton_OFF.png")
const TOGGLE_UI_BUTTON_ON = preload("res://Art/UI/ToggleUIButton_ON.png")

@export var ui_to_hide: Array[Control]
var hide_ui: bool = false
var toggled_inventory: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("connect_signals")
	if StartDisabled:
		call_deferred("_toggled", true)
		toggled
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func connect_signals():
	#GameManager.instance.toggle_inventory.connect(toggle_inventory)
	pass

func toggle_inventory():
	toggled_inventory = !toggled_inventory
	

func _toggled(toggled_on: bool) -> void:
	hide_ui = toggled_on
	button_pressed = toggled_on # needed when called from not signal
	
	for ui in ui_to_hide:
		ui.visible = !toggled_on
		if toggled_on:
			ui.propagate_call("set", ["process_mode", PROCESS_MODE_DISABLED])
		else:
			ui.propagate_call("set", ["process_mode", PROCESS_MODE_INHERIT])
	
	if toggled_on:
		icon = TOGGLE_UI_BUTTON_OFF
	else:
		icon = TOGGLE_UI_BUTTON_ON
