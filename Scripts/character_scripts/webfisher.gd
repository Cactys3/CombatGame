extends Character

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func set_stats():
	super()

func character_ability(number: int) -> void:
	match(number):
		1:
			pass#print("fizz ult!") #TODO: ability1
		2:
			#print("get off me ability!!") #TODO: ability2
			pass
		3:
			pass#print("dash!") #TODO: ability3

func on_level_up(new_level: float, old_level: float) -> void:
	pass

func on_gain_xp(new_xp: float, old_xp: float) -> void:
	pass

func on_gain_money(new_money: float, old_money: float) -> void:
	pass

func set_moving_animation(boolean: bool):
	pass
