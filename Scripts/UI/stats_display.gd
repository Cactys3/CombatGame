class_name StatsDisplay
extends Control
@export var stats: StatsResource
const LIST = preload("uid://201jmce6dn1q")
const SCENE = preload("uid://o387qlahldf")
@export_category("Visuals")
@export var button_color: Color
@export var button_text_color: Color
@export var text_color: Color
@export var solid_background_panel: StyleBox
@export var scroll_stylebox: StyleBox
@export var scroll_grabber_stylebox: StyleBox
@export var scroll_grabber_hover_stylebox: StyleBox
@export_category("General Stat Showings")
@export var only_show_changed: bool = false
@export var hide_weapon_only: bool = false
@export var hide_player_only: bool = false
@export var hide_misc_only: bool = false
## overrides the above, 1 for true, 0 for false
@export_category("Individual Stats: Overrides the above, 1 = true, 0 = false, -1 = above")
@export var show_damage: int = -1
@export var show_range: int = -1
@export var show_weight: int = -1
@export var show_attackspeed: int = -1
@export var show_velocity: int = -1
@export var show_count: int = -1
@export var show_piercing: int = -1
@export var show_duration: int = -1
@export var show_buildup: int = -1
@export var show_size: int = -1
@export var show_hp: int = -1
@export var show_stance: int = -1
@export var show_movespeed: int = -1
@export var show_xp: int = -1
@export var show_mogul: int = -1
@export var show_luck: int = -1
@export var show_critchance: int = -1
@export var show_critdamage: int = -1
@export var show_ghostly: int = -1
@export var show_regen: int = -1
@export var show_magnetize: int = -1
@export var show_lifesteal: int = -1
@export var show_bonusvselites: int = -1
@export var show_shield: int = -1
@export var show_difficulty: int = -1
@export var show_revies: int = -1
@export var show_thorns: int = -1
@export var show_inaccuracy: int = -1
## Child Nodes
@onready var buttons: Array[Button] = [$VBoxContainer/HBoxContainer/Button, $VBoxContainer/HBoxContainer/Button2, $VBoxContainer/HBoxContainer/Button3, $VBoxContainer/HBoxContainer/Button4]
@onready var title: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/Title
@onready var scroll: ScrollContainer = $VBoxContainer/HBoxContainer2/ScrollContainer
@onready var listparent: HBoxContainer = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer
@onready var labelparent: VBoxContainer = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer
## Labels
@onready var damage: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/damage
@onready var _range: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/range
@onready var weight: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/weight
@onready var attackspeed: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/attackspeed
@onready var velocity: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/velocity
@onready var count: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/count
@onready var piercing: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/piercing
@onready var duration: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/duration
@onready var buildup: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/buildup
@onready var _size: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/size
@onready var hp: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/hp
@onready var stance: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/stance
@onready var movespeed: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/movespeed
@onready var xp: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/xp
@onready var mogul: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/mogul
@onready var luck: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/luck
@onready var critchance: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/critchance
@onready var critdamage: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/critdamage
@onready var ghostly: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/ghostly
@onready var regen: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/regen
@onready var magnetize: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/magnetize
@onready var lifesteal: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/lifesteal
@onready var bonusvselites: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/bonusvselites
@onready var shield: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/shield
@onready var difficulty: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/difficulty
@onready var revies: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/revies
@onready var thorns: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/thorns
@onready var inaccuracy: Label = $VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer2/HBoxContainer/VBoxContainer/inaccuracy
@onready var statslabels = {
	StatsResource.DAMAGE: damage,
	StatsResource.RANGE: _range,
	StatsResource.WEIGHT: weight,
	StatsResource.ATTACKSPEED: attackspeed,
	StatsResource.VELOCITY: velocity,
	StatsResource.COUNT: count,
	StatsResource.PIERCING: piercing,
	StatsResource.DURATION: duration,
	StatsResource.BUILDUP: buildup,
	StatsResource.SIZE: _size,
	StatsResource.HP: hp,
	StatsResource.STANCE: stance,
	StatsResource.MOVESPEED: movespeed,
	StatsResource.XP: xp,
	StatsResource.MOGUL: mogul,
	StatsResource.LUCK: luck,
	StatsResource.CRITCHANCE: critchance,
	StatsResource.CRITDAMAGE: critdamage,
	StatsResource.GHOSTLY: ghostly,
	StatsResource.REGEN: regen,
	StatsResource.MAGNETIZE: magnetize,
	StatsResource.LIFESTEAL: lifesteal,
	StatsResource.BONUSVSELITES: bonusvselites,
	StatsResource.SHIELD: shield,
	StatsResource.DIFFICULTY: difficulty,
	StatsResource.REVIES: revies,
	StatsResource.THORNS: thorns,
	StatsResource.INACCURACY: inaccuracy }
