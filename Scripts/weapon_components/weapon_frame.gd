extends Area2D
class_name Weapon_Frame

const SCENE = preload("res://Scenes/Weapons/weapon_frame.tscn")

#weapon_frame fields
@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
#components
@export var handle: Handle = null
@export var attachment: Attachment = null
@export var projectile: Projectile

@onready var manager = get_tree().get_first_node_in_group("weapon_manager")

@export var stats: StatsResource = StatsResource.new()

var data: ItemData

var QueuedAttacks: Array[AttackEvent] = [] #TODO: not used, to create attack need to use stats which defeats point of queue

var stats_visual

func _ready() -> void:
	stats.parent_object_name = name
	stats.add_stats(GameManager.instance.global_stats)
	#stats = stats.duplicate()
	#TODO: ADD GLOBAL STATS TO THIS STATS
	#stats.add_stats(global_stats)

func _process(_delta: float) -> void:
	if !QueuedAttacks.is_empty():
		for event in QueuedAttacks:
			QueuedAttacks.erase(event)
			if is_instance_valid(event.attackee) && is_instance_valid(event.attacker):
				event.attacker.attack_body(event.attackee)

func make_stats_visual(i: int):
	if stats_visual:
		stats_visual.queue_free()
		stats_visual = null
	const STATS_VISUAL = preload("res://Scenes/UI/stats_visual.tscn")
	stats_visual = STATS_VISUAL.instantiate()
	GameManager.instance.add_child(stats_visual)
	stats_visual.global_position = Vector2(0, i* 20)#Vector2(-310, i * 20)
	print(i)
	stats_visual.set_stats(stats, "W: " + name)

func delete_stats_visual():
	if (stats_visual):
		stats_visual.queue_free()
	stats_visual = null

func get_enemy_nearby(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
	return nearest_enemy

func change_slot(slot: int, max) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	handle.weapon_slot = slot
	handle.weapon_count = max #TODO: Only Static Slot (cardinal direction) weapons should add to this thing

#new methods
func add_handle(handy: Handle) -> bool:
	if (handle != null):
		push_error("Handle was not null when trying to add_handle")
		return false
	else:
		handle = handy
		if (handle.get_parent() != null):
			handle.reparent(self)
		else:
			add_child(handle)
		handle.position = Vector2.ZERO
		handle.rotation = 0
		handle.frame = self
		stats.add_stats(handle.stats)
		handle_stats()
		set_variables()
		return true

func add_attachment(attachy: Attachment) -> bool:
	if (attachment != null):
		push_error("Handle was not null when trying to add_handle")
		return false
	else:
		attachment = attachy
		if (attachment.get_parent() != null):
			attachment.reparent(self)
		else:
			add_child(attachment)
		attachment.position = Vector2.ZERO
		attachment.rotation = 0
		attachment.frame = self
		stats.add_stats(attachment.stats)
		handle_stats()
		set_variables()
		return true

func add_projectile(projecty: Projectile) -> bool:
	if (projectile != null):
		push_error("Projectile was not null when trying to add_projectile")
		return false
	else:
		projectile = projecty
		stats.add_stats(projectile.stats) #TODO: ensure projectile.stats are initialized by the export values/unique value/.tres file or whatever by this point
		handle_stats()
		set_variables()
		return true

func remove_attachment() -> Attachment:
	if (attachment == null):
		print("Handle was null when trying to remove_handle")
		return null
	else:
		remove_child(attachment)
		manager.add_child(attachment)
		attachment.position = Vector2.ZERO
		#attachment.visible = false
		attachment.frame = null
		attachment.handle = null
		attachment.projectile = null
		stats.remove_stats(attachment.stats)
		var temp:Attachment = attachment
		attachment = null
		return temp

func remove_handle() -> Handle:
	if (handle == null):
		print("Handle was null when trying to remove_handle")
		return null
	else:
		remove_child(handle)
		manager.add_child(handle)
		handle.position = Vector2.ZERO
		#handle.visible = false
		handle.frame = null
		handle.attachment = null
		stats.remove_stats(handle.stats)
		var temp:Handle = handle
		handle = null
		return temp

func remove_projectile() -> Projectile:
	if (projectile == null):
		print("Projectile was null when trying to remove_projectile")
		return null
	else:
		stats.remove_stats(projectile.stats)
		var temp = projectile
		projectile = null
		return temp

func set_variables():#Give components references to each other
	if handle != null && attachment != null && projectile != null:
		handle.attachment = attachment
		attachment.handle = handle
		attachment.projectile = projectile
		#handle.player = player
		attachment.frame = self
		handle.frame = self
		name = (handle.name + attachment.name + projectile.name).replace("_attachment", "").replace("_handle", "").replace("_projectile", "")
		stats.parent_object_name = name
	pass

func handle_stats() -> void: #Do anything that needs to be done to utilize a stat change
	scale = Vector2(get_stat(stats.SIZE), get_stat(stats.SIZE))
	if handle != null:
		handle.scale = scale
	if attachment != null:
		attachment.scale = scale

func get_stat(string: String) -> float:#Return stat value given stat const name
	return stats.get_stat(string)

class AttackEvent:
	var attackee: Node
	var attacker: Node
	func _init(new_attackee: Node, new_attacker: Node):
		attackee = new_attackee
		attacker = new_attacker
