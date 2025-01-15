extends Area2D
class_name Weapon_Frame

#weapon_frame fields
@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
@export var weapon_slot: float = 1
@export var weapon_count: float = 1
#components
@export var handle: Handle
@export var attachment: Attachment
@export var projectile: PackedScene
@export var handle_scn: PackedScene
@export var attachment_scn: PackedScene

@export var stats: StatsResource = StatsResource.new()

func _ready() -> void:
	#TODO: ADD GLOBAL STATS TO THIS STATS
	#stats.add_stats(global_stats)
	pass

func _process(_delta: float) -> void:
	print(str(position) + " "  + " " + str(position))
	pass

func get_enemy_nearby(distance: float) -> Variant:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			return enemy.position
	return null

func hit_enemy(body:Node2D):
	if (body.has_method("damage")):
		#var new_attack: Attack = Attack.new()
		#new_attack.damage = stats[damage]
		#new_attack.knockback = stats[knockback]
		#new_attack.stun_time = stats[stun]
		#new_attack.position = player.global_position #TODO: decide vs using weapon's position or player's
		#new_attack.damage_effect = stats[effect]
		#body.damage(new_attack)
		pass

func change_slot(slot: int, max) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = max

#new methods
func set_handle(handy: PackedScene) -> void:
	if (handle != null):
		handle.queue_free()
		handle = null
	var instance = handy.instantiate()
	instance.position = Vector2.ZERO
	add_child(instance)
	handle = instance
	handle.frame = self
	handle_scn = handy
	set_stats()
	set_offset()
	set_variables()

func set_attachment(attachy: PackedScene) -> void:
	if (attachment != null):
		attachment.queue_free()
		attachment = null
	var instance = attachy.instantiate()
	instance.position = Vector2.ZERO
	add_child(instance)
	attachment = instance
	attachment.frame = self
	attachment_scn = attachy
	set_stats()
	set_offset()
	set_variables()

func set_projectile(projecty: PackedScene) -> void:
	projectile = projecty
	print(projectile.resource_name)

func set_offset():
	if handle != null && attachment != null:
		#handle.position += handle.offset
		#attachment.position += attachment.offset + handle.offset
		pass
	pass

func set_variables():
	if handle != null && attachment != null:
		handle.attachment = attachment
		attachment.handle = handle
		attachment.projectile = projectile
		#handle.player = player
		attachment.frame = self
		handle.frame = self
	pass

func set_stats() -> bool: #sets the stats dictionary to the sum of components
	if handle != null && attachment != null:
		stats.add_stats(handle.stats)
		stats.add_stats(attachment.stats)
		scale = Vector2(1 + get_stat(stats.SIZE), 1 + get_stat(stats.SIZE)) #utilize size
		return true
	return false

func get_stat(string: String) -> float:
	return stats.get_stat(string)