var lists: Array[StatsList]
## Variables
@onready var dict: Dictionary = {
	StatsResource.DAMAGE: show_damage,
	StatsResource.RANGE: show_range,
	StatsResource.WEIGHT: show_weight,
	StatsResource.ATTACKSPEED: show_attackspeed,
	StatsResource.VELOCITY: show_velocity,
	StatsResource.COUNT: show_count,
	StatsResource.PIERCING: show_piercing,
	StatsResource.DURATION: show_duration,
	StatsResource.BUILDUP: show_buildup,
	StatsResource.SIZE: show_size,
	StatsResource.HP: show_hp,
	StatsResource.STANCE: show_stance,
	StatsResource.MOVESPEED: show_movespeed,
	StatsResource.XP: show_xp,
	StatsResource.MOGUL: show_mogul,
	StatsResource.LUCK: show_luck,
	StatsResource.CRITCHANCE: show_critchance,
	StatsResource.CRITDAMAGE: show_critdamage,
	StatsResource.GHOSTLY: show_ghostly,
	StatsResource.REGEN: show_regen,
	StatsResource.MAGNETIZE: show_magnetize,
	StatsResource.LIFESTEAL: show_lifesteal,
	StatsResource.BONUSVSELITES: show_bonusvselites,
	StatsResource.SHIELD: show_shield,
	StatsResource.DIFFICULTY: show_difficulty,
	StatsResource.REVIES: show_revies,
	StatsResource.THORNS: show_thorns,
	StatsResource.INACCURACY: show_inaccuracy}
@onready var misc: Array[String] = [
	StatsResource.SIZE,
	StatsResource.LUCK,
	StatsResource.BONUSVSELITES,
	StatsResource.DIFFICULTY]
@onready var players: Array[String] = [
	StatsResource.HP,
	StatsResource.WEIGHT,
	StatsResource.STANCE,
	StatsResource.MOVESPEED,
	StatsResource.XP,
	StatsResource.MOGUL,
	StatsResource.GHOSTLY,
	StatsResource.REGEN,
	StatsResource.MAGNETIZE,
	StatsResource.SHIELD,
	StatsResource.REVIES,
	StatsResource.THORNS]
@onready var weapons: Array[String] = [
	StatsResource.DAMAGE,
	StatsResource.RANGE,
	StatsResource.ATTACKSPEED,
	StatsResource.VELOCITY,
	StatsResource.COUNT,
	StatsResource.PIERCING,
	StatsResource.DURATION,
	StatsResource.BUILDUP,
	StatsResource.CRITCHANCE,
	StatsResource.CRITDAMAGE,
	StatsResource.INACCURACY]
