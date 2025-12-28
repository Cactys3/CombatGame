extends Control
class_name AIO_Manager

@export var inventory: Inventory 
@export var equipment: EquipmentInventory
@export var stats_display: StatsDisplay 

func set_character_stats_display(stats: StatsResource):
	stats_display.set_stats(stats, "Character")
