extends Control
@export var label: RichTextLabel
@export var accept: Button 
@export var decline: Button 
@export var stats: StatsDisplay
signal decision_made
var decision: bool = false
func setup(new_stats: StatsResource):
	stats.setup_substats(new_stats, new_stats.parent_object_name)
	accept.pressed.connect(accept_method)
	decline.pressed.connect(decline_method)
func accept_method():
	decision = true
	decision_made.emit()
func decline_method():
	decision = false
	decision_made.emit()