@onready var array: Array[String] = [
	StatsResource.HP,
	StatsResource.SHIELD,
	StatsResource.REGEN,
	StatsResource.XP,
	StatsResource.MOGUL,
	StatsResource.MOVESPEED,
	StatsResource.STANCE,
	StatsResource.DAMAGE,
	StatsResource.RANGE,
	StatsResource.ATTACKSPEED,
	StatsResource.PIERCING,
	StatsResource.VELOCITY,
	StatsResource.COUNT,
	StatsResource.DURATION,
	StatsResource.SIZE,
	StatsResource.WEIGHT,
	StatsResource.LUCK,
	StatsResource.BUILDUP,
	StatsResource.CRITCHANCE,
	StatsResource.CRITDAMAGE,
	StatsResource.GHOSTLY,
	StatsResource.MAGNETIZE,
	StatsResource.LIFESTEAL,
	StatsResource.BONUSVSELITES,
	StatsResource.DIFFICULTY,
	StatsResource.REVIES,
	StatsResource.THORNS,
	StatsResource.INACCURACY]
@onready var default_order: Array[String] = [
	StatsResource.HP,
	StatsResource.SHIELD,
	StatsResource.REGEN,
	StatsResource.XP,
	StatsResource.MOGUL,
	StatsResource.MOVESPEED,
	StatsResource.STANCE,
	StatsResource.DAMAGE,
	StatsResource.RANGE,
	StatsResource.ATTACKSPEED,
	StatsResource.PIERCING,
	StatsResource.VELOCITY,
	StatsResource.COUNT,
	StatsResource.DURATION,
	StatsResource.SIZE,
	StatsResource.WEIGHT,
	StatsResource.LUCK,
	StatsResource.BUILDUP,
	StatsResource.CRITCHANCE,
	StatsResource.CRITDAMAGE,
	StatsResource.GHOSTLY,
	StatsResource.MAGNETIZE,
	StatsResource.LIFESTEAL,
	StatsResource.BONUSVSELITES,
	StatsResource.DIFFICULTY,
	StatsResource.REVIES,
	StatsResource.THORNS,
	StatsResource.INACCURACY]
var last_clicked: float = -1
var is_ready: bool = false
var timer
var index: int = 0
var single_stats: Array[StatsResource]
var single_stat_total_list: StatsList
## Backup
## Sets up the statsdisplay for showing all the stats of this stats object
func setup_substats(new_stats: StatsResource, new_name: String):
	## Setup Based on Parameters
	stats = new_stats
	clear_lists()
	index = 1
	var mainlist: StatsList = LIST.instantiate()
	mainlist.setup(new_stats, index)
	index += 1
	listparent.add_child(mainlist)
	lists.append(mainlist)
	## Only get stats one layer deep ie: listofaffection instead of recursive get all stats
	## TODO: if weapon, order it so it goes handle, attachment, projectile, then everything else
	for stat in new_stats.listofaffection:
		var newlist: StatsList = LIST.instantiate()
		newlist.setup(stat, index)
		index += 1
		listparent.add_child(newlist)
		lists.append(newlist)
	setup_generic(new_name)
## Sets up the statsdisplay for adding a bunch of single stats
func setup_single_stats(new_name: String):
	clear_lists()
	single_stat_total_list = LIST.instantiate()
	listparent.add_child(single_stat_total_list)
	lists.append(single_stat_total_list)
	single_stat_total_list.setup_as_manual(1)
	index = 2
	setup_generic(new_name)
## Adds a single statlist for given stat, for use when showing a bunch of single stats, not when showing substats of a stats object
func add_single_stats(new_stats: StatsResource):
	var list: StatsList = LIST.instantiate()
	list.setup(new_stats, index)
	index += 1
	listparent.add_child(list)
	lists.append(list)
	single_stats.append(new_stats)
	single_stat_total_list.manual_refresh(single_stats)
	for stat in dict:
		if array.has(stat):
			for l in lists:
				l.set_stat_visible(stat, true)
		else:
			for l in lists:
				l.set_stat_visible(stat, false)
	sort_default()
