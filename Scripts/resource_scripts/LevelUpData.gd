extends Node
class_name LevelUpData

var money: int

var option_name: String = "default"
var image: Texture2D
var color: Color
var border_color: Color = Color.WHITE_SMOKE
var description: String = "Default Description"
var type: types
enum types{new_component, new_item, component_upgrade, item_upgrade, money, super_upgrade}

## sets up the data using an ItemData
func set_itemdata(data:ItemData, new_type: types):
	option_name = data.item_name
	image = data.item_image
	color = data.item_color
	border_color = data.border_color
	description = data.item_description
## sets up the data via parameters
func set_data(new_name: String, new_image: Texture2D, new_color: Color, new_border_color: Color, new_description: String, new_type: types):
	option_name = new_name
	image = new_image
	color = new_color
	border_color = new_border_color
	description = new_description
	type = new_type
## sets up the data as a money level up option
func set_money(amount: int):
	money = amount
	option_name = "More Money!"
	image = load("res://Art/Misc/money.png")
	color = Color.GOLD
	border_color = Color.GOLDENROD
	description = "Gain " + str(amount) + " more money!"
	type = types.money
## this level up optin was chosen, carry out the level up, this method is polymorph
func carryout_level_up():
	GameManager.instance.money += money
