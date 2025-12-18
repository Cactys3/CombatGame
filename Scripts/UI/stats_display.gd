class_name StatsDisplay
extends Control

@export var stats: StatsResource

const SCENE = preload("res://Scenes/UI/stats_visual.tscn")

@export var only_show_changed: bool = false

@export var hide_damage: bool = false
@export var hide_range: bool = false
@export var hide_weight: bool = false
@export var hide_attackspeed: bool = false
@export var hide_velocity: bool = false
@export var hide_count: bool = false
@export var hide_piercing: bool = false
@export var hide_duration: bool = false
@export var hide_buildup: bool = false
@export var hide_size: bool = false
@export var hide_hp: bool = false
@export var hide_stance: bool = false
@export var hide_movespeed: bool = false
@export var hide_xp: bool = false
@export var hide_mogul: bool = false
@export var hide_luck: bool = false
@export var hide_critchance: bool = false
@export var hide_critdamage: bool = false
@export var hide_ghostly: bool = false
@export var hide_regen: bool = false
@export var hide_magnetize: bool = false
@export var hide_lifesteal: bool = false
@export var hide_bonusvselites: bool = false
@export var hide_shield: bool = false
@export var hide_difficulty: bool = false
@export var hide_revies: bool = false
@export var hide_thorns: bool = false
@export var hide_inaccuracy: bool = false
## Labels
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
@onready var hp: Label = $VBoxContainer/ScrollContainer/VBoxContainer/hp
@onready var stance: Label = $VBoxContainer/ScrollContainer/VBoxContainer/stance
@onready var movespeed: Label = $VBoxContainer/ScrollContainer/VBoxContainer/movespeed
@onready var xp: Label = $VBoxContainer/ScrollContainer/VBoxContainer/xp
@onready var mogul: Label = $VBoxContainer/ScrollContainer/VBoxContainer/mogul
@onready var luck: Label = $VBoxContainer/ScrollContainer/VBoxContainer/luck
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

@onready var label_parent: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer

var last_clicked: float = -1
var array: Array[Label]
var default_order: Array[Label]
#var stopwatch: float = 0
#func _process(delta: float) -> void:
	#stopwatch += delta
	#if (stopwatch > 3):
		#refresh()
		#stopwatch = 0
func set_stats(new_stats: StatsResource, new_name: String):
	stats = new_stats
	name = new_name
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(refresh)
	timer.wait_time = 3.0
	timer.start()
	refresh()
func _ready():
	if stats:
		set_stats(stats, stats.parent_object_name)
	array = [damage, _range, weight, attackspeed, velocity, count, duration, _size, buildup, stance, hp, xp, mogul, movespeed, piercing, luck, critchance, critdamage, ghostly, regen, magnetize, lifesteal, bonusvselites, shield, difficulty, revies, thorns, inaccuracy]
	default_order = [damage, _range, weight, attackspeed, velocity, count, duration, _size, buildup, stance, hp, xp, mogul, movespeed, piercing, luck, critchance, critdamage, ghostly, regen, magnetize, lifesteal, bonusvselites, shield, difficulty, revies, thorns, inaccuracy]
	hide_hides()
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
	if hide_damage: 
		array.erase(damage)
		default_order.erase(damage)
		damage.visible = false
	if hide_range: 
		array.erase(_range)
		default_order.erase(_range)
		_range.visible = false
	if hide_weight: 
		array.erase(weight)
		default_order.erase(weight)
		weight.visible = false
	if hide_attackspeed: 
		array.erase(attackspeed)
		default_order.erase(attackspeed)
		attackspeed.visible = false
	if hide_velocity: 
		array.erase(velocity)
		default_order.erase(velocity)
		velocity.visible = false
	if hide_count: 
		array.erase(count)
		default_order.erase(count)
		count.visible = false
	if hide_piercing: 
		array.erase(piercing)
		default_order.erase(piercing)
		piercing.visible = false
	if hide_duration: 
		array.erase(duration)
		default_order.erase(duration)
		duration.visible = false
	if hide_buildup: 
		array.erase(buildup)
		default_order.erase(buildup)
		buildup.visible = false
	if hide_size: 
		array.erase(_size)
		default_order.erase(_size)
		_size.visible = false
	if hide_hp: 
		array.erase(hp)
		default_order.erase(hp)
		hp.visible = false
	if hide_stance: 
		array.erase(stance)
		default_order.erase(stance)
		stance.visible = false
	if hide_movespeed: 
		array.erase(movespeed)
		default_order.erase(movespeed)
		movespeed.visible = false
	if hide_xp: 
		array.erase(xp)
		default_order.erase(xp)
		xp.visible = false
	if hide_mogul: 
		array.erase(mogul)
		default_order.erase(mogul)
		mogul.visible = false
	if hide_luck: 
		array.erase(luck)
		default_order.erase(luck)
		luck.visible = false
	if hide_critchance: 
		array.erase(critchance)
		default_order.erase(critchance)
		critchance.visible = false
	if hide_critdamage: 
		array.erase(critdamage)
		default_order.erase(critdamage)
		critdamage.visible = false
	if hide_ghostly: 
		array.erase(ghostly)
		default_order.erase(ghostly)
		ghostly.visible = false
	if hide_regen: 
		array.erase(regen)
		default_order.erase(regen)
		regen.visible = false
	if hide_magnetize: 
		array.erase(magnetize)
		default_order.erase(magnetize)
		magnetize.visible = false
	if hide_lifesteal: 
		array.erase(lifesteal)
		default_order.erase(lifesteal)
		lifesteal.visible = false
	if hide_bonusvselites: 
		array.erase(bonusvselites)
		default_order.erase(bonusvselites)
		bonusvselites.visible = false
	if hide_shield: 
		array.erase(shield)
		default_order.erase(shield)
		shield.visible = false
	if hide_difficulty: 
		array.erase(difficulty)
		default_order.erase(difficulty)
		difficulty.visible = false
	if hide_revies: 
		array.erase(revies)
		default_order.erase(revies)
		revies.visible = false
	if hide_thorns: 
		array.erase(thorns)
		default_order.erase(thorns)
		thorns.visible = false
	if hide_inaccuracy: 
		array.erase(inaccuracy)
		default_order.erase(inaccuracy)
		inaccuracy.visible = false
## Gets the name of all stats objects affecting this one
func get_affecting_names():
	var a: Array[StatsResource]
	stats.GetAllStatsRecursive(a)
	for stat in a:
		print(stat.parent_object_name)

func button1():
	get_affecting_names()
	if last_clicked == 1:
		sort_reverse_default()
		last_clicked = -1
	else:
		sort_default()
		last_clicked = 1
func button2():
	if last_clicked == 2:
		sort_reverse_alphabetically()
		last_clicked = -1
	else:
		sort_alphabetically()
		last_clicked = 2
func button3():
	only_show_changed = !only_show_changed
	refresh()
func button4():
	sort_random()
	last_clicked = 4
