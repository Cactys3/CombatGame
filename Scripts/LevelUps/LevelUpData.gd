extends Node
class_name LevelUpData

var money: int

var option_name: String = "default"
var image: Texture2D
var color: Color
var border_color: Color = Color.WHITE_SMOKE
var description: String = "Default Description"
var rarity: String
var level: int
var type: types
enum types{new_component, new_item, component_level, item_level, weapon_level, special}
var itemdata: ItemData 
var LevelUpgrades: Array[ItemData.LevelUpgrade] 
## sets up the data using an ItemData
func set_itemdata(data:ItemData, new_type: types):
	option_name = data.item_name
	image = data.item_image
	color = data.item_color
	border_color = data.border_color
	description = data.item_description
	rarity = ItemData.get_rarity(data.item_rarity)
	level = data.level
	itemdata = data
	type = new_type
	match(new_type):
		types.new_component:
			option_name = option_name
		types.new_item:
			option_name = option_name 
		types.component_level: 
			_setup_level_upgrade(data)
		types.item_level: 
			_setup_level_upgrade(data)
		_:
			option_name =  "misc: " + option_name
func _setup_level_upgrade(data:ItemData):
	LevelUpgrades = data.get_level_upgrades()
	option_name = "Level Up: " + option_name + " " + str(level) + " --> " + str(level + 1)
	description = ""
	var total_rarities: float = 0
	var rarities_count: int = 0
	for upgrade: ItemData.LevelUpgrade in LevelUpgrades:
		rarities_count += 1
		total_rarities += upgrade.rarity
		var start: String
		var stat: String
		var end: String = " "
		if upgrade.factor:
			start = "% Bonus " + upgrade.name.capitalize() + ": "
			stat = round2(data.stats.get_stat_factor(upgrade.name)) + " --> " + round2(data.stats.get_stat_factor(upgrade.name) + upgrade.value)
		else:
			start = upgrade.name.capitalize() + ": "
			stat = round2(data.stats.get_stat_base(upgrade.name)) + " --> " + round2(data.stats.get_stat_base(upgrade.name) + upgrade.value)
		if upgrade.value != 0:
			description += start + colorize(stat, upgrade.rarity) + end + "\n"
	## Not using total rarities rn
	#rarity = ItemData.get_rarity(roundi(total_rarities / rarities_count) as ItemData.item_rarities)
## sets up the data via parameters
func set_data(new_name: String, new_image: Texture2D, new_color: Color, new_border_color: Color, new_description: String, new_type: types):
	option_name = new_name
	image = new_image
	color = new_color
	border_color = new_border_color
	description = new_description
	type = new_type
## this level up optin was chosen, carry out the level up, this method is polymorph
func carryout_level_up():
	#print("CHOSE CHOICE: " + str(type))
	match(type):
		types.component_level:
			carryout_component_level()
		types.item_level:
			carryout_item_level()
		types.new_component:
			carryout_new_component()
		types.new_item:
			carryout_new_item()
		_:
			carryout_money()
func carryout_money():
	#print("MORE MONEY")
	#print("MORE MONEY")
	#print("MORE MONEY")
	#print("MORE MONEY")
	GameManager.instance.money += money
func carryout_component_rarity():
	#print("COMPONENT RARITY! from: " + str(itemdata.item_rarity))
	itemdata.upgrade_rarity()
	#print("COMPONENT RARITY! to: " + str(itemdata.item_rarity))
func carryout_component_level():
	#print("COMPONENT LEVEL! from: " + str(itemdata.level))
	itemdata.upgrade_level(LevelUpgrades)
	#print("COMPONENT LEVEL! to: " + str(itemdata.level))
func carryout_item_level():
	#print("COMPONENT LEVEL! from: " + str(itemdata.level))
	itemdata.upgrade_level(LevelUpgrades)
	#print("COMPONENT LEVEL! to: " + str(itemdata.level))
func carryout_item_rarity():
	#print("ITEM RARITY! from: " + str(itemdata.item_rarity))
	itemdata.upgrade_rarity()
	#print("ITEM RARITY! to: " + str(itemdata.item_rarity))
func carryout_new_item():
	itemdata.make_item()
	GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(itemdata))#GameManager.instance.ui_man.equipment.backend_add(ShopManager.make_itemUI(itemdata))
