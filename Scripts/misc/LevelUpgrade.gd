extends Resource
class_name LevelUpgrade

var stat_name: String = "" ## Stat to add to
var factor_stat: bool = false ## If false, it's a base stat
var change_value: float ## Value to add to the stat
var setup_complete: bool = false

func setup(name: String, factor: bool, value: float):
	stat_name = name
	factor_stat = factor
	change_value = value
	setup_complete = true
