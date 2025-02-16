extends Resource
class_name StatsResource

const DAMAGE = "damage"
const KNOCKBACK = "knockback"
const STUN = "stun"
const COOLDOWN = "cooldown"
const RANGE = "range"
const SPEED = "speed"
const SIZE = "size"
const COUNT = "count"
const PIERCING = "piercing"
const DURATION = "duration"
const AREA = "area"
const MOGUL = "mogul"
const XP = "xp"
const LIFESTEAL = "lifesteal"
const MOVESPEED = "movespeed"
const HP = "hp"
const HANDLING = "handling"

@export var parent_object_name = "not_set"

@export var statsbase = { #everything must be default at 0 because they are always added in add_stats and should default to adding 0
	#attack stats
	DAMAGE: 0,
	KNOCKBACK: 0,
	STUN: 0,
	#other stats
	COOLDOWN: 0,
	RANGE: 0,
	SPEED: 0,
	SIZE: 0, #when edit this, edit this: scale = Vector2(value, value)
	COUNT: 0,
	PIERCING: 0,
	DURATION: 0,
	AREA: 0,
	MOGUL: 0,
	XP: 0,
	LIFESTEAL: 0,
	MOVESPEED: 0,
	HP: 0,
	HANDLING: 0, }

@export var statsfactor = {
	#attack stats
	DAMAGE: 0,
	KNOCKBACK: 0,
	STUN: 0,
	#other stats
	COOLDOWN: 0,
	RANGE: 0,
	SPEED: 0,
	SIZE: 0, #when edit this, edit this: scale = Vector2(value, value)
	COUNT: 0,
	PIERCING: 0,
	DURATION: 0,
	AREA: 0,
	MOGUL: 0,
	XP: 0,
	LIFESTEAL: 0,
	MOVESPEED: 0,
	HP: 0,
	HANDLING: 0, }

var listofaffection: Array[StatsResource] = [] #the list of things that this stats affects

func add_stats(other: StatsResource) -> void: #adds the other stats to this stats
	if other == null || other == self || other.listofaffection.has(self):
		print("\nERROR when trying to add_stats\n")
		return
	#print("ADD STATS FROM: " + other.parent_object_name + " TO: " + parent_object_name)
	for key in statsfactor:#if they have no changes in either dictionary, it's just adding the default 0 so no change!
		statsfactor[key] = statsfactor[key] + other.statsfactor[key] 
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
		statsfactor[key] = statsfactor[key] - other.statsfactor[key] 
	for key in statsbase:
		statsbase[key] = statsbase[key] - other.statsbase[key] 
	for affection in listofaffection: #add the new stats to all stats this stats affects already
		affection.remove_stats(other)
	other.listofaffection.erase(self) #since the other stats is affecting this now, add it to the other stat's listofaffection

func get_stat(name: String) -> float:
	if statsbase.has(name):
		return statsbase[name] * (statsfactor[name] + 1) #add 1 is important, makes it adding the percent
	else:
		push_error("Error getting stat, not found in dictionary")
		return -999

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
