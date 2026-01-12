extends Control
## Stays at (0, 0) even though it is part of the UI Window
## TODO: Is this resource hungry?
var first_move: bool = true
func _process(delta):
	## The first_move check allows us to get the parent node in proper (0, 0) position without breaking children node's positions
	if get_children().size() < 1:
		first_move = true
		return
	var man: GameManager = GameManager.instance
	var window: WindowManager = WindowManager.instance
	if man && window:
		## Move with game scene
		var offset = global_position - window.convert_small_position(Vector2(0, 0))
		global_position = window.convert_small_position(Vector2(0, 0))
		if first_move:
			first_move = false
			for child in get_children():
				if child is Control || child is Node2D:
					child.position += offset
