class_name StatsDisplay
extends Control

@export var stats: StatsResource

const SCENE = preload("res://Scenes/UI/stats_visual.tscn")

@export_category("Visuals")
@export var button_color: Color
@export var button_text_color: Color
@export var text_color: Color
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
## Labels
@onready var hp: Label = $VBoxContainer/ScrollContainer/VBoxContainer/hp
@onready var stance: Label = $VBoxContainer/ScrollContainer/VBoxContainer/stance
@onready var movespeed: Label = $VBoxContainer/ScrollContainer/VBoxContainer/movespeed
@onready var xp: Label = $VBoxContainer/ScrollContainer/VBoxContainer/xp
@onready var mogul: Label = $VBoxContainer/ScrollContainer/VBoxContainer/mogul
@onready var luck: Label = $VBoxContainer/ScrollContainer/VBoxContainer/luck
@onready var damage: Label = $VBoxContainer/ScrollContainer/VBoxContainer/damage
@onready var _range: Label = $VBoxContainer/ScrollContainer/VBoxContainer/range
@onready var weight: Label = $VBoxContainer/ScrollContainer/VBoxContainer/weight
@onready var attackspeed: Label = $VBoxContainer/ScrollContainer/VBoxContainer/attackspeed
@onready var velocity: Label = $VBoxContainer/ScrollContainer/VBoxContainer/velocity
@onready var count: Label = $VBoxContainer/ScrollContainer/VBoxContainer/count
@onready var piercing: Label = $VBoxContainer/ScrollContainer/VBoxContainer/piercing
@onready var duration: Label = $VBoxContainer/ScrollContainer/VBoxContainer/duration
@onready var buildup: Label = $VBoxContainer/ScrollContainer/VBoxContainer/buildup
@onready var _size: Label = $VBoxContainer/ScrollContainer/VBoxContainer/size
@onready var critchance: Label = $VBoxContainer/ScrollContainer/VBoxContainer/critchance
@onready var critdamage: Label = $VBoxContainer/ScrollContainer/VBoxContainer/critdamage
@onready var ghostly: Label = $VBoxContainer/ScrollContainer/VBoxContainer/ghostly
@onready var regen: Label = $VBoxContainer/ScrollContainer/VBoxContainer/regen
@onready var magnetize: Label = $VBoxContainer/ScrollContainer/VBoxContainer/magnetize
@onready var lifesteal: Label = $VBoxContainer/ScrollContainer/VBoxContainer/lifesteal
@onready var bonusvselites: Label = $VBoxContainer/ScrollContainer/VBoxContainer/bonusvselites
@onready var shield: Label = $VBoxContainer/ScrollContainer/VBoxContainer/shield
@onready var difficulty: Label = $VBoxContainer/ScrollContainer/VBoxContainer/difficulty
@onready var revies: Label = $VBoxContainer/ScrollContainer/VBoxContainer/revies
@onready var thorns: Label = $VBoxContainer/ScrollContainer/VBoxContainer/thorns
@onready var inaccuracy: Label = $VBoxContainer/ScrollContainer/VBoxContainer/inaccuracy
## More Children
@onready var buttons: Array[Button] = [$VBoxContainer/HBoxContainer/Button, $VBoxContainer/HBoxContainer/Button2, $VBoxContainer/HBoxContainer/Button3, $VBoxContainer/HBoxContainer/Button4]
@onready var scroll: ScrollContainer = $VBoxContainer/ScrollContainer
@onready var label_parent: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
## Variables
@onready var dict: Dictionary = {
	damage: show_damage,
	_range: show_range,
	weight: show_weight,
	attackspeed: show_attackspeed,
	velocity: show_velocity,
	count: show_count,
	piercing: show_piercing,
	duration: show_duration,
	buildup: show_buildup,
	_size: show_size,
	hp: show_hp,
	stance: show_stance,
	movespeed: show_movespeed,
	xp: show_xp,
	mogul: show_mogul,
	luck: show_luck,
	critchance: show_critchance,
	critdamage: show_critdamage,
	ghostly: show_ghostly,
	regen: show_regen,
	magnetize: show_magnetize,
	lifesteal: show_lifesteal,
	bonusvselites: show_bonusvselites,
	shield: show_shield,
	difficulty: show_difficulty,
	revies: show_revies,
	thorns: show_thorns,
	inaccuracy: show_inaccuracy }