## Sets up the statsdisplay for use, is called for both adding single stats and showing all substats of one stat
func setup_generic(new_name: String):
	name = new_name
	if timer:
		timer.queue_free()
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(refresh)
	timer.wait_time = 3.0
	timer.start()
	title.text = new_name
	## Setup based on @exports
	if solid_background_panel:
		add_theme_stylebox_override("panel", solid_background_panel)
	if button_text_color:
		for button in buttons:
			button.add_theme_color_override("font_color", button_text_color)
	if button_color:
		var box: StyleBox = StyleBoxFlat.new()
		box.bg_color = button_color
		for button in buttons:
			button.add_theme_stylebox_override("normal", box)
	if text_color:
		for list in lists:
			if list.ID == 0 || list.ID == 1:
				list.set_text_color(text_color)
	if scroll_stylebox:
		scroll.get_v_scroll_bar().custom_minimum_size = Vector2(8, 0)
		scroll.get_v_scroll_bar().add_theme_stylebox_override("scroll", scroll_stylebox)
	if scroll_grabber_stylebox:
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber", scroll_grabber_stylebox)
	else:
		var box = StyleBoxFlat.new()
		box.bg_color = Color.DEEP_PINK
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber", box)
	if scroll_grabber_hover_stylebox:
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", scroll_grabber_hover_stylebox)
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", scroll_grabber_hover_stylebox)
	else:
		var box = StyleBoxFlat.new()
		box.bg_color = Color.HOT_PINK
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", box)
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", box)
	if hide_weapon_only:
		hide_weapons()
	if hide_player_only:
		hide_players()
	if hide_misc_only:
		hide_misc()
	hide_hides()
	sort_default()
	refresh()
	is_ready = true
func refresh():
	if stats:
		for stat in stats.listofaffection:
			var make_new_list: bool = true
			for list in lists:
				if list.stats == stat:
					make_new_list = false
					break
			if make_new_list:
				var newlist: StatsList = LIST.instantiate()
				newlist.setup(stat, index)
				index += 1
				listparent.add_child(newlist)
				lists.append(newlist)
		if only_show_changed:
			hide_defaults()
		else:
			for element in array:
				for list in lists:
					list.set_stat_visible(element, true)
					if statslabels.has(element):
						statslabels[element].visible = true
		for list in lists:
			list.refresh()
func sort_random():
	array.shuffle()
	reset_children()
func sort_reverse_alphabetically():
	array.sort_custom(func(a, b): return a > b)
	reset_children()
func sort_alphabetically():
	array.sort_custom(func(a, b): return a < b)
	reset_children()
func sort_reverse_default():
	array = default_order.duplicate()
	array.reverse()
	reset_children()
func sort_default():
	array = default_order.duplicate() # array.sort_custom(func(a, b): return default_order.find(a) < default_order.find(b))
	reset_children()
func sort_numerically():
	pass
func reset_children():
	for i in range(array.size()):
		for list in lists:
			list.reorder(array[i], i + 2) # +2 to offset title and underline nodes
			labelparent.move_child(statslabels[array[i]], i + 2)
