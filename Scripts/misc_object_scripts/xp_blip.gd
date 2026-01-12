extends ItemDrop

@onready var game_man: GameManager = get_tree().get_first_node_in_group("gamemanager")
@export var xp_value: float = 1

func touched_player():
	game_man.add_xp(xp_value)

func set_xp(value: float):
	xp_value = value
