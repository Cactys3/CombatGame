extends Node
class_name LevelUpData

var money: int

var option_name: String = "default"
var image: Texture2D
var color: Color
var border_color: Color = Color.WHITE_SMOKE
var description: String = "Default Description"
var type: types
enum types{new_component, new_item, component_rarity, component_level, item_rarity, item_level, money, weapon_upgrade, special}
var itemdata: ItemData = null
## sets up the data using an ItemData
func set_itemdata(data:ItemData, new_type: types):
	option_name = data.item_name
	image = data.item_image
	color = data.item_color
	border_color = data.border_color
	description = data.item_description
	itemdata = data
	type = new_type
	match(new_type):
		types.component_rarity:
			option_name = "upgrade rarity of: " + option_name
		types.item_rarity:
			option_name = "upgrade rarity of: " + option_name
		types.new_component:
			option_name = "gain new component: " + option_name
		types.new_item:
			option_name = "gain new item: " + option_name
		_:
			option_name =  "misc: " + option_name
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
	print("CHOSE CHOICE: " + str(type))
	match(type):
		types.money:
			carryout_money()
		types.component_rarity:
			carryout_component_rarity()
		types.item_rarity:
			carryout_item_rarity()
		types.component_level:
			pass
		types.item_level:
			pass 
		types.new_component:
			carryout_new_component()
		types.new_item:
			carryout_new_item()
		types.weapon_upgrade:
			pass
		_:
			carryout_money()
func carryout_money():
	print("MORE MONEY")
	print("MORE MONEY")
	print("MORE MONEY")
	print("MORE MONEY")
	GameManager.instance.money += money
func carryout_component_rarity():
	print("COMPONENT RARITY! from: " + str(itemdata.item_rarity))
	itemdata.upgrade_component_rarity()
	print("COMPONENT RARITY! to: " + str(itemdata.item_rarity))
func carryout_item_rarity():
	print("ITEM RARITY! from: " + str(itemdata.item_rarity))
	itemdata.upgrade_component_rarity()
	print("ITEM RARITY! to: " + str(itemdata.item_rarity))
func carryout_new_item():
	print("NEW ITEM: " + itemdata.item_name)
	print("NEW ITEM: " + itemdata.item_name)
	print("NEW ITEM: " + itemdata.item_name)
	itemdata.make_item()
	GameManager.instance.ui_man.storage.new_add(ShopManager.make_itemUI(itemdata))#GameManager.instance.ui_man.equipment.new_add(ShopManager.make_itemUI(itemdata))
func carryout_new_component():
	print("NEW COMPONENT: " + itemdata.item_name)
	print("NEW COMPONENT: " + itemdata.item_name)
	print("NEW COMPONENT: " + itemdata.item_name)
	itemdata.make_item()
	GameManager.instance.ui_man.storage.new_add(ShopManager.make_itemUI(itemdata))

static func get_random_level_up_option() -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	var money: int
	match(randi_range(0, 4)):
		
		0: ## gain random money
			money = randi_range(20, 50)
			levelupdata.set_money(money)
		
		1: ## upgrade random component's rarity
			var comp: ItemData = GameManager.instance.get_random_equipped_weapon().data
			if comp != null:
				levelupdata.set_itemdata(comp, types.component_rarity)
				print("weapon: " + comp.item_name)
			else:
				money = randi_range(20, 50) ## TODO: try again if failed?
				levelupdata.set_money(money)
				print("money as backup due to no equipped weapons")
		
		2:
			if GameManager.instance.get_random_equipped_item() != null:
				var item: ItemData = GameManager.instance.get_random_equipped_item().data
				levelupdata.set_itemdata(item, types.item_rarity)
				print("item: " + item.item_name)
			else:
				money = randi_range(20, 50) ## TODO: try again if failed?
				levelupdata.set_money(money)
				print("money as backup due to no equipped items")
		
		3:
			var item: ItemData = ShopManager.get_rand_component()
			levelupdata.set_itemdata(item, LevelUpData.types.new_component)
			print("NEW COMPONENT!")
		
		4:
			## gain random new item
			var item: ItemData = ShopManager.get_rand_item()
			levelupdata.set_itemdata(item, LevelUpData.types.new_item)
			print("NEW ITEM!")
		
		_:
			money = randi_range(20, 50)
			levelupdata.set_money(money) ## Implement others
	return levelupdata
