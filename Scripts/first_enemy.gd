extends CharacterBody2D

const MOVESPEED: int = 100
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var health_component:HealthComponent

@export var weapon_damage: int
@export var weapon_knockback: int
@export var weapon_stun: int
@export var weapon_effect: Attack.damage_effects

func damage(attack: Attack):
	if (health_component):
		health_component.damage(attack)

func _physics_process(_delta: float) -> void:
	move_towards(player.position)

func move_towards(new_position: Vector2):
	var direction: Vector2 = (new_position - position).normalized()
	velocity.x = direction.x * MOVESPEED
	velocity.y = direction.y * MOVESPEED
	velocity = velocity.move_toward(Vector2(direction.x * MOVESPEED, direction.y * MOVESPEED), 50)
	move_and_slide()

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	var attack: Attack = Attack.new()
	attack.damage = weapon_damage
	attack.knockback = weapon_knockback
	attack.stun_time = weapon_stun
	attack.position = position
	attack.damage_effect = weapon_effect
	damage(attack)
