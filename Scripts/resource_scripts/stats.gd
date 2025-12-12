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
#new
const CRITCHANCE = "critchance"
const CRITDAMAGE = "critdamage"
const GHOSTLY = "ghostly"
const REGEN = "regen"
const MAGNETIZE = "magentize"
const LIFESTEAL = "lifesteal"
const BONUSVSELITES = "bonusvselites"
const SHIELD = "shield"
const DIFFICULTY = "difficulty"
const REVIES = "revies"
const THORNS = "thorns"
const INACCURACY = "inaccuracy"

@export var parent_object_name = "not_set"
## Currently set pretty high as I'm not making individual stats for everything
static var defaultstats = {
	DAMAGE: 20.0,
	RANGE: 50.0,
	WEIGHT: 0.0,
	ATTACKSPEED: 5.0,
	VELOCITY: 20.0,
	INACCURACY: 3,
	COUNT: 1.0,
	PIERCING: 0.0,
	DURATION: 1.0,
	BUILDUP: 1.0,
	SIZE: 1.0,
	HP: 1.0,
	STANCE: 0.0,
	MOVESPEED: 60.0,
	XP: 1.0,
	MOGUL: 1.0,
	LUCK: 1.0,
	CRITCHANCE: 0.01,
	CRITDAMAGE: 0.5,
	GHOSTLY: 0.0,
	REGEN: 0.0,
	MAGNETIZE: 50.0,
	LIFESTEAL: 0.0,
	BONUSVSELITES: 0.0,
	SHIELD: 0.0,
	DIFFICULTY: 1.0,
	REVIES: 0.0,
	THORNS: 0.0
	}

@export var statsbase = { #everything must be default at 0 because they are always added in add_stats and should default to adding 0
	DAMAGE: 0.0,
	RANGE: 0.0,
	WEIGHT: 0.0,
	ATTACKSPEED: 0.0,
	VELOCITY: 0.0,
	INACCURACY: 0.0,
	COUNT: 0.0,
	PIERCING: 0.0,
	DURATION: 0.0,
	BUILDUP: 0.0,
	SIZE: 0.0, 
	HP: 0.0,
	STANCE: 0.0,
	MOVESPEED: 0.0,
	XP: 0.0,
	MOGUL: 0.0,
	LUCK: 0.0, 
	CRITCHANCE: 0.0,
	CRITDAMAGE: 0.0,
	GHOSTLY: 0.0,
	REGEN: 0.0,
	MAGNETIZE: 0.0,
	LIFESTEAL: 0.0,
	BONUSVSELITES: 0.0,
	SHIELD: 0.0,
	DIFFICULTY: 0.0,
	REVIES: 0.0,
	THORNS: 0.0
	}

@export var statsfactor = {
	DAMAGE: 1.0,
	RANGE: 1.0,
	WEIGHT: 1.0,
	ATTACKSPEED: 1.0,
	VELOCITY: 1.0,
	INACCURACY: 1.0,
	COUNT: 1.0,
	PIERCING: 1.0,
	DURATION: 1.0,
	BUILDUP: 1.0,
	SIZE: 1.0,
	HP: 1.0,
	STANCE: 1.0,
	MOVESPEED: 1.0,
	XP: 1.0,
	MOGUL: 1.0,
	LUCK: 1.0, 
	CRITCHANCE: 1.0,
	CRITDAMAGE: 1.0,
	GHOSTLY: 1.0,
	REGEN: 1.0,
	MAGNETIZE: 1.0,
	LIFESTEAL: 1.0,
	BONUSVSELITES: 1.0,
	SHIELD: 1.0,
	DIFFICULTY: 1.0,
	REVIES: 1.0,
	THORNS: 1.0
	}

var listofaffection: Array[StatsResource] = [] #the list of stats that affect this stat
var listofaffected: Array[StatsResource] = [] #the list of stats that this stat affects
var MustRecalculate: bool = true
var TotalListOfStats: Array[StatsResource] #list of stats used for stat calculations
## If valid, Recalculates then adds stats to this stats object
func add_stats(other: StatsResource) -> void: #adds the other stats to listofaffection
	if other == null || other == self || listofaffection.has(other):
		print("\nPotential ERROR when trying to add_stats\n")
		return
	Recalculate() # Must Recalculate TotalListofAffectionStats as we added a new stat
	listofaffection.append(other) #since the other stats is affecting this now, add it to the our listofaffection
	other.listofaffected.append(self)
##If valid, Recalculates then removes stats from this stats object
func remove_stats(other: StatsResource) -> void: #removes the stat from affecting this stat
	if other == null || other == self || !listofaffection.has(other):
		print("\nPotential ERROR: other stat is null when trying to remove_stats\n\t (OR doesn't include self in list of affection)\n")
		return
	Recalculate()# Must Recalculate TotalListofAffectionStats as we removed a stat
	listofaffection.erase(other) #since the other stats is affecting this now, add it to the other stat's listofaffection
	other.listofaffected.erase(self)