## Hides stats that aren't changed from default value
func hide_defaults():
	set_stat_visible(StatsResource.DAMAGE, stats.is_stat_default(StatsResource.DAMAGE))
	set_stat_visible(StatsResource.RANGE, stats.is_stat_default(StatsResource.RANGE))
	set_stat_visible(StatsResource.WEIGHT, stats.is_stat_default(StatsResource.WEIGHT))
	set_stat_visible(StatsResource.ATTACKSPEED, stats.is_stat_default(StatsResource.ATTACKSPEED))
	set_stat_visible(StatsResource.VELOCITY, stats.is_stat_default(StatsResource.VELOCITY))
	set_stat_visible(StatsResource.COUNT, stats.is_stat_default(StatsResource.COUNT))
	set_stat_visible(StatsResource.PIERCING, stats.is_stat_default(StatsResource.PIERCING))
	set_stat_visible(StatsResource.DURATION, stats.is_stat_default(StatsResource.DURATION))
	set_stat_visible(StatsResource.BUILDUP, stats.is_stat_default(StatsResource.BUILDUP))
	set_stat_visible(StatsResource.SIZE, stats.is_stat_default(StatsResource.SIZE))
	set_stat_visible(StatsResource.HP, stats.is_stat_default(StatsResource.HP))
	set_stat_visible(StatsResource.STANCE, stats.is_stat_default(StatsResource.STANCE))
	set_stat_visible(StatsResource.MOVESPEED, stats.is_stat_default(StatsResource.MOVESPEED))
	set_stat_visible(StatsResource.XP, stats.is_stat_default(StatsResource.XP))
	set_stat_visible(StatsResource.MOGUL, stats.is_stat_default(StatsResource.MOGUL))
	set_stat_visible(StatsResource.LUCK, stats.is_stat_default(StatsResource.LUCK))
	set_stat_visible(StatsResource.CRITCHANCE, stats.is_stat_default(StatsResource.CRITCHANCE))
	set_stat_visible(StatsResource.CRITDAMAGE, stats.is_stat_default(StatsResource.CRITDAMAGE))
	set_stat_visible(StatsResource.GHOSTLY, stats.is_stat_default(StatsResource.GHOSTLY))
	set_stat_visible(StatsResource.REGEN, stats.is_stat_default(StatsResource.REGEN))
	set_stat_visible(StatsResource.MAGNETIZE, stats.is_stat_default(StatsResource.MAGNETIZE))
	set_stat_visible(StatsResource.LIFESTEAL, stats.is_stat_default(StatsResource.LIFESTEAL))
	set_stat_visible(StatsResource.BONUSVSELITES, stats.is_stat_default(StatsResource.BONUSVSELITES))
	set_stat_visible(StatsResource.SHIELD, stats.is_stat_default(StatsResource.SHIELD))
	set_stat_visible(StatsResource.DIFFICULTY, stats.is_stat_default(StatsResource.DIFFICULTY))
	set_stat_visible(StatsResource.REVIES, stats.is_stat_default(StatsResource.REVIES))
	set_stat_visible(StatsResource.THORNS, stats.is_stat_default(StatsResource.THORNS))
	set_stat_visible(StatsResource.INACCURACY, stats.is_stat_default(StatsResource.INACCURACY))
## Removes elements from arrays based on if they are set to be hidden
func hide_hides():
	for key in dict:
		if dict[key] == 0:
			array.erase(key)
			default_order.erase(key)
			key.visible = false
		elif dict[key] == 1:
			key.visible = true
func hide_weapons():
	for label in weapons:
		array.erase(label)
		default_order.erase(label)
		set_stat_visible(label, false)
func hide_players():
	for label in players:
		array.erase(label)
		default_order.erase(label)
		set_stat_visible(label, false)
func hide_misc():
	for label in misc:
		array.erase(label)
		default_order.erase(label)
		set_stat_visible(label, false)
## Gets the name of all stats objects affecting this one
func get_affecting_names() -> Array[StatsResource]:
	var a: Array[StatsResource]
	stats.External_GetAllStatsRecursive(a)
	return a
func clear_lists():
	pass#single_stats.clear()
	#for list in lists:
	#	list.free_children()
	#	list.queue_free()
	#lists.clear()
func set_stat_visible(key: String, value: bool) -> void:
	for list in lists:
		list.set_stat_visible(key, value)
	for label in statslabels:
		if label == key:
			statslabels[label].visible = false
## Handles stuff and then queue_free()
func delete():
	## The stats are queue'ed free on queue_free
	#stats = null
	#single_stats.clear()
	lists.clear()
	queue_free()

func button1():
	if is_ready:
		if last_clicked == 1:
			sort_reverse_default()
			last_clicked = -1
		else:
			sort_default()
			last_clicked = 1
func button2():
	if is_ready:
		if last_clicked == 2:
			sort_reverse_alphabetically()
			last_clicked = -1
		else:
			sort_alphabetically()
			last_clicked = 2
func button3():
	if is_ready:
		only_show_changed = !only_show_changed
		refresh()
func button4():
	if is_ready:
		sort_random()
		last_clicked = 4
