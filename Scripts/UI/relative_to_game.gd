extends Control
## Stays at (0, 0) even though it is part of the UI Window
## TODO: Is this resource hungry?
func _process(delta):
	if get_children().size() < 1:
		return
	var man: GameManager = GameManager.instance
	var window: WindowManager = WindowManager.instance
	if man && window:
		## Move with game scene
		global_position = window.convert_small_position(Vector2(0, 0))
