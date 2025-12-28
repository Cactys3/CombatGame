extends VBoxContainer
class_name StatsList
## Labels
@onready var title: Label = $Title
@onready var damage: Label = $damage
@onready var _range: Label = $range
@onready var weight: Label = $weight
@onready var attackspeed: Label = $attackspeed
@onready var velocity: Label = $velocity
@onready var count: Label = $count
@onready var piercing: Label = $piercing
@onready var duration: Label = $duration
@onready var buildup: Label = $buildup
@onready var _size: Label = $size
@onready var hp: Label = $hp
@onready var stance: Label = $stance
@onready var movespeed: Label = $movespeed
@onready var xp: Label = $xp
@onready var mogul: Label = $mogul
@onready var luck: Label = $luck
@onready var critchance: Label = $critchance
@onready var critdamage: Label = $critdamage
@onready var ghostly: Label = $ghostly
@onready var regen: Label = $regen
@onready var magnetize: Label = $magnetize
@onready var lifesteal: Label = $lifesteal
@onready var bonusvselites: Label = $bonusvselites
@onready var shield: Label = $shield
@onready var difficulty: Label = $difficulty
@onready var revies: Label = $revies
@onready var thorns: Label = $thorns
@onready var inaccuracy: Label = $inaccuracy
## Dictionary of labels + consts
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
var stats: StatsResource
var ID = -1.0
var set_color: bool = false
var label: Label
func setup(new_stats: StatsResource, new_id: int):
	if new_stats:
		stats = new_stats
		ID = new_id
		call_deferred("deferred")
## Set the given stat label to given value of visibility
func set_stat_visible(key: String, value: bool) -> void:
	if statslabels.has(key):
		statslabels[key].visible = value
## Deferred to wait for ready()
func deferred():
	if stats:
		refresh()
	if ID == 1:
		title.clip_text = false
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		for currlabel in statslabels:
			statslabels[currlabel].clip_text = false
			statslabels[currlabel].horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	var new_color: Color = Color(clampf(fposmod(1 - (0.1*ID) + randf_range(0, 0.2), 1.0), 0.2, 0.9), clampf(fposmod(1 - (0.1*ID) + randf_range(0, 0.2), 1.0), 0.2, 0.9),clampf(fposmod(1 - (0.1*ID) + randf_range(0, 0.2), 1.0), 0.2, 0.9))
	modulate = new_color
func refresh():
	var before: String = ""
	var after: String = ""
	if ID == 1:
		after = " = "
	else:
		before = " + "
		title.text = stats.parent_object_name
		if title.text.to_lower().contains("handle"):
			title.text = "Handle"
		if title.text.to_lower().contains("projectile") || title.text.to_lower().contains("bullet"):
			title.text = "Projectile"
		if title.text.to_lower().contains("attachment"):
			title.text = "Attachment"
	
	var everything_is_zero = true
	for stat in statslabels:
		if !stats.is_stat_default(stat):
			everything_is_zero = false
		var number: String = str(snapped(stats.get_stat(stat), 0.01))
		var decimals = 5 - number.split(".")[0].length()
		if decimals > 0:
			if "." in number:
				number = number.rstrip("0").rstrip(".")
		else:
			number = number.split(".")[0]
			print("would be: " + str(snapped(stats.get_stat(stat), 0.01)))
			print("but is cut to: " + str(number))
		statslabels[stat].text = before + number + after
	
	if everything_is_zero:
		visible = false
	else:
		visible = true

## Reorders given label to given position
func reorder(key: String, new_position: int):
	move_child(statslabels[key], new_position)
func _on_mouse_entered() -> void:
	if ID != -1:
		label = Label.new()
		label.text = stats.parent_object_name
		label.modulate = modulate
		label.add_theme_constant_override("outline_size", 10)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		GameManager.instance.ui_man.static_ui_parent.add_child(label)
		label.global_position = get_viewport().get_mouse_position()
		
		## TODO: Have OnClick, make a new StatsVisual that shows the stats affectin this StatList but NOT the original StatsVisual
		## Free it on unhover or click again
func _on_mouse_exited() -> void:
	if ID != -1:
		label.queue_free()
