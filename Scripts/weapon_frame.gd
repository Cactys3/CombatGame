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

@onready var manager = get_tree().get_first_node_in_group("weapon_manager")

@export var stats: StatsResource = StatsResource.new()

func _ready() -> void:
	#TODO: ADD GLOBAL STATS TO THIS STATS
	#stats.add_stats(global_stats)
	pass

func _process(_delta: float) -> void:
	#print(str(position) + " "  + " " + str(position))
	pass

func get_enemy_nearby(distance: float) -> Variant:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			return enemy.global_position
	return null

func hit_enemy(body:Node2D):
	if (body.has_method("damage")):
		var new_attack: Attack = Attack.new()
		new_attack.damage = get_stat(stats.DAMAGE)
		new_attack.knockback = get_stat(stats.KNOCKBACK)
		new_attack.stun_time = get_stat(stats.STUN)
		new_attack.position = player.global_position #TODO: decide vs using weapon's position or player's
		new_attack.damage_effect = Attack.damage_effects.none
		body.damage(new_attack)
		pass

func change_slot(slot: int, max) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = max

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
		set_offset()
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
		set_offset()
		set_variables()
		return true

func set_projectile(projecty: PackedScene) -> void:
	projectile = projecty
	#handle_stats()
	#set_offset()
	set_variables()

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
		handle_stats()
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
		handle_stats()
		var temp:Handle = handle
		handle = null
		return temp

func set_offset():#Set Position of components according to their size
	if handle != null && attachment != null:
		#handle.position += handle.offset
		#attachment.position += attachment.offset + handle.offset
		pass
	pass

func set_variables():#Give components references to each other
	if handle != null && attachment != null && projectile != null:
		handle.attachment = attachment
		attachment.handle = handle
		attachment.projectile = projectile
		#handle.player = player
		attachment.frame = self
		handle.frame = self
	pass

func handle_stats() -> void: #Do anything that needs to be done to utilize a stat change
	scale = Vector2(1 + get_stat(stats.SIZE), 1 + get_stat(stats.SIZE))

func get_stat(string: String) -> float:#Return stat value given stat const name
	return stats.get_stat(string)
