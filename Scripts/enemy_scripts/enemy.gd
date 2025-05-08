extends CharacterBody2D
class_name Enemy

@export var stats: StatsResource# = StatsResource.new()
@export var damage_hitbox:Area2D
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
@export var xp_on_death: int
@export var money_on_death: int
@export var weapon_knockback: float
@export var weapon_stun: float
@export var base_damage: float
@export var base_movespeed: float
@export var base_health: float
@export var base_regen: float
@export var base_knockback_modifier: float
@export var base_damage_reduction: float
@export var base_cooldown: float
const POPUP_TEXT = preload("res://Scenes/UI/popup_text.tscn")
const xp = preload("res://Scenes/xp_blip.tscn")
var player: Player_Script
var xp_parent
var attack_on_cd: bool = true
var stun_time_left: float = 0
var stunned: bool = false
var curr_health: float
var curr_movespeed: float 
var curr_regen: float 
var curr_knockback_modifier: float
var curr_damage_reduction: float
var curr_cooldown_max: float
var cooldown_stopwatch: float = 0

var max_health: float:
	get:
		return stats.get_stat(stats.HP) + base_health

var ImReady: bool = false

func _ready() -> void:
	call_deferred("set_stats")
	cooldown_stopwatch = 0 # make it ready to attack on start?
	add_to_group("enemy")

func _process(delta: float) -> void:
	if !ImReady:
		return
	
	if stun_time_left > 0:
		stun_time_left -= delta
	elif stunned:
		stunned = false
	
	if cooldown_stopwatch < curr_cooldown_max:
		cooldown_stopwatch += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player

func _physics_process(_delta: float) -> void:
	if !ImReady:
		return
	if !stunned:
		movement_process(_delta)
	move_and_slide()

func set_stats():
	curr_health = stats.get_stat(stats.HP) + base_health
	curr_movespeed = stats.get_stat(stats.MOVESPEED) + base_movespeed
	curr_regen = base_regen #+ stats.get_stat(stats.REGEN)
	curr_knockback_modifier = base_knockback_modifier + stats.get_stat(stats.WEIGHT)
	curr_damage_reduction = base_damage_reduction + stats.get_stat(stats.STANCE)
	curr_cooldown_max = base_cooldown #+ (5 / (stats.get_stat(stats.ATTACKSPEED) + 0.1))
	player = get_tree().get_first_node_in_group("player")
	xp_parent = get_tree().get_first_node_in_group("xp_parent")
	ImReady = true

func die():
	GameManager.instance.money += money_on_death
	var new_xp = xp.instantiate()
	new_xp.global_position = global_position
	xp_parent.call_deferred("add_child", new_xp)
	new_xp.set_xp(xp_on_death)
	queue_free()

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") && body.is_in_group("player"):
		cooldown_stopwatch = 0;
		var attack: Attack = Attack.new()
		attack.setup(attack.damage, position, 0, StatusEffectDictionary.new(), self, weapon_stun, 0, weapon_knockback)
		body.damage(attack)
		damage_hitbox.set_deferred("monitoring", false)

func movement_process(_delta: float) ->void:
	move_towards(player.global_position, _delta)

func move_towards(new_position: Vector2, delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	velocity = velocity.move_toward(Vector2(direction.x * curr_movespeed, direction.y * curr_movespeed), 9)

func is_player_nearby(distance: float) -> bool:
	if position.distance_to(player.position) <= distance:
		return true
	return false

func damage(attack: Attack):
	var damage_taken = attack.damage - curr_damage_reduction 
	if damage_taken > 0:
		curr_health -= damage_taken
	if attack.stun > 0 && can_be_stunned:
			stun_time_left = attack.stun
			stunned = true
			velocity = Vector2.ZERO
	if can_be_knockbacked && attack.knockback != 0:
		if stun_time_left < 1 && can_be_stunned:
			stun_time_left = 0.2
			stunned = true
		call_deferred("set_velocity", (global_position - attack.position).normalized() * attack.knockback * curr_knockback_modifier)
	var dmg_text: PopupText = POPUP_TEXT.instantiate()
	dmg_text.setup(str(attack.damage), damage_taken, global_position, 1, get_tree().root, Vector2(10, 10))
	if curr_health <= 0:
		die()
