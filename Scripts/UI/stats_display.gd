class_name StatsDisplay
extends Control

var stats: StatsResource

@export var StartMinimized: bool = false
@onready var toggle_ui: Toggle_UI = $DragBar/ToggleUIButton

const SCENE = preload("res://Scenes/UI/stats_visual.tscn")

@onready var damage: Label = $Panel/damage
@onready var range: Label = $Panel/range
@onready var weight: Label = $Panel/weight
@onready var attackspeed: Label = $Panel/attackspeed
@onready var velocity: Label = $Panel/velocity
@onready var count: Label = $Panel/count
@onready var duration: Label = $Panel/duration
@onready var _size: Label = $Panel/size
@onready var buildup: Label = $Panel/buildup
@onready var stance: Label = $Panel/stance
@onready var hp: Label = $Panel/hp
@onready var xp: Label = $Panel/xp
@onready var mogul: Label = $Panel/mogul
@onready var movespeed: Label = $Panel/movespeed

@onready var drag_bar: DraggableUI = $DragBar

var stopwatch: float = 0

func set_stats(new_stats: StatsResource, new_name: String):
	stats = new_stats
	drag_bar.set_label(new_name)
	name = new_name
	refresh()

func _ready() -> void:
	toggle_ui.StartDisabled = StartMinimized
	damage.text = "damage: "
	range.text = "range: "
	weight.text = "weight: "
	attackspeed.text = "attackspeed: "
	velocity.text = "velocity: "
	count.text = "count: "
	duration.text = "duration: "
	_size.text = "size: "
	buildup.text = "buildup: "
	stance.text = "stance: "
	hp.text = "hp: "
	xp.text = "xp: "
	mogul.text = "mogul: "
	movespeed.text = "movespeed: "

func _process(delta: float) -> void:
	stopwatch += delta
	if (stopwatch > 3):
		refresh()
		stopwatch = 0

func refresh():
	if stats:
		damage.text = "damage: " + str(stats.get_stat(StatsResource.DAMAGE))
		range.text = "range: " + str(stats.get_stat(StatsResource.RANGE))
		weight.text = "weight: " + str(stats.get_stat(StatsResource.WEIGHT))
		attackspeed.text = "attackspeed: " + str(stats.get_stat(StatsResource.ATTACKSPEED))
		velocity.text = "velocity: " + str(stats.get_stat(StatsResource.VELOCITY))
		count.text = "count: " + str(stats.get_stat(StatsResource.COUNT))
		duration.text = "duration: " + str(stats.get_stat(StatsResource.DURATION))
		_size.text = "size: " + str(stats.get_stat(StatsResource.SIZE))
		buildup.text = "buildup: " + str(stats.get_stat(StatsResource.BUILDUP))
		stance.text = "stance: " + str(stats.get_stat(StatsResource.STANCE))
		hp.text = "hp: " + str(stats.get_stat(StatsResource.HP))
		xp.text = "xp: " + str(stats.get_stat(StatsResource.XP))
		mogul.text = "mogul: " + str(stats.get_stat(StatsResource.MOGUL))
		movespeed.text = "movespeed: " + str(stats.get_stat(StatsResource.MOVESPEED))
