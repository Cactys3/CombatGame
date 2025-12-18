extends Node
class_name Save
## Dictionaries of all save data with default values as values and data names as keys
const defaults = [TEST_DICT, TEST2_DICT, WEAPON_UNLOCKS_DICT, ITEM_UNLOCKS_DICT, MAP_UNLOCKS_DICT, CHARACTER_UNLOCKS_DICT, SHOP_DICT, ACHIEVEMENTS_DICT]
const TEST_DICT = {
	"# Test": "# Test",
	TEST_INT: "12313112",
	TEST_STRING: "string TGESTmo f-af3さ",
	TEST_FLOAT: 3.2340,
	TEST_BOOL: false}
const TEST2_DICT = {
	"# Test2": "# Test2",
	"custom test1": "32awef4",
	"custom test2": "32awef4",
	"custom test3": "3asd24",
	"custom test4": "3zxcv24"}
const WEAPON_UNLOCKS_DICT = {
	"# Weapon-Unlocks": "# Weapon-Unlocks",
	FlameThrower: false,
	Boomerang: false,
	Gravity: false,
	IceShardWand: false,
	LightningWand: false,
	Minigun: false,
	Pistol: true,
	PlayingCards: false,
	Railgun: false,
	RocketLauncher: false,
	Sword: true}
const ITEM_UNLOCKS_DICT = {
	"# Item-Unlocks": "# Item-Unlocks",
	Arrows: false,
	Bloodlust: false,
	DamageBuff: false,
	Flattery: false,
	GoldGenerator: false,
	Marksman: false,
	ProjectileDuplicator: false,
	RandomStat: false,
	ScaredSpeedster: false,
	SorcerersEgo: false,
	SpontaneousCombustion: false,
	Turrets: false}
const MAP_UNLOCKS_DICT = {
	"# Map-Unlocks": "# Map-Unlocks",
	Plains: true}
const CHARACTER_UNLOCKS_DICT = {
	"# Character-Unlocks": "# Character-Unlocks",
	WebCat: true}
const SHOP_DICT = {
	"# Shop": "# Shop",
	Currency: 0}
const ACHIEVEMENTS_DICT = {
	"# Achievements" : "# Achievements",
	Lose: false}
## Tests
const TEST_INT = "TEST_INT"
const TEST_STRING = "TEST_STRING"
const TEST_FLOAT = "TEST_FLOAT"
const TEST_BOOL = "TEST_BOOL"
## Weapon Unlocks
const FlameThrower = "Flamethrower"
const Boomerang = "Boomerang"
const Gravity = "Gravity"
const IceShardWand = "Ice-Shard-Wand"
const LightningWand = "Lightning Wand"
const Minigun = "Minigun"
const Pistol = "Pistol"
const PlayingCards = "Playing-Cards"
const Railgun = "Railgun"
const RocketLauncher = "RocketLauncher"
const Sword = "Sword"
## Item Unlocks
const Arrows = "Arrows"
const Bloodlust = "Bloodlust"
const DamageBuff = "Damage-Buff"
const Flattery = "Flattery"
const GoldGenerator = "Gold-Generator"
const Marksman = "Marksman"
const ProjectileDuplicator = "Projectile-Duplicator"
const RandomStat = "Random-Stat"
const ScaredSpeedster = "Scared-Speedster"
const SorcerersEgo = "Sorcerers-Ego"
const SpontaneousCombustion = "Spontaneous-Combustion"
const Turrets = "Turrets"
## Map Unlocks
const Plains = "Plains"
## Character Unlocks
const WebCat = "Web-Cat"
## Meta Progression Shop
const Currency = "Currency"
## Achievements
const Lose = "Lose"
const data: Array[String] = [TEST_INT, TEST_STRING, TEST_FLOAT, TEST_BOOL]
## Writes the inputted data to save file if valid
static func save_data(slot: int, data_name: String, data_value):
	#print("SaveData(" + str(slot) + ", " + data_name + ", " + str(data_value) + ")")
	if !data.has(data_name):
		push_warning("Trying to save data that doesn't exist, key: " + data_name + ", value: " + str(data_value) + ", Slot: " + str(slot))
		return
	if !FileAccess.file_exists(get_filepath(slot)): ## TODO: make sure it's read/write?
		create_file(slot)
	## Get File Text
	var file = FileAccess.open(get_filepath(slot), FileAccess.READ)
	var file_text = file.get_as_text()
	file.close()
	## Find Key
	var lines = file_text.split("\n")
	var found = false
	for i in range(lines.size()):
		if lines[i].contains("- " + data_name + ":"):
			lines[i] = "\t- " + data_name + ": " + str(data_value)
			found = true
			break
	if !found:
		push_warning("Data name not found in file: " + data_name)
		lines = add_key(slot, data_name, data_value, lines)
	var updated_text = "\n".join(lines)
	file = FileAccess.open(get_filepath(slot), FileAccess.WRITE)
	file.store_string(updated_text)
	file.close()
	#print("SaveData() Success: " + str(found) + ", Value: " + str(load_data(slot, data_name)))
## Reads the inputted data from the save file if valid, Assumes no duplicates
static func load_data(slot: int, data_name: String) -> Variant:
	if !data.has(data_name):
		return null
	if !FileAccess.file_exists(get_filepath(slot)): ## TODO: make sure it's read/write?
			create_file(slot)
	var file = FileAccess.open(get_filepath(slot), FileAccess.READ)
	var file_text = file.get_as_text()
	file.close()
	for line in file_text.split("\n"):
		if line.contains("- " + data_name + ":"):
			var value = line.split(": ", false, 1)[1].strip_edges()
			if value == "true":
				return true
			elif value == "false":
				return false
			elif value.is_valid_int():
				return int(value)
			elif value.is_valid_float():
				return float(value)
			else:
				return value
	return null
## Creates new save file at Slot, Overwrites any existing file
static func create_file(slot: int):
	if FileAccess.file_exists(get_filepath(slot)):
		push_warning("Overwriting existing file on Slot: " + str(slot)) ## TODO: Popup/Ask Player to Confirm
	var base_text = generate_default_file(slot)
	var file = FileAccess.open(get_filepath(slot) , FileAccess.WRITE)
	file.store_string(base_text)
	file.close()
## Creates save file with default values
static func generate_default_file(slot: int) -> String:
	var output = ""
	var metadata = {"save_date": Time.get_datetime_string_from_system(), "game_version": 0.0, "save_slot": str(slot), "OS": OS.get_name()}
	output += "# MetaData" + ":\n"
	for key in metadata.keys():
		output += "\t- " + key + ": " + str(metadata[key]) + "\n"
	for section in defaults:
		for header in section.keys():
			if header.begins_with("#"):
				output += header + ":\n"
			else:
				output += "\t- " + header + ": " + str(section[header]) + "\n"
		output += "\n"
	return output
## Returns String of filepath for slot num
static func get_filepath(slot: int) -> String:
	return OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/CombatGame-test_save_data" + str(slot) + ".json"
## Adds data to place where it should be
static func add_key(slot: int, key: String, value, lines: Array[String]) -> Array[String]:
	return lines
## Write to file, unlock new weapon
static func unlock_weapon(index: int):
	pass
## Write to file, unlock achievement:
static func unlock_achievement(index: int):
	pass
