extends Control

const LEVEL_UP_ITEM = preload("uid://d3vs4t8t4nfr7")
@onready var LevelUpParent: VBoxContainer = $PanelContainer/VBoxContainer/LevelUpParent
@onready var stats_display: StatsDisplay = $PanelContainer2/StatsDisplay
var choice: LevelUpData
signal choice_made()
var showing_stats = null
var pause: UIManager.PauseItem
func set_pause(new_pause):
	pause = new_pause
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
	
	new_choice.set_data(data, hover_choice)
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
## If the choice has stats, display those stats (if it's a new item/component)
func hover_choice(data: LevelUpData):
	var stats = data.get_stats()
	if !stats == null:
		if !showing_stats == null:
			stats_display.clear_lists()
		showing_stats = stats
		stats_display.setup_substats(stats, stats.parent_object_name)
## Frees this object
func free_instance():
	for connection in choice_made.get_connections():
		disconnect("choice_made", connection)
	
	GameInstance.instance.ui_man.unpause(pause)
	queue_free()
