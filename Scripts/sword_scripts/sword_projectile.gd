extends Projectile

const type = preload("res://Scripts/sword_scripts/sword_projectile.gd")

func get_instance():
	var ret: type = preload("res://Scenes/sword/sword_projectile.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	ret.my_stats = ret.my_stats.duplicate()
	remove_child(ret)
	if !(ret.status.attack_bleed + ret.stats.get_stat(stats.ATTACKSPEED) + ret.my_stats.get_stat(stats.ATTACKSPEED)) || !ret.status.attack_bleed || !ret.stats || !ret.my_stats:
		print("Determined that I need this print statment or the runtime will not load the @export variables from any custom resources. Must do something to Custom Resources before returning instance for all Projectiles (maybe other components too)" + str(ret.status.attack_bleed))
	return ret

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var attack:Attack = Attack.new()

## called in ready
func setdata():
	var descrip = "Sword Wave Projectile!!!! Cost/Mod: " + str(6) + str(0.8)
	var image = preload("res://Art/New_Weapons/Sword/projectile_sword.png")
	data.setdata("Flame", descrip, ItemData.PROJECTILE, "common", Color.MEDIUM_PURPLE, image, 5, 0.8)

func _process(delta: float) -> void:
	super(delta)

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		AttackedObjects.append(body)