@onready var misc: Array[Label] = [_size, luck, bonusvselites, difficulty]
@onready var players: Array[Label] = [hp, weight, stance, movespeed, xp, mogul, ghostly, regen, magnetize, shield, revies, thorns]
@onready var weapons: Array[Label] = [damage, _range, attackspeed, velocity, count, piercing, duration, buildup, critchance, critdamage, inaccuracy]
var last_clicked: float = -1
@onready var array: Array[Label] = [hp, shield, regen, xp, mogul, movespeed, stance, damage, _range, attackspeed, piercing, velocity, count, duration, _size, weight, luck, buildup, critchance, critdamage, ghostly, magnetize, lifesteal, bonusvselites, difficulty, revies, thorns, inaccuracy]
@onready var default_order: Array[Label] = [hp, shield, regen, xp, mogul, movespeed, stance, damage, _range, attackspeed, piercing, velocity, count, duration, _size, weight, luck, buildup, critchance, critdamage, ghostly, magnetize, lifesteal, bonusvselites, difficulty, revies, thorns, inaccuracy]

var is_ready: bool = false

func set_stats(new_stats: StatsResource, new_name: String):
	stats = new_stats
	name = new_name
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(refresh)
	timer.wait_time = 3.0
	timer.start()
	refresh()
	is_ready = true
func _ready():
	if button_text_color:
		for button in buttons:
			button.add_theme_color_override("font_color", button_text_color)
	if button_color:
		var box: StyleBox = StyleBoxFlat.new()
		box.bg_color = button_color
		for button in buttons:
			button.add_theme_stylebox_override("normal", box)
	if text_color:
		for label in array:
			label.add_theme_color_override("font_color", text_color)
	if scroll_stylebox:
		scroll.get_v_scroll_bar().custom_minimum_size = Vector2(8, 0)
		scroll.get_v_scroll_bar().add_theme_stylebox_override("scroll", scroll_stylebox)
	if scroll_grabber_stylebox:
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber", scroll_grabber_stylebox)
	if scroll_grabber_hover_stylebox:
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", scroll_grabber_hover_stylebox)
		scroll.get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", scroll_grabber_hover_stylebox)
	if stats:
		set_stats(stats, stats.parent_object_name)
	if hide_weapon_only:
		hide_weapons()
	if hide_player_only:
		hide_players()
	if hide_misc_only:
		hide_misc()
	hide_hides()
	sort_default()
func refresh():
	if stats:
		if only_show_changed:
			hide_defaults()
		else:
			for element in array:
				element.visible = true
		damage.text = "damage: " + str(stats.get_stat(StatsResource.DAMAGE))
		_range.text = "range: " + str(stats.get_stat(StatsResource.RANGE))
		weight.text = "weight: " + str(stats.get_stat(StatsResource.WEIGHT))
		attackspeed.text = "attackspeed: " + str(stats.get_stat(StatsResource.ATTACKSPEED))
		velocity.text = "velocity: " + str(stats.get_stat(StatsResource.VELOCITY))
		count.text = "count: " + str(stats.get_stat(StatsResource.COUNT))
		piercing.text = "piercing: " + str(stats.get_stat(StatsResource.PIERCING))
		duration.text = "duration: " + str(stats.get_stat(StatsResource.DURATION))
		buildup.text = "buildup: " + str(stats.get_stat(StatsResource.BUILDUP))
		_size.text = "size: " + str(stats.get_stat(StatsResource.SIZE))
		hp.text = "hp: " + str(stats.get_stat(StatsResource.HP))
		stance.text = "stance: " + str(stats.get_stat(StatsResource.STANCE))
		movespeed.text = "movespeed: " + str(stats.get_stat(StatsResource.MOVESPEED))
		xp.text = "xp: " + str(stats.get_stat(StatsResource.XP))
		mogul.text = "mogul: " + str(stats.get_stat(StatsResource.MOGUL))
		luck.text = "luck: " + str(stats.get_stat(StatsResource.LUCK))
		critchance.text = "critchance: " + str(stats.get_stat(StatsResource.CRITCHANCE))
		critdamage.text = "critdamage: " + str(stats.get_stat(StatsResource.CRITDAMAGE))
		ghostly.text = "ghostly: " + str(stats.get_stat(StatsResource.GHOSTLY))
		regen.text = "regen: " + str(stats.get_stat(StatsResource.REGEN))
		magnetize.text = "magnetize: " + str(stats.get_stat(StatsResource.MAGNETIZE))
		lifesteal.text = "lifesteal: " + str(stats.get_stat(StatsResource.LIFESTEAL))
		bonusvselites.text = "bonusvselites: " + str(stats.get_stat(StatsResource.BONUSVSELITES))
		shield.text = "shield: " + str(stats.get_stat(StatsResource.SHIELD))
		difficulty.text = "difficulty: " + str(stats.get_stat(StatsResource.DIFFICULTY))
		revies.text = "revies: " + str(stats.get_stat(StatsResource.REVIES))
		thorns.text = "thorns: " + str(stats.get_stat(StatsResource.THORNS))
		inaccuracy.text = "inaccuracy: " + str(stats.get_stat(StatsResource.INACCURACY))
