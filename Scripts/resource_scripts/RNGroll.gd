extends Resource
class_name RNGroll
@export var name: String
@export var maximum: float = 0
@export var minimum: float = 0
@export var chance_to_roll: float = 0.5
func setup(new_max: float, new_min: float, new_chance: float) -> void:
	maximum = new_max
	minimum = new_min
	chance_to_roll = new_chance
	## Calculate Rarity into it
