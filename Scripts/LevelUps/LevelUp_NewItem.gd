extends LevelUpData

func carryout_level_up():
	itemdata.make_item()
	GameManager.instance.add_item_to_player(itemdata.get_item())