func sort_random():
	array.shuffle()
	reset_children()
func sort_reverse_alphabetically():
	array.sort_custom(func(a, b): return a.name > b.name)
	reset_children()
func sort_alphabetically():
	array.sort_custom(func(a, b): return a.name < b.name)
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
		label_parent.move_child(array[i], i)
## Hides stats that aren't changed from default value
func hide_defaults():
	if stats.is_stat_default(StatsResource.DAMAGE):
		damage.visible = false
	else:
		damage.visible = true
	if stats.is_stat_default(StatsResource.RANGE):
		_range.visible = false
	else:
		_range.visible = true
	if stats.is_stat_default(StatsResource.WEIGHT):
		weight.visible = false
	else:
		weight.visible = true
	if stats.is_stat_default(StatsResource.ATTACKSPEED):
		attackspeed.visible = false
	else:
		attackspeed.visible = true
	if stats.is_stat_default(StatsResource.VELOCITY):
		velocity.visible = false
	else:
		velocity.visible = true
	if stats.is_stat_default(StatsResource.COUNT):
		count.visible = false
	else:
		count.visible = true
	if stats.is_stat_default(StatsResource.PIERCING):
		piercing.visible = false
	else:
		piercing.visible = true
	if stats.is_stat_default(StatsResource.DURATION):
		duration.visible = false
	else:
		duration.visible = true
	if stats.is_stat_default(StatsResource.BUILDUP):
		buildup.visible = false
	else:
		buildup.visible = true
	if stats.is_stat_default(StatsResource.SIZE):
		_size.visible = false
	else:
		_size.visible = true
	if stats.is_stat_default(StatsResource.HP):
		hp.visible = false
	else:
		hp.visible = true
	if stats.is_stat_default(StatsResource.STANCE):
		stance.visible = false
	else:
		stance.visible = true
	if stats.is_stat_default(StatsResource.MOVESPEED):
		movespeed.visible = false
	else:
		movespeed.visible = true
	if stats.is_stat_default(StatsResource.XP):
		xp.visible = false
	else:
		xp.visible = true
	if stats.is_stat_default(StatsResource.MOGUL):
		mogul.visible = false
	else:
		mogul.visible = true
	if stats.is_stat_default(StatsResource.LUCK):
		luck.visible = false
	else:
		luck.visible = true
	if stats.is_stat_default(StatsResource.CRITCHANCE):
		critchance.visible = false
	else:
		critchance.visible = true
	if stats.is_stat_default(StatsResource.CRITDAMAGE):
		critdamage.visible = false
	else:
		critdamage.visible = true
	if stats.is_stat_default(StatsResource.GHOSTLY):
		ghostly.visible = false
	else:
		ghostly.visible = true
	if stats.is_stat_default(StatsResource.REGEN):
		regen.visible = false
	else:
		regen.visible = true
	if stats.is_stat_default(StatsResource.MAGNETIZE):
		magnetize.visible = false
	else:
		magnetize.visible = true
	if stats.is_stat_default(StatsResource.LIFESTEAL):
		lifesteal.visible = false
	else:
		lifesteal.visible = true
	if stats.is_stat_default(StatsResource.BONUSVSELITES):
		bonusvselites.visible = false
	else:
		bonusvselites.visible = true
	if stats.is_stat_default(StatsResource.SHIELD):
		shield.visible = false
	else:
		shield.visible = true
	if stats.is_stat_default(StatsResource.DIFFICULTY):
		difficulty.visible = false
	else:
		difficulty.visible = true
	if stats.is_stat_default(StatsResource.REVIES):
		revies.visible = false
	else:
		revies.visible = true
	if stats.is_stat_default(StatsResource.THORNS):
		thorns.visible = false
	else:
		thorns.visible = true
	if stats.is_stat_default(StatsResource.INACCURACY):
		inaccuracy.visible = false
	else:
		inaccuracy.visible = true
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
		label.visible = false
func hide_players():
	for label in players:
		array.erase(label)
		default_order.erase(label)
		label.visible = false
func hide_misc():
	for label in misc:
		array.erase(label)
		default_order.erase(label)
		label.visible = false
## Gets the name of all stats objects affecting this one
func get_affecting_names():
	var a: Array[StatsResource]
	stats.GetAllStatsRecursive(a)

func button1():
	if is_ready:
		get_affecting_names()
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
