extends CharacterBody2D

@onready var xp_parent = get_tree().get_first_node_in_group("xp_parent")
const xp = preload("res://Scenes/xp_blip.tscn")

@export var MOVESPEED: int
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var health_component:HealthComponent
@export var damage_hitbox:Area2D

@export var xp_on_death: int
@export var money_on_death: int

@export var weapon_damage: int
@export var weapon_knockback: int
@export var weapon_stun: int
@export var weapon_effect: Attack.damage_effects

@export var range: float
@export var cooldown_default: float
var cooldown_timer: float = 0
var attack_on_cd: bool = true
var stunned: bool = false

func damage(attack: Attack):
	if (health_component):
		health_component.damage(attack)
		print("enemy damaged: " + str(attack.damage))

func _ready() -> void:
	cooldown_timer = cooldown_default + 1
	add_to_group("enemy")

func _process(delta: float) -> void:
	if cooldown_timer < cooldown_default:
		cooldown_timer += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player

func _physics_process(_delta: float) -> void:
	if !stunned:
		movement_process(_delta)
	move_and_slide()

func movement_process(_delta: float) ->void:
	move_towards(player.position, _delta)

func move_towards(new_position: Vector2, delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	#velocity.x = direction.x * MOVESPEED
	#velocity.y = direction.y * MOVESPEED
	velocity = velocity.move_toward(Vector2(direction.x * MOVESPEED, direction.y * MOVESPEED), 9)

func is_player_nearby(distance: float) -> bool:
	if position.distance_to(player.position) <= distance:
		return true
	return false

func _on_damage_hitbox_body_entered(body: Node2D) -> void:

	if body.has_method("damage") && body.is_in_group("player"):
		cooldown_timer = 0;
		var attack: Attack = Attack.new()
		attack.damage = weapon_damage
		attack.knockback = weapon_knockback
		attack.stun_time = weapon_stun
		attack.position = global_position
		attack.damage_effect = weapon_effect
		body.damage(attack)
		damage_hitbox.set_deferred("monitoring", false)

func stun(value:bool):
	stunned = value

func die():
	player.current_money += money_on_death
	var new_xp = xp.instantiate()
	new_xp.global_position = global_position
	xp_parent.call_deferred("add_child", new_xp)
	new_xp.set_xp(xp_on_death)
	queue_free()
