extends Item

## Sets up a RightClickMenu for this component
func setup_right_click_menu(menu: RightClickMenu):
	menu.set_bools(false, false, true, false)

func is_forge() -> bool:
	return true
