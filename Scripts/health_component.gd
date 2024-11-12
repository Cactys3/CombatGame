extends Node2D
class_name HealthComponent

#TODO: implement hp regen, knockback modifier
@export var max_health:int
@export var hp_regen:int
@export var knockback_modifier:int = 1
@export var can_be_knockbacked:bool = true
var health:int

func _ready() -> void:
	health = max_health
	pass 

func _process(_delta: float) -> void:
	pass

func damage(attack: Attack):
	health -=attack.damage
	print(get_parent().name + " damaged: " + str(attack.damage))
	if can_be_knockbacked:
		get_parent().velocity = (global_position - attack.position).normalized() * attack.knockback
	
	if health <= 0:
		get_parent().queue_free()
	pass
