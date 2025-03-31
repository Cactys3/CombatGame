extends Node
class_name UIManager

@onready var money_label: Label = $"../Camera/Store/Money Label/Money"
@onready var xp_label: Label = $"../Camera/Store/XP Label/XP"
@onready var level_label: Label = $"../Camera/Store/LVL Label/LVL"

func set_level(value: String) -> void:
	level_label.text = value

func set_xp(value: String) -> void:
	xp_label.text = value

func set_money(value: String) -> void:
	money_label.text = value
