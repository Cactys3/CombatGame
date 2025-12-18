extends Control

const LEVEL_UP_ITEM = preload("uid://d3vs4t8t4nfr7")
@onready var LevelUpParent: VBoxContainer = $PanelContainer/VBoxContainer/LevelUpParent
var choice: LevelUpData
signal choice_made()

## Add new choice option to UI
func add_choice(data: LevelUpData):
	var new_choice = LEVEL_UP_ITEM.instantiate()
	var hbox = HBoxContainer.new()
	var offset1 = Control.new()
	var offset2 = Control.new()
	
	LevelUpParent.add_child(hbox)
	hbox.add_child(offset1)
	hbox.add_child(new_choice)
	hbox.add_child(offset2)
	
	offset1.custom_minimum_size = Vector2(50, 0)
	offset2.custom_minimum_size = Vector2(50, 0)
	
	new_choice.set_data(data)
	new_choice.connect_signal(make_choice)
## Returns chosen LevelUpData
func get_choice() -> LevelUpData:
	await choice_made
	#print("made choice: " + str(choice.option_name))
	return choice
## Choice calls this method when its selected
func make_choice(data: LevelUpData):
	choice = data
	emit_signal("choice_made")
## Frees this object
func free_instance():
	for connection in choice_made.get_connections():
		disconnect("choice_made", connection)
	queue_free()
