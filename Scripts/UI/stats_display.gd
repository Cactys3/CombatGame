extends Control

var stats: StatsResource

@export var StartMinimized: bool = false
@onready var toggle_ui: Toggle_UI = $DragBar/ToggleUIButton

const SCENE = preload("res://Scenes/UI/stats_visual.tscn")

@onready var damage: Label = $damage
@onready var range: Label = $range
@onready var weight: Label = $weight
@onready var attackspeed: Label = $attackspeed
@onready var velocity: Label = $velocity
@onready var count: Label = $count
@onready var duration: Label = $duration
@onready var _size: Label = $size
@onready var buildup: Label = $buildup
@onready var stance: Label = $stance
@onready var hp: Label = $hp
@onready var xp: Label = $xp
@onready var mogul: Label = $mogul
@onready var movespeed: Label = $movespeed

@onready var drag_bar: DraggableUI = $DragBar

var stopwatch: float = 0

func set_stats(new_stats: StatsResource, new_name: String):
	stats = new_stats
	drag_bar.set_label(new_name)
	refresh()

func _ready() -> void:
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
	if StartMinimized:
		toggle_ui.call_deferred("_toggled", true)

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
