extends Node
class_name UIManager

@onready var money_label: Label = $"../Camera/Store/Money Label/Money"
@onready var xp_label: Label = $"../Camera/Store/XP Label/XP"
@onready var level_label: Label = $"../Camera/Store/LVL Label/LVL"
@onready var container: GridContainer = $GridContainer

@onready var shop: Inventory = $TabContainer/MarginContainer2
@onready var inventory: Inventory = $TabContainer/MarginContainer2

func set_level(value: String) -> void:
	level_label.text = value

func set_xp(value: String) -> void:
	xp_label.text = value

func set_money(value: String) -> void:
	money_label.text = value

func add_shop_items(items: Array[Item]) -> void:
	for item in items:
		shop.add(item)
