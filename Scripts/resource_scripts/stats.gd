extends Resource
class_name StatsResource
const BLANK_STATS = preload("uid://djwbly6iawrk")
#mainly player stats:
const HP = "hp"
const STANCE = "stance"
const MOVESPEED = "movespeed"
const XP = "xp"
const MOGUL = "mogul"
const LUCK = "luck"
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
@export_placeholder("Name Go Here") var parent_object_name = "not_set"
@export_group("Base Stats")
@export var hp_base: float = 0.0
@export var stance_base: float = 0.0
@export var movespeed_base: float = 0.0
@export var xp_base: float = 0.0
@export var mogul_base: float = 0.0
@export var luck_base: float = 0.0
@export var damage_base: float = 0.0
@export var range_base: float = 0.0
@export var weight_base: float = 0.0
@export var attackspeed_base: float = 0.0
@export var velocity_base: float = 0.0
@export var count_base: float = 0.0
@export var piercing_base: float = 0.0
@export var duration_base: float = 0.0
@export var buildup_base: float = 0.0
@export var size_base: float = 0.0
@export var critchance_base: float = 0.0
@export var critdamage_base: float = 0.0
@export var ghostly_base: float = 0.0
@export var regen_base: float = 0.0
@export var magnetize_base: float = 0.0
@export var lifesteal_base: float = 0.0
@export var bonusvselites_base: float = 0.0
@export var shield_base: float = 0.0
@export var difficulty_base: float = 0.0
@export var revies_base: float = 0.0
@export var thorns_base: float = 0.0
@export var inaccuracy_base: float = 0.0
@export_group("Factor Stats")
@export var hp_factor: float = 1.0
@export var stance_factor: float = 1.0
@export var movespeed_factor: float = 1.0
@export var xp_factor: float = 1.0
@export var mogul_factor: float = 1.0
@export var luck_factor: float = 1.0
@export var damage_factor: float = 1.0
@export var range_factor: float = 1.0
@export var weight_factor: float = 1.0
@export var attackspeed_factor: float = 1.0
@export var velocity_factor: float = 1.0
@export var count_factor: float = 1.0
@export var piercing_factor: float = 1.0
@export var duration_factor: float = 1.0
@export var buildup_factor: float = 1.0
@export var size_factor: float = 1.0
@export var critchance_factor: float = 1.0
@export var critdamage_factor: float = 1.0
@export var ghostly_factor: float = 1.0
@export var regen_factor: float = 1.0
@export var magnetize_factor: float = 1.0
@export var lifesteal_factor: float = 1.0
@export var bonusvselites_factor: float = 1.0
@export var shield_factor: float = 1.0
@export var difficulty_factor: float = 1.0
@export var revies_factor: float = 1.0
@export var thorns_factor: float = 1.0
@export var inaccuracy_factor: float = 1.0
static var defaultstats = {
	HP: 100.0,
	STANCE: 0.0,
	MOVESPEED: 60.0,
	XP: 1.0,
	MOGUL: 1.0,
	LUCK: 1.0,
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
## Dictionary tying const stat name to @export variable
var statsbase = {
	HP: 0.0,
	STANCE: 0.0,
	MOVESPEED: 0.0,
	XP: 0.0,
	MOGUL: 0.0,
	LUCK: 0.0, 
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
var statsfactor = {
	HP: 1.0,
	STANCE: 1.0,
	MOVESPEED: 1.0,
	XP: 1.0,
	MOGUL: 1.0,
	LUCK: 1.0, 
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
## the list of stats that affect this stat
var listofaffection: Array[StatsResource]
## the list of stats that this stat affects
var listofaffected: Array[StatsResource]
var MustRecalculate: bool = true
## list of stats used for stat calculations
var TotalListOfStats: Array[StatsResource] 
## Method that is called when a stat is changed
signal StatsChanged
var initialized: bool = false
## Called after creating new stats from StatsResource.BLANK_STATS or to set name
func setup(name: String) -> void:
	parent_object_name = name
	initialized = true
	_rebuild_dicts()
	Recalculate()
func _rebuild_dicts() -> void:
	## Bases
	statsbase[HP] = hp_base
	statsbase[STANCE] = stance_base
	statsbase[MOVESPEED] = movespeed_base
	statsbase[XP] = xp_base
	statsbase[MOGUL] = mogul_base
	statsbase[LUCK] = luck_base
	statsbase[DAMAGE] = damage_base
	statsbase[RANGE] = range_base
	statsbase[WEIGHT] = weight_base
	statsbase[ATTACKSPEED] = attackspeed_base
	statsbase[VELOCITY] = velocity_base
	statsbase[INACCURACY] = inaccuracy_base
	statsbase[COUNT] = count_base
	statsbase[PIERCING] = piercing_base
	statsbase[DURATION] = duration_base
	statsbase[BUILDUP] = buildup_base
	statsbase[SIZE] = size_base
	statsbase[CRITCHANCE] = critchance_base
	statsbase[CRITDAMAGE] = critdamage_base
	statsbase[GHOSTLY] = ghostly_base
	statsbase[REGEN] = regen_base
	statsbase[MAGNETIZE] = magnetize_base
	statsbase[LIFESTEAL] = lifesteal_base
	statsbase[BONUSVSELITES] = bonusvselites_base
	statsbase[SHIELD] = shield_base
	statsbase[DIFFICULTY] = difficulty_base
	statsbase[REVIES] = revies_base
	statsbase[THORNS] = thorns_base
	## Factors
	statsfactor[HP] = hp_factor
	statsfactor[STANCE] = stance_factor
	statsfactor[MOVESPEED] = movespeed_factor
	statsfactor[XP] = xp_factor
	statsfactor[MOGUL] = mogul_factor
	statsfactor[LUCK] = luck_factor
	statsfactor[DAMAGE] = damage_factor
	statsfactor[RANGE] = range_factor
	statsfactor[WEIGHT] = weight_factor
	statsfactor[ATTACKSPEED] = attackspeed_factor
	statsfactor[VELOCITY] = velocity_factor
	statsfactor[INACCURACY] = inaccuracy_factor
	statsfactor[COUNT] = count_factor
	statsfactor[PIERCING] = piercing_factor
	statsfactor[DURATION] = duration_factor
	statsfactor[BUILDUP] = buildup_factor
	statsfactor[SIZE] = size_factor
	statsfactor[CRITCHANCE] = critchance_factor
	statsfactor[CRITDAMAGE] = critdamage_factor
	statsfactor[GHOSTLY] = ghostly_factor
	statsfactor[REGEN] = regen_factor
	statsfactor[MAGNETIZE] = magnetize_factor
	statsfactor[LIFESTEAL] = lifesteal_factor
	statsfactor[BONUSVSELITES] = bonusvselites_factor
	statsfactor[SHIELD] = shield_factor
	statsfactor[DIFFICULTY] = difficulty_factor
	statsfactor[REVIES] = revies_factor
	statsfactor[THORNS] = thorns_factor
func connect_changed_signal(method: Callable) -> void:
	StatsChanged.connect(method)
## If valid, Recalculates then adds stats to this stats object
func add_stats(other: StatsResource) -> void: 
	check_setup()
	if other == null || other == self || listofaffection.has(other):
		printerr("\nPotential ERROR when trying to add_stats")
		return
	stats_changed() # Must Recalculate TotalListofAffectionStats as we added a new stat
	listofaffection.append(other) #since the other stats is affecting this now, add it to the our listofaffection
	other.listofaffected.append(self)
##If valid, Recalculates then removes stats from this stats object
func remove_stats(other: StatsResource) -> void: #removes the stat from affecting this stat
	check_setup()
	if other == null || other == self || !listofaffection.has(other):
		printerr("\nPotential ERROR: other stat is null when trying to remove_stats\n\t (OR doesn't include self in list of affection)\n")
		return
	stats_changed()# Must Recalculate TotalListofAffectionStats as we removed a stat
	listofaffection.erase(other) #since the other stats is affecting this now, add it to the other stat's listofaffection
	other.listofaffected.erase(self)
## If valid, checks recalculate then returns the total calculated stat
func get_stat(key: String) -> float:
	check_setup()
	if statsbase.has(key) && statsfactor.has(key):
		Recalculate()
		var base = 0
		var factor = 1
		for stat: StatsResource in TotalListOfStats:
			if !(stat.statsbase.has(key) && stat.statsfactor.has(key)):
				printerr("StatsResource, " + stat.parent_object_name + ", doesn't have stat, " + str(key) + ".")
			else:
				base += stat.statsbase[key]
				factor *= stat.statsfactor[key]
		return (base * factor)
	else:
		push_error("ERROR getting stat: " + key +  " from: " + parent_object_name + ". Base: " + str(statsbase.has(key)) + ", Factor: " + str(statsfactor.has(key)))
		return -999
## Gets a list of all stats OBJECTS that are affecting this stats object, not the individual stats
func GetAllStatsRecursive(list: Array[StatsResource]):
	check_setup()
	if !list.has(self):
		list.append(self)
		#MustRecalculate = false
		for stat in listofaffection:
			stat.GetAllStatsRecursive(list)
## Gets a list of all stat objects affecting, but doesn't reset MustRecalculate
func External_GetAllStatsRecursive(list: Array[StatsResource]):
	check_setup()
	if !list.has(self):
		list.append(self)
		for stat in listofaffection:
			stat.External_GetAllStatsRecursive(list)
	return list
## Recursively says every stat object affected should recalculate
func Recalculate():
	check_setup()
	if MustRecalculate || TotalListOfStats == []:
		TotalListOfStats = []
		MustRecalculate = false
		GetAllStatsRecursive(TotalListOfStats)
func stats_changed():
	check_setup()
	StatsChanged.emit()
	MustRecalculate = true
	for stat in listofaffected:
		if stat != self && !listofaffection.has(stat):
			stat.stats_changed()
		else:
			
			printerr("Potential ERROR: calling stats_changed would have recursively looped as stat is in both listofaffection and listofaffected\nStat: " + parent_object_name + ", other: " + stat.parent_object_name)
## returns total stats calculation of base stat
func get_stat_base(key: String) -> float:
	check_setup()
	if statsbase.has(key):
		Recalculate()
		var base = 0
		for stat in TotalListOfStats:
			base += stat.statsbase[key]
		return base
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## returns total stats calculation of factor stat
func get_stat_factor(key: String) -> float:
	check_setup()
	if statsfactor.has(key):
		Recalculate()
		var factor = 1
		for stat in TotalListOfStats:
			factor *= stat.statsfactor[key]
		return factor
	else:
		push_error("Potential ERROR getting stat, not found in dictionary")
		return -999
## edits this statsresource only value of base stat (only used when isolated statsresource)
func set_stat_base(key: String, value: float):
	check_setup()
	if statsbase.has(key):
		statsbase[key] = value
		set_export_stat(false, key, value)
		stats_changed()
	else:
		print("Tried and Failed to set BaseStat: " + key + " to: " + str(value))
## edits this statsresource only value of factor stat (only used when isolated statsresource)
func set_stat_factor(key: String, value: float):
	check_setup()
	if statsfactor.has(key):
		statsfactor[key] = value
		set_export_stat(true, key, value)
		stats_changed()
	else:
		print("Tried and Failed to set FactorStat: " + key + " to: " + str(value))
## Sets the @export variable to the value, not the dictionaries
func set_export_stat(is_factor: bool, sought_stat: String, new_value: float) -> void:
	if is_factor:
		match sought_stat:
			HP: hp_factor = new_value
			STANCE: stance_factor = new_value
			MOVESPEED: movespeed_factor = new_value
			XP: xp_factor = new_value
			MOGUL: mogul_factor = new_value
			LUCK: luck_factor = new_value
			DAMAGE: damage_factor = new_value
			RANGE: range_factor = new_value
			WEIGHT: weight_factor = new_value
			ATTACKSPEED: attackspeed_factor = new_value
			VELOCITY: velocity_factor = new_value
			INACCURACY: inaccuracy_factor = new_value
			COUNT: count_factor = new_value
			PIERCING: piercing_factor = new_value
			DURATION: duration_factor = new_value
			BUILDUP: buildup_factor = new_value
			SIZE: size_factor = new_value
			CRITCHANCE: critchance_factor = new_value
			CRITDAMAGE: critdamage_factor = new_value
			GHOSTLY: ghostly_factor = new_value
			REGEN: regen_factor = new_value
			MAGNETIZE: magnetize_factor = new_value
			LIFESTEAL: lifesteal_factor = new_value
			BONUSVSELITES: bonusvselites_factor = new_value
			SHIELD: shield_factor = new_value
			DIFFICULTY: difficulty_factor = new_value
			REVIES: revies_factor = new_value
			THORNS: thorns_factor = new_value
	else:
		match sought_stat:
			HP: hp_base = new_value
			STANCE: stance_base = new_value
			MOVESPEED: movespeed_base = new_value
			XP: xp_base = new_value
			MOGUL: mogul_base = new_value
			LUCK: luck_base = new_value
			DAMAGE: damage_base = new_value
			RANGE: range_base = new_value
			WEIGHT: weight_base = new_value
			ATTACKSPEED: attackspeed_base = new_value
			VELOCITY: velocity_base = new_value
			INACCURACY: inaccuracy_base = new_value
			COUNT: count_base = new_value
			PIERCING: piercing_base = new_value
			DURATION: duration_base = new_value
			BUILDUP: buildup_base = new_value
			SIZE: size_base = new_value
			CRITCHANCE: critchance_base = new_value
			CRITDAMAGE: critdamage_base = new_value
			GHOSTLY: ghostly_base = new_value
			REGEN: regen_base = new_value
			MAGNETIZE: magnetize_base = new_value
			LIFESTEAL: lifesteal_base = new_value
			BONUSVSELITES: bonusvselites_base = new_value
			SHIELD: shield_base = new_value
			DIFFICULTY: difficulty_base = new_value
			REVIES: revies_base = new_value
			THORNS: thorns_base = new_value
## Prints all the stats from stats factor, then statsbase. Does not calculate stats
func print_stats() -> void:
	check_setup()
	Recalculate()
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
## Prints stat and all affecting stats for given stat key
func print_stat_tree(key: String):
	check_setup()
	Recalculate()
	var list: Array[StatsResource]
	External_GetAllStatsRecursive(list)
	var index: int = 1
	var totalf: float = 0
	var totalb: float = 0
	var stat_str = "Self   "
	var parent_str = parent_object_name
	var factor_str = "keyF-%s" % get_stat_factor(key)
	var base_str = "B-%s" % get_stat_base(key)
	if factor_str == "F-1.0":
		factor_str = "_____"
	if base_str == "B-0.0":
		base_str = "_____"
	print("\n%-2s %-25s %-5s %s" % [stat_str, parent_str, factor_str, base_str])
	for l in list:
		stat_str = "Stat %d:" % index
		parent_str = l.parent_object_name
		factor_str = "F-%s" % l.statsfactor[key]
		base_str = "B-%s" % l.statsbase[key]
		if factor_str == "F-1.0":
			factor_str = "_____"
		else:
			totalf += l.statsfactor[key]
		if base_str == "B-0.0":
			base_str = "_____"
		else:
			totalb += l.statsbase[key]
		print("%-2s %-25s %-5s %s" % [stat_str, parent_str, factor_str, base_str])
		print("Stat " + str(index) + ": " + l.parent_object_name + " F-" + str(l.statsfactor[key]) +" B-" + str(l.statsbase[key]))
		index += 1
	print("Total Value Should Be: " + key + " = " + str(totalf) + ", " + str(totalb) + "\n")
## Returns if the stat is default or changed
func is_stat_default(stat: String):
	check_setup()
	return get_stat(stat) == 0
func get_copy(transfer_affect_lists: bool) -> StatsResource: #TODO: update for new stats implementation
	check_setup()
	var temp: StatsResource = StatsResource.BLANK_STATS.duplicate()
	temp.setup(parent_object_name)
	for key in statsfactor:
		temp.set_stat_factor(key, get_stat_factor(key))
	for key in statsbase:
		temp.set_stat_base(key, get_stat_base(key))
	if transfer_affect_lists:
		temp.listofaffected = listofaffected.duplicate()
		temp.listofaffection = listofaffection.duplicate()
	return temp
## Returns name of random stat
static func get_rand_stat() -> String:
	return defaultstats.keys()[(randi() % defaultstats.size())]
	#return defaultstats.key(randi() % defaultstats.size())
## Round original_stat to have 'digits' digits at max
static func round_to_digits(original_stat: float, digits: int) -> String:
	var number: String = str(snapped(original_stat, 0.01))
	var decimals = digits - number.split(".")[0].length()
	if decimals > 0:
		if "." in number:
			number = number.rstrip("0").rstrip(".")
	else:
		number = number.split(".")[0]
	return number
## Untested
func delete_stats():
	check_setup()
	for stats in listofaffected:
		stats.remove_stats(self)
	for stats in listofaffection:
		remove_stats(stats)
## This check should never return true as that means a method is being touched before the frame after _init() (defer)
func check_setup():
	if !initialized:
		printerr("Trying to use StatsResource BEFORE calling setup, this is before any @export variables are applied - GAME BREAKING")
