extends Control
class_name AOI_Manager

@onready var inventory: Inventory = $Main/Main/Inventory
@onready var equipment: EquipmentInventory = $Main/Main/RightPanel/DividerBox/Right/RightBox/Equipment
@onready var stats_display: StatsDisplay = $Main/Main/RightPanel/DividerBox/Right/RightBox/CharacterPanel/HBox/Margin/Stats/MarginContainer/StatsDisplay

func set_character_stats_display(stats: StatsResource):
	stats_display.set_stats(stats, "Character")