## If valid, checks recalculate then returns the total calculated stat
func get_stat(key: String) -> float:
	if statsbase.has(key) && statsfactor.has(key):
		if (MustRecalculate): # If list of all affecting stats has changed since last calculation, recalculate
			TotalListOfStats = []
			GetAllStatsRecursive(TotalListOfStats) # Get a list of all stats that are in the chain of stats that affect this stats, no duplicates
		var base = 0
		var factor = 1
		for stat: StatsResource in TotalListOfStats:
			if !(stat.statsbase.has(key) && stat.statsfactor.has(key)):
				printerr("StatsResource, " + stat.parent_object_name + ", doesn't have stat, " + str(key) + ".")
			else:
				base += stat.statsbase[key]
				factor *= stat.statsfactor[key]
		return (base * factor) + get_default(key) 
	else:
		push_error("ERROR getting stat: " + key +  " from: " + parent_object_name + ". Base: " + str(statsbase.has(key)) + ", Factor: " + str(statsfactor.has(key)))
		
		return -999
## If valid, checks recalculate then returns the total calculated stat but without default
func get_stat_without_default(key: String) -> float:
	if statsbase.has(key):
		if (MustRecalculate): # If list of all affecting stats has changed since last calculation, recalculate
			TotalListOfStats = []
			GetAllStatsRecursive(TotalListOfStats) # Get a list of all stats that are in the chain of stats that affect this stats, no duplicates
		var base = 0
		var factor = 1
		for stat in TotalListOfStats:
			base += stat.statsbase[key]
			factor *= stat.statsfactor[key]
		return (base * factor)
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## Gets a list of all stats OBJECTS that are affecting this stats object, not the individual stats
func GetAllStatsRecursive(list: Array[StatsResource]):
	if !list.has(self):
		list.append(self)
		MustRecalculate = false
		for stat in listofaffection:
			stat.GetAllStatsRecursive(list)
## Recursively says every stat object affected should recalculate
func Recalculate():
	MustRecalculate = true
	for stat in listofaffected:
		stat.Recalculate()
## returns total stats calculation of base stat
func get_stat_base(key: String) -> float:
	if statsbase.has(key):
		if (MustRecalculate): # If list of all affecting stats has changed since last calculation, recalculate
			TotalListOfStats = []
			GetAllStatsRecursive(TotalListOfStats) # Get a list of all stats that are in the chain of stats that affect this stats, no duplicates
		var base = 0
		for stat in TotalListOfStats:
			base += stat.statsbase[key]
		return base
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## returns total stats calculation of factor stat
func get_stat_factor(key: String) -> float:
	if statsfactor.has(key):
		if (MustRecalculate): # If list of all affecting stats has changed since last calculation, recalculate
			TotalListOfStats = []
			GetAllStatsRecursive(TotalListOfStats) # Get a list of all stats that are in the chain of stats that affect this stats, no duplicates
		var factor = 1
		for stat in TotalListOfStats:
			factor *= stat.statsfactor[key]
		return factor
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## edits this statsresource only value of base stat (only used when isolated statsresource)
func set_stat_base(key: String, value: float):
	if statsbase.has(key):
		statsbase[key] = value
		MustRecalculate = true
	else:
		print("Tried and Failed to set BaseStat: " + key + " to: " + str(value))
## edits this statsresource only value of factor stat (only used when isolated statsresource)
func set_stat_factor(key: String, value: float):
	if statsfactor.has(key):
		statsfactor[key] = value
		MustRecalculate = true
	else:
		print("Tried and Failed to set FactorStat: " + key + " to: " + str(value))
## Prints all the stats from stats factor, then statsbase. Does not calculate stats
func print_stats() -> void:
	if MustRecalculate:
		print("Stats are wrong, must recalculate first")
	var list: Array[StatsResource]
	GetAllStatsRecursive(list)
	for l in list:
		print("\n\nList: " + l.parent_object_name)
		print("\nFactors: ")
		for key in l.statsfactor:#if they have no changes in either dictionary, it's just adding the default 0 so no change!
			print(key + " - " + str(l.statsfactor[key]))
		print("\nBases: ")
		for key in l.statsbase:
			print(key + " - " + str(l.statsbase[key]))
## Returns if the stat is default or changed
func is_stat_default(stat: String):
	return get_stat_without_default(stat) == 0
func get_copy() -> StatsResource: #TODO: update for new stats implementation
	var temp: StatsResource = StatsResource.new()
	for key in statsfactor:
		temp.set_stat_factor(key, get_stat_factor(key))
	for key in statsbase:
		temp.set_stat_base(key, get_stat_base(key))
	temp.listofaffected.clear()
	temp.listofaffection.clear()
	return temp
## Returns default stat value when stat is set to 0
static func get_default(stat: String) -> float:
	if defaultstats.has(stat):
		return defaultstats.get(stat)
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## Returns name of random stat
static func get_rand_stat() -> String:
	return defaultstats.keys()[(randi() % defaultstats.size())]
	return defaultstats.key(randi() % defaultstats.size())
