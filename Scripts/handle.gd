extends Area2D
class_name Handle
#Stat Modifiers
@export var stats = {
	Weapon_Frame.damage: 0,
	Weapon_Frame.knockback: 0,
	Weapon_Frame.stun: 0,
	Weapon_Frame.effect: Attack.damage_effects.none,
	Weapon_Frame.cooldown: 0,
	Weapon_Frame.range: 0,
	Weapon_Frame.speed: 0,
	Weapon_Frame.size: 0,
	Weapon_Frame.count: 0,
	Weapon_Frame.piercing: 0,
	Weapon_Frame.duration: 0,
	Weapon_Frame.area: 0,
	Weapon_Frame.mogul: 0,
	Weapon_Frame.xp: 0,
	Weapon_Frame.lifesteal: 0,
	Weapon_Frame.movespeed: 0,
	Weapon_Frame.hp: 0,
	}
#Visual Component
@export var visual: Sprite2D #just have the image be the thing that is in the assing inspector and replace the value within the sprite2d with that

func _ready() -> void:
	var instance = visual.instance()
	instance.position = Vector2.ZERO
	add_child(instance)
