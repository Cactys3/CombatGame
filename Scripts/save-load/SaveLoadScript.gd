extends Node
class_name Save
const DICTIONARY_HEADER: String = "#DICT: "
const VARIABLE_HEADER: String = "\tVAR - "
const VARIABLE_VALUE_SPLIT: String = ": "
## Dictionaries of all save data with values as values and data names as keys
static var TEST_DICT: Dictionary = {
	DICTIONARY_HEADER + "Test": DICTIONARY_HEADER + "Test",
	TEST_INT: "12313112",
	TEST_STRING: "string TGESTmo f-af3さ",
	TEST_FLOAT: 3.2340,
	TEST_BOOL: false}
static var TEST2_DICT = {
	DICTIONARY_HEADER + "Test2": DICTIONARY_HEADER + "Test2",
	"custom test1": "32awef4",
	"custom test2": "32awef4",
	"custom test3": "3asd24",
	"custom test4": "3zxcv24"}
static var WEAPON_UNLOCKS_DICT = {
	DICTIONARY_HEADER + "Weapon-Unlocks": DICTIONARY_HEADER + "Weapon-Unlocks",
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
static var ITEM_UNLOCKS_DICT = {
	DICTIONARY_HEADER + "Item-Unlocks": DICTIONARY_HEADER + "Item-Unlocks",
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
static var MAP_UNLOCKS_DICT = {
	DICTIONARY_HEADER + "Map-Unlocks": DICTIONARY_HEADER + "Map-Unlocks",
	Plains: true}
static var CHARACTER_UNLOCKS_DICT = {
	DICTIONARY_HEADER + "Character-Unlocks": DICTIONARY_HEADER + "Character-Unlocks",
	WebCat: true}
static var SHOP_DICT = {
	DICTIONARY_HEADER + "Shop": DICTIONARY_HEADER + "Shop",
	Currency: 0}
static var ACHIEVEMENTS_DICT = {
	DICTIONARY_HEADER + "Achievements" : DICTIONARY_HEADER + "Achievements",
	boss: false,
	lose: false,
	win: false}
static var dictionaries = [TEST_DICT, TEST2_DICT, WEAPON_UNLOCKS_DICT, ITEM_UNLOCKS_DICT, MAP_UNLOCKS_DICT, CHARACTER_UNLOCKS_DICT, SHOP_DICT, ACHIEVEMENTS_DICT]
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
const boss = "Boss"
const lose = "Lose"
const win = "Win"
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
			lines[i] = "\t- " + data_name + VARIABLE_VALUE_SPLIT + str(data_value)
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
			var value = line.split(VARIABLE_VALUE_SPLIT, false, 1)[1].strip_edges()
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
	var base_text = generate_save_file(slot)
	var file = FileAccess.open(get_filepath(slot) , FileAccess.WRITE)
	file.store_string(base_text)
	file.close()
## Saves the data currently in the Save variables to the specified file. Will overwrite.
static func save_file(slot: int):
	if FileAccess.file_exists(get_filepath(slot)):
		var file = FileAccess.open(get_filepath(slot) , FileAccess.WRITE)
		file.store_string(generate_save_file(slot))
		file.close()
	else:
		printerr("Trying to save File: " + str(slot) + ", but doesn't exist")
## Loads the data currently in the specified file to the Save variables.
static func load_file(slot: int):
	if FileAccess.file_exists(get_filepath(slot)):
		var file = FileAccess.open(get_filepath(slot), FileAccess.READ)
		var file_text = file.get_as_text()
		var index: int = 0
		## Split first by dictionaries
		for dictionary in file_text.split(DICTIONARY_HEADER, false):
			## Skip MetaData Dictionary
			if index == 0:
				index += 1
				continue
			## Split inside by lines
			for line in dictionary.split("\n"):
				## Is it a variable?
				if line.contains(VARIABLE_HEADER):
					## grab the key and value
					var key_value_pair = line.split(VARIABLE_HEADER, true, 1)[1].strip_edges()
					var key = key_value_pair.split(VARIABLE_VALUE_SPLIT, false, 1)[0].strip_edges()
					var value = key_value_pair.split(VARIABLE_VALUE_SPLIT, false, 1)[1].strip_edges()
					## Set value to type
					if value == "true":
						value = true
					elif value == "false":
						value = false
					elif value.is_valid_int():
						value = int(value)
					elif value.is_valid_float():
						value = float(value)
					## Choose Right Dictionary (-1 offset beacuse metadata isn't in dictionaries array)
					if dictionaries[index - 1].has(key):
						dictionaries[index - 1][key] = value
						#print("Set: " + key + " = " + str(value))
					else:
						printerr("Didn't find dictionary when setting up Save variables")
						for dict in dictionaries:
							if dict[index - 1].has(key):
								dict[index - 1][key] = value
								break
			index += 1
		file.close()
	else:
		printerr("Trying to load File: " + str(slot) + ", but doesn't exist")
## Creates save file with currently variable values
static func generate_save_file(slot: int) -> String:
	var output = ""
	var metadata = {"save_date": Time.get_datetime_string_from_system(), "game_version": 0.0, "save_slot": str(slot), "OS": OS.get_name()}
	output += DICTIONARY_HEADER + "MetaData" + ":\n"
	for key in metadata.keys():
		output += VARIABLE_HEADER + key + VARIABLE_VALUE_SPLIT + str(metadata[key]) + "\n"
	for section in dictionaries:
		for header in section.keys():
			if header.begins_with(DICTIONARY_HEADER):
				output += header + ":\n"
			else:
				output += VARIABLE_HEADER + header + VARIABLE_VALUE_SPLIT + str(section[header]) + "\n"
		output += "\n"
	return output
## Returns String of filepath for slot num
static func get_filepath(slot: int) -> String:
	return OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/CombatGame-test_save_data" + str(slot) + ".json"
## Adds data to place where it should be
static func add_key(slot: int, key: String, value, lines: Array[String]) -> Array[String]:
	return lines
## Write to file, unlock new weapon
static func unlock_weapon(weapon_const: String):
	if WEAPON_UNLOCKS_DICT.has(weapon_const):
		WEAPON_UNLOCKS_DICT[weapon_const] = true
	else:
		printerr("Weapon Unlock Dict doesn't have: " + weapon_const)
## Write to file, unlock achievement:
static func unlock_achievement(achievement_const: String):
	if ACHIEVEMENTS_DICT.has(achievement_const):
		ACHIEVEMENTS_DICT[achievement_const] = true
	else:
		printerr("Achievements Dict doesn't have: " + achievement_const)
## Returns if save data exists at that slot number
static func check_save_data(slot: int) -> bool:
	return FileAccess.file_exists(get_filepath(slot))