func carryout_new_component():
	itemdata.make_item()
	GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(itemdata))

func get_stats() -> StatsResource:
	if itemdata:
		return itemdata.get_stats()
	else:
		return null

const new_component_weight_base: float = 0.1
const new_item_weight_base: float = 0.1
const component_levelup_weight_base: float = 1
const item_levelup_weight_base: float = 1
const weapon_levelup_weight_base: float = 0.05
## The meaty function that decides what the level up option will be 
static func get_random_level_up_option(other_options: Array[LevelUpData]) -> LevelUpData:
	var game_man: GameManager = GameManager.instance
	## Set to base weights
	var new_component_weight: float = new_component_weight_base
	var new_item_weight: float = new_item_weight_base
	var component_levelup_weight: float = component_levelup_weight_base
	var item_levelup_weight: float = item_levelup_weight_base
	var weapon_levelup_weight: float = weapon_levelup_weight_base
	## Get Weight Factors
	var weapon_capacity_percent: float = float(game_man.weapon_count) / float(game_man.weapon_limit)
	var component_count: float = game_man.ui_man.inventory.component_count + game_man.ui_man.equipment.component_count
	var weapon_count: float = game_man.ui_man.inventory.weapon_count + game_man.ui_man.equipment.weapon_count
	var item_count: float = game_man.ui_man.inventory.item_count + game_man.ui_man.equipment.item_count
	## Add weight factors
	## Increase Chance to gain component if own few components
	new_component_weight = new_component_weight + (2.0 / (component_count + 2.0)) ## count = 1 -> 2.33, count = 5 -> 1
	new_item_weight = new_item_weight + (2.0 / (new_item_weight + 2.0))
	component_levelup_weight += game_man.ui_man.equipment.weapon_count
	item_levelup_weight += item_count / 3
	var component_level_count: int = 0
	var item_level_count: int = 0
	## Factor in other options
	for option in other_options:
		if option.type == types.new_component:
			new_component_weight = max(new_component_weight - 2.5, 0.1)
		if option.type == types.new_item:
			new_item_weight = max(new_item_weight - 3.0, 0.1)
		if option.type == types.component_level:
			component_level_count += 1
			component_levelup_weight = max(component_levelup_weight - 1.0, 0.1)
		if option.type == types.item_level:
			item_level_count += 1
			item_levelup_weight = max(item_levelup_weight - 1.0, 0.1)
	## Set zero if impossible
	weapon_levelup_weight = 0 ## not used
	if game_man.ui_man.equipment.weapon_count == 0:
		component_levelup_weight = 0
	if game_man.ui_man.equipment.item_count == 0:
		item_levelup_weight = 0
	if !game_man.has_item_room():
		new_item_weight = 0
	if component_level_count >= 3.0 && component_level_count / 3.0 >= game_man.ui_man.equipment.weapon_count:
		## If we already have component level ups equal to the number of components equipped, there are no more components to level up without duplicate options
		component_levelup_weight = 0
	if item_level_count >= 1.0 && item_level_count >= game_man.ui_man.equipment.item_count:
		## If we already have item level ups equal to the number of item equipped, there are no more item to level up without duplicate options
		item_levelup_weight = 0
	## Roll and Return
	var array: Array[float] = [new_component_weight, new_item_weight, component_levelup_weight, item_levelup_weight, weapon_levelup_weight]
	var total_weight: float = 0
	for item in array:
		total_weight += item
	var roll: float = randf_range(0, total_weight)
	var running_total: float = 0
	if true:
		print("New Comp: " + str(new_component_weight))
		print("New Item: " + str(new_item_weight))
		print("Comp Up: " + str(component_levelup_weight))
		print("Item Up: " + str(item_levelup_weight))
		print("Weapon Up: " + str(weapon_levelup_weight))
	running_total += new_component_weight
	if running_total >= roll:
		return get_new_component_upgrade()
	running_total += new_item_weight
	if running_total >= roll:
		return get_new_item_upgrade()
	running_total += component_levelup_weight
	if running_total >= roll:
		return get_component_level_upgrade(other_options)
	running_total += item_levelup_weight
	if running_total >= roll:
		return get_item_level_upgrade(other_options)
	running_total += weapon_levelup_weight
	if running_total >= roll:
		return get_weapon_level_upgrade()
	return get_new_item_upgrade()

