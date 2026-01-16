extends Projectile

#fire class is needed to make animation speed scale with duration/speed/whatever so 
#that the animation is done playing when the timer runs out
#and also so that this doesn't keep track of how many collisions it takes,
#it doesn't care, will go through them all. (do less dmg per hit though?)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const type = preload("uid://boxu6s6bh4u6w")

#func get_instance():
	#var ret: type = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn").instantiate()
	#add_child(ret)
	#ret.status = ret.status.duplicate()
	#ret.stats = ret.stats.duplicate()
	#remove_child(ret)
	#return ret

func _process(delta: float) -> void:
	super(delta)

## changed so it does not die after hitting things but does decrease damage
func attack_body(body: Node2D, clone: bool) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack(clone)
		AttackedObjects.append(body)
		body.damage(new_attack)
		collision_counter += 1 #decrease dmg?
		## Idea: Flame does less damage after passing through each enemy.
		## Counterpoint: Flame probably already does low dmg

func anim_finished() -> void:
	die()
