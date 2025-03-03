extends Resource
class_name StatsResource

#mainly weapon stats:
const DAMAGE = "damage"
const RANGE = "range"
const WEIGHT = "weight"
const ATTACKSPEED = "attackspeed"
const VELOCITY = "velocity"
const COUNT = "count"
const PIERCING = "piercing"
const DURATION = "duration"
const BUILDUP = "buildup"
const SIZE = "size"
#mainly player stats:
const HP = "hp"
const STANCE = "stance"
const MOVESPEED = "movespeed"
const XP = "xp"
const MOGUL = "mogul"
const LUCK = "luck"

@export var parent_object_name = "not_set"

@export var statsbase = { #everything must be default at 0 because they are always added in add_stats and should default to adding 0
	DAMAGE: 0.0,
	RANGE: 0.0,
	WEIGHT: 0.0,
	ATTACKSPEED: 0.0,
	VELOCITY: 0.0,
	COUNT: 0.0,
	PIERCING: 0.0,
	DURATION: 0.0,
	BUILDUP: 0.0,
	SIZE: 0.0, #when edit this, edit this: scale = Vector2(value, value)
	HP: 0.0,
	STANCE: 0.0,
	MOVESPEED: 0.0,
	XP: 0.0,
	MOGUL: 0.0,
	LUCK: 0.0, }

@export var statsfactor = {
	DAMAGE: 1.0,
	RANGE: 1.0,
	WEIGHT: 1.0,
	ATTACKSPEED: 1.0,
	VELOCITY: 1.0,
	COUNT: 1.0,
	PIERCING: 1.0,
	DURATION: 1.0,
	BUILDUP: 1.0,
	SIZE: 1.0, #when edit this, edit this: scale = Vector2(value, value)
	HP: 1.0,
	STANCE: 1.0,
	MOVESPEED: 1.0,
	XP: 1.0,
	MOGUL: 1.0,
	LUCK: 1.0, }

var listofaffection: Array[StatsResource] = [] #the list of things that this stats affects

func add_stats(other: StatsResource) -> void: #adds the other stats to this stats
	if other == null || other == self || other.listofaffection.has(self):
		print("\nERROR when trying to add_stats\n")
		return
	#print("ADD STATS FROM: " + other.parent_object_name + " TO: " + parent_object_name)
	for key in statsfactor:#if they have no changes in either dictionary, it's just adding the default 0 so no change!
		statsfactor[key] = statsfactor[key] * other.statsfactor[key] 
	for key in statsbase:
		statsbase[key] = statsbase[key] + other.statsbase[key] 
	for affection in listofaffection: #add the new stats to all stats this stats affects already
		affection.add_stats(other)
	other.listofaffection.append(self) #since the other stats is affecting this now, add it to the other stat's listofaffection
	#print(other.parent_object_name + " " + str(other.get_list_of_affection()))

func remove_stats(other: StatsResource) -> void: #removes the stat from affecting this stat
	if other == null || other == self || !other.listofaffection.has(self):
		print("\nERROR: other stat is null when trying to remove_stats\n\t (OR doesn't include self in list of affection)\n")
		return
	#print("REMOVE STATS: " + other.parent_object_name + " From Affecting Stats: " + parent_object_name)
	for key in statsfactor:#if they have no changes in either dictionary, it's just adding the default 0 so no change!
		statsfactor[key] = statsfactor[key] / other.statsfactor[key] 
	for key in statsbase:
		statsbase[key] = statsbase[key] - other.statsbase[key] 
	for affection in listofaffection: #add the new stats to all stats this stats affects already
		affection.remove_stats(other)
	other.listofaffection.erase(self) #since the other stats is affecting this now, add it to the other stat's listofaffection

func get_stat(name: String) -> float:
	if statsbase.has(name):
		return (statsbase[name] + 1) * (statsfactor[name]) #add 1 is important? what's up? decide this? TODO:
	else:
		push_error("Error getting stat, not found in dictionary")
		return -999

## should only be used when stat is isolated and doesn't affect other stats
func set_stat_base(key: String, value: float):
	statsbase[key] = value

## should only be used when stat is isolated and doesn't affect other stats
func set_stat_factor(key: String, value: float):
	statsfactor[key] = value

func print_stats() -> void:
	print("\nFactors: ")
	for key in statsfactor:#if they have no changes in either dictionary, it's just adding the default 0 so no change!
		print(key + " - " + str(statsfactor[key]))
	print("\nBases: ")
	for key in statsbase:
		print(key + " - " + str(statsbase[key]))

func get_list_of_affection() -> Array[String]:
	var array: Array[String] = []
	for stat in listofaffection:
		array.append(stat.parent_object_name)
	return array

func get_copy() -> StatsResource:
	var temp: StatsResource = self.duplicate()
	temp.listofaffection.clear()
	return temp
