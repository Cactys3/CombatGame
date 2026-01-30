extends LevelUpData

func carryout_level_up():
	## Component is part of weapon
	## We need to take the ItemData of the component, add a level to it, and then recreate the component with that change
	itemdata.upgrade_rarity()
