extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_attachment.tscn")
@onready var collision: CollisionShape2D = $CollisionShape2D

##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

var attacked_objects: Array[Node2D] = []

var hitbox: CollisionShape2D

func _ready() -> void:
	super()
	collision.disabled = true

func _process(delta: float) -> void:
	super(delta)

func attack():
	attacked_objects.clear()
	visual.play("Attack")
	var total_time: float = frame.stats.get_stat(StatsResource.DURATION)
	## Damage enemies every 0.6 seconds
	var time_between_cycles: float = 0.6
	## Damage enemies for 0.1 seconds (hitbox out)
	var time_during_cycles: float = 0.1
	var num_of_cycles: float = total_time / (time_between_cycles + time_during_cycles)
	var index = 1
	## Cycle a number of times, waiting for duration, damaging enemies with railgun attachment 'melee' beam
	while(index < num_of_cycles):
		index += 1
		attacked_objects.clear()
		collision.disabled = false
		await get_tree().create_timer(time_during_cycles).timeout
		collision.disabled = true
		await get_tree().create_timer(time_between_cycles).timeout
	super()
	visual.play("PostAttack")

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.7), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.ATTACKSPEED, randf_range(-0.3, 1.2), 0.01, 0)
	return newstats

func _on_body_entered(body: Node2D) -> void: 
	if (!attacked_objects.has(body) && body.has_method("damage")): #Hit each enemy only once per melee attack
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self, false)) #TODO: find out if really necessary to queue
		attacked_objects.append(body)
func _on_area_entered(body: Area2D) -> void:
	if (!attacked_objects.has(body) && body.has_method("damage")): #Hit each enemy only once per melee attack
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self, false)) #TODO: find out if really necessary to queue
		attacked_objects.append(body)

func attack_body(body: Node, clone: bool) -> void:
	var new_attack = make_attack()
	body.damage(new_attack)
