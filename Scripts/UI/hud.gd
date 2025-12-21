extends Control
class_name HUD
## Shield
@onready var shield: Panel = $Shield/Shield/Shield/Shield
@onready var shield_parent: Control = $Shield
var shield_max_width: float:
	get():
		return hp_background.size.x
## HP
@onready var hp_background: Panel = $HP/HP/HP_Background/HP_Background
@onready var hp: Panel = $HP/HP/HP_BAR/HP
@onready var hp_bar: HBoxContainer = $HP/HP/HP_BAR
var hp_max_width: float:
	get():
		return hp_background.size.x
## XP
@onready var xp: Panel = $XP/Offsets_X/XP/XP_BAR/XP_Middle
@onready var xp_background: Panel = $XP/Offsets_X/XP/XP_Background/XP_Middle
@onready var xp_bar: HBoxContainer = $XP/Offsets_X/XP/XP_BAR
var xp_max_width: float:
	get():
		return size.x - 45
## Labels
@onready var silver: Label = $Labels/Silver
@onready var money: Label = $Labels/Money
@onready var kills: Label = $Labels/Kills
@onready var time: Label = $Time
## Sets the width of the XP HUD
func set_xp(percent: float):
	xp_bar.visible = true
	if percent >= 1:
		xp.custom_minimum_size.x = xp_max_width
		xp.size.x = xp_max_width
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	elif percent == 0.0:
		xp_bar.visible = false
	else:
		xp.custom_minimum_size.x = percent * xp_max_width
		xp.size.x = percent * xp_max_width
## Sets the width of the HP HUD
func set_hp(percent: float):
	print("hp: " + str(percent))
	hp_bar.visible = true
	if percent >= 1:
		hp.custom_minimum_size.x = hp_max_width
		hp.size.x = hp_max_width
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	elif percent <= 0:
		hp_bar.visible = false
	else:
		hp.custom_minimum_size.x = percent * hp_max_width
		hp.size.x = percent * hp_max_width
## Sets the width of the Shield HUD
func set_shield(percent: float):
	print(str(percent))
	shield_parent.visible = true
	#if percent >= 1:
		## TODO: when shield is greater than 1.0? add another line of shield? add another color of shield ontop?
	if percent <= 0:
		shield_parent.visible = false
	else:
		shield.custom_minimum_size.x = percent * shield_max_width
		shield.size.x = percent * shield_max_width
## Sets the width of the HP background to match new value
func set_max_hp(value: float):
	pass
##
func set_silver(value: float):
	silver.text = str(roundi(value))
##
func set_money(value: float):
	money.text = str(roundi(value))
##
func set_kills(value: float):
	kills.text = str(roundi(value))
##
func set_time(value: float):
	time.text = str(int(value / 60)) + ":" + str(int(fmod(value, 60.0)))
