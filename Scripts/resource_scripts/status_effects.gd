extends Resource
class_name StatusEffects
## Handles holding offensive values for Status Effects
const BURNING = "burning"
const FROST = "frost"
const POISON = "poison"
const BLEED = "bleed"
const SHOCK = "shock"
const WET = "wet"
func _init() -> void:
	pass
## Fire Damage Over Time
@export var burning: float
## Slows?
@export var frost: float 
## DOT?
@export var poison: float 
## Buildup and then burst bleed? or lower defense?
@export var bleed: float 
## Lower Attack?
@export var shock: float
## special attribute? lower buildup of other effects?
@export var wet: float
var dictionary = {
	BURNING: burning,
	FROST: frost,
	POISON: poison,
	BLEED: bleed,
	SHOCK: shock,
	WET: wet
}
## Returns dictionary value if given valid string
func get_value(value: String) -> float:
	if dictionary.has(value):
		return dictionary.get(value)
	printerr("Invalid Status Effect String: ", value)
	return 0