static func get_component_level_upgrade(other_upgrades: Array[LevelUpData]) -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	var comp: ItemData
	var avoided_items: Array[ItemData] = []
	for upgrade in other_upgrades:
		if upgrade.type == types.component_level:
			avoided_items.append(upgrade.itemdata)
	if avoided_items.is_empty():
		comp = GameManager.instance.get_random_equipped_comp()
	else:
		comp =  GameManager.instance.get_random_equipped_comp_except(avoided_items)
	if comp == null:
		printerr("Called get_component_level_upgrade() whilst had already made upgrade options for all avaliable components")
		## Fallback to item level upgrade
		return get_item_level_upgrade(other_upgrades)
	
	levelupdata.set_itemdata(comp, types.component_level)
	return levelupdata
static func get_item_level_upgrade(other_upgrades: Array[LevelUpData]) -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	var avoided_items: Array[ItemData] = []
	for upgrade in other_upgrades:
		if upgrade.type == types.item_level:
			avoided_items.append(upgrade.itemdata)
	var item: ItemData 
	if avoided_items.is_empty():
		item = GameManager.instance.get_random_equipped_item()
	else:
		item = GameManager.instance.get_random_equipped_item_except(avoided_items)
	if item == null:
		printerr("Called get_item_level_upgrade() whilst had already made upgrade options for all avaliable components")
		## Fallback to new item upgrade
		return get_new_item_upgrade()
	levelupdata.set_itemdata(item, types.item_level)
	return levelupdata
static func get_weapon_level_upgrade() -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	levelupdata.set_itemdata(GameManager.instance.get_random_equipped_weapon(), types.weapon_level)
	return levelupdata
static func get_new_item_upgrade() -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	levelupdata.set_itemdata(ShopManager.get_rand_item(), LevelUpData.types.new_item)
	return levelupdata
static func get_new_component_upgrade() -> LevelUpData:
	var levelupdata: LevelUpData = LevelUpData.new()
	levelupdata.set_itemdata(ShopManager.get_rand_component(), LevelUpData.types.new_component)
	return levelupdata

## Returns RichText colorized based on rarity
func colorize(text: String, rarity: ItemData.item_rarities) -> String:
	var textcolor
	match rarity:
		ItemData.item_rarities.common:
			textcolor = ItemData.COMMON_COLOR.to_html(false)
		ItemData.item_rarities.rare:
			textcolor = ItemData.RARE_COLOR.to_html(false)
			text = tornado(text)
		ItemData.item_rarities.epic:
			textcolor = ItemData.EPIC_COLOR.to_html(false)
			text = pulse(text)
		ItemData.item_rarities.legendary:
			textcolor = ItemData.LEGENDARY_COLOR.to_html(false)
			text = wave(text)
		ItemData.item_rarities.exclusive:
			textcolor = ItemData.EXCLUSIVE_COLOR.to_html(false)
			text = shake(text)
	text = "[color=%s]" % ("#" + textcolor) + text + "[/color]"
	#text = wave(text)
	#text = pulse(text)
	#text = tornado(text)
	#text = shake(text)
	text = "" + text + ""
	return text
func pulse(text: String) -> String:
	return "[pulse freq=2.0 color=#blue ease=-1.0]" + text + "[/pulse]"
func wave(text: String) -> String:
	return "[wave amp=5.0 freq=2.0 connected=1]" + text + "[/wave]"
func tornado(text: String) -> String:
	return "[tornado radius=2.0 freq=0.5 connected=1]" + text + "[/tornado]" 
func shake(text: String) -> String:
	return "[shake rate=20.0 level=5 connected=1]" + text + "[/shake]" 

func round2(num: float) -> String:
	return StatsResource.round_to_digits(num, 5)
	#return round(num * pow(10, 2)) / pow(10, 2)

func get_type_name(given_type: int) -> String:
	match given_type:
		types.new_component:
			return "New Component!"
		types.new_item:
			return "New Item!"
		types.component_level:
			return "Level Up!"
		types.item_level:
			return "Level Up!"
		types.weapon_level:
			return "Weapon Level Up!"
		types.special:
			return "Special Upgrade!"
		_:
			return "ね。。。"
