extends Node2D
class_name HealthComponent

@export var parent_script:CharacterBody2D
#TODO: implement hp regen, knockback modifier
@export var max_health:int = 0
@export var hp_regen:float = 0
@export var knockback_modifier:float = 1
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
var health:int
var stunning:bool = false
var stun_time_left: float = 0
func _ready() -> void:
	health = max_health
	pass 

func _process(_delta: float) -> void:
	if stun_time_left > 0:
		stun_time_left -= _delta
	elif stunning:
		stunning = false
		parent_script.stun(false)
	pass

func damage(attack: Attack):
	health -=attack.damage
	#print(parent_script.name + " damaged: " + str(attack.damage))
	if attack.stun_time > 0 && can_be_stunned && parent_script.has_method("stun"):
			stun_time_left = attack.stun_time
			stunning = true
			parent_script.stun(true)
			parent_script.velocity = Vector2.ZERO
	if can_be_knockbacked && attack.knockback != 0:
		if stun_time_left < 1 && parent_script.has_method("stun") && can_be_stunned:
			stun_time_left = 0.2
			stunning = true
			parent_script.stun(true)
		call_deferred("set_parent_velocity", (global_position - attack.position).normalized() * attack.knockback * knockback_modifier)
	if health <= 0:
		parent_script.die()
	pass

func set_parent_velocity(value:Vector2):
	parent_script.velocity = value
