extends Projectile

const type = preload("res://Scripts/weapon_scripts/sword_scripts/sword_projectile.gd")

#func get_instance():
	#var ret: type = preload("res://Scenes/Weapons/sword/sword_projectile.tscn").instantiate()
	#add_child(ret)
	#ret.status = ret.status.duplicate()
	#ret.stats = ret.stats.duplicate()
	#remove_child(ret)
	#return ret

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	super(delta)

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		AttackedObjects.append(body)

static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret: StatsResource = StatsResource.new()
	#ret.set_stat_base(StatsResource.DAMAGE, randi_range(-1, 3))
	
	ret.parent_object_name = "Magic Ball Rolls"
	return ret
