extends Resource
class_name StatusEffectDictionary

const BURNING = "burning"
const FROST = "frost"
const POISON = "poison"
const BLEED = "bleed"
const SHOCK = "shock"
const WET = "wet"

@export var decrease_every_process: bool = false
@export var dictionary = {
	BURNING: 0.0,
	FROST: 0.0,
	POISON: 0.0,
	BLEED: 0.0,
	SHOCK: 0.0,
	WET: 0.0
}

func _process(delta: float) -> void:
	if decrease_every_process:
		for i in dictionary:
			if i > 0:
				i -= delta
			if i < 0:
				i = 0

func get_value(value: String) -> float:
	return dictionary.get(value)
