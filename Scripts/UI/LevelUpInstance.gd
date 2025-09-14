extends Control


@onready var b1: Button = $PanelContainer/VBoxContainer/Button1
@onready var b2: Button = $PanelContainer/VBoxContainer/Button2
@onready var b3: Button = $PanelContainer/VBoxContainer/Button3
var b1_data: LevelUpData
var b2_data: LevelUpData
var b3_data: LevelUpData

var choice: LevelUpData

signal choice_made()

func _ready() -> void:
	pass 

func setup(button_num: int, data: LevelUpData):
	match(button_num):
		1:
			b1_data = data
			b1.text = data.option_name
		2:
			b2_data = data
			b2.text = data.option_name
		_:
			b3_data = data
			b3.text = data.option_name


func get_choice() -> LevelUpData:
	await choice_made
	print("made choice: " + str(choice))
	return choice

func b3_pressed() -> void:
	choice = b3_data
	emit_signal("choice_made")

func b2_pressed() -> void:
	choice = b2_data
	emit_signal("choice_made")

func b1_pressed() -> void:
	choice = b1_data
	emit_signal("choice_made")

func free_instance():
	for connection in choice_made.get_connections():
		disconnect("choice_made", connection)
	queue_free()
