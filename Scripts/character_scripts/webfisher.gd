extends Player_Script

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func set_stats():
	# TODO: later make these a seperate stats instance that affects the global stats inside game manager so these affect the weapons too
	player_stats.set_stat_base(StatsResource.HP, 100)
	player_stats.set_stat_base(StatsResource.STANCE, 0)
	player_stats.set_stat_base(StatsResource.MOVESPEED, 200)
	player_stats.set_stat_base(StatsResource.XP, 1)
	player_stats.set_stat_base(StatsResource.MOGUL, 1)
	player_stats.set_stat_base(StatsResource.LUCK, 0)
	super()

func character_ability(number: int) -> void:
	match(number):
		1:
			print("fizz ult!") #TODO: ability1
		2:
			print("get off me ability!!") #TODO: ability2
		3:
			print("dash!") #TODO: ability3

func on_level_up(new_level: float, old_level: float) -> void:
	pass

func on_gain_xp(new_xp: float, old_xp: float) -> void:
	pass

func on_gain_money(new_money: float, old_money: float) -> void:
	pass

func set_moving_animation(boolean: bool):
	pass
