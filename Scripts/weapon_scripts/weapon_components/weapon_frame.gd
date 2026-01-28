extends Area2D
class_name Weapon_Frame
const SCENE = preload("res://Scenes/Weapons/weapon_frame.tscn")
#weapon_frame fields
@onready var player: Character = get_tree().get_first_node_in_group("player")
#components
@export var handle: Handle = null
@export var attachment: Attachment = null
@export var projectile: Projectile
@onready var manager = get_tree().get_first_node_in_group("weapon_manager")
@export var stats: StatsResource
var data: ItemData
var QueuedAttacks: Array[AttackEvent] = [] #TODO: not used, to create attack need to use stats which defeats point of queue
func _process(_delta: float) -> void:
	if !QueuedAttacks.is_empty():
		for event in QueuedAttacks:
			QueuedAttacks.erase(event)
			if is_instance_valid(event.attackee) && is_instance_valid(event.attacker):
				event.attacker.attack_body(event.attackee, event.clone)
## Returns nearest enemy or null
func get_nearest_enemy() -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if nearest_enemy == null:
			nearest_enemy = enemy
		elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = enemy
	return nearest_enemy
func get_enemy_nearby(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
	return nearest_enemy
## Returns all enemies within distance
func get_enemies_nearby(distance: float) -> Array[Enemy]:
	var enemies = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			enemies.append(enemy)
	return enemies
## Sets the weapon's slot in reference to all weapons charcater has, used for calculating position
func change_slot(slot: int, _max: int) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	handle.weapon_slot = slot
	handle.weapon_count = _max #TODO: Only Static Slot (cardinal direction) weapons should add to this thing
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
		apply_stats()
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
		apply_stats()
		set_variables()
		return true
func add_projectile(projecty: Projectile) -> bool:
	#print(projecty.name)
	if (projectile != null):
		push_error("Projectile was not null when trying to add_projectile")
		return false
	else:
		projectile = projecty
		stats.add_stats(projectile.stats) #TODO: ensure projectile.stats are initialized by the export values/unique value/.tres file or whatever by this point
		apply_stats()
		set_variables()
		return true
func remove_attachment() -> Attachment:
	if (attachment == null):
		#print("Handle was null when trying to remove_handle")
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
		#print("Handle was null when trying to remove_handle")
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
		#print("Projectile was null when trying to remove_projectile")
		return null
	else:
		stats.remove_stats(projectile.stats)
		var temp = projectile
		projectile = null
		return temp
## Give components references to each other
func set_variables():
	if handle != null && attachment != null && projectile != null:
		handle.attachment = attachment
		attachment.handle = handle
		attachment.projectile = projectile
		#handle.player = player
		attachment.frame = self
		handle.frame = self
		if data:
			name = data.item_name#(handle.name + attachment.name + projectile.name).replace("_attachment", "").replace("_handle", "").replace("_projectile", "")
		#stats.setup(name)
	pass
## Do anything that needs to be done to utilize a stat change
func apply_stats() -> void: 
	var size: float = StatsResource.calculate_scale(get_stat(StatsResource.SIZE))
	scale = Vector2(size, size)
	if handle != null:
		handle.scale = scale
	if attachment != null:
		attachment.scale = scale
func get_stat(string: String) -> float:#Return stat value given stat const name
	return stats.get_stat(string)
func get_stats():
	return stats
class AttackEvent:
	var attackee: Node
	var attacker: Node
	var clone: bool
	func _init(new_attackee: Node, new_attacker: Node, is_clone: bool):
		clone = is_clone
		attackee = new_attackee
		attacker = new_attacker

## Sets up a RightClickMenu for this component
func setup_right_click_menu(menu: RightClickMenu):
	menu.set_bools(data.can_feed, data.can_sell, false, data.can_dismantle)
