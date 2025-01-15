extends Node

var one: StatsResource 
var two: StatsResource 
var three: StatsResource 

func _ready() -> void:
	one = StatsResource.new()
	two = StatsResource.new()
	three = StatsResource.new()
	one.statsbase["damage"] = 2
	one.statsfactor["xp"] = 2
	one.statsbase["hp"] = 2
	three.statsbase["mogul"] = 1
	three.statsfactor["xp"] = 1
	three.statsbase["hp"] = 1
	three.add_stats(one)
	three.remove_stats(one)
	three.print_stats()
