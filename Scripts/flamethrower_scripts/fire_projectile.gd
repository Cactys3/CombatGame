extends Projectile

#fire class is needed to make animation speed scale with duration/speed/whatever so 
#that the animation is done playing when the timer runs out
#and also so that this doesn't keep track of how many collisions it takes,
#it doesn't care, will go through them all. (do less dmg per hit though?)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var attack:Attack = Attack.new()

func get_scene() -> PackedScene:
	return preload("res://Scenes/flamethrower/fire_projectile.tscn")

## called in ready
func setdata():
	var descrip = "A projectile of hot flame which goes through every enemy in its path, but quickly fades, Cost/Mod: " + str(5) + str(0.8)
	var image = preload("res://Art/New_Weapons/flamethrower/Fire_Flamethrower.png")
	data.setdata("Flame", descrip, ItemData.PROJECTILE, "common", Color.CORAL, image, 5, 0.8)

func _process(delta: float) -> void:
	super(delta)

## changed so it does not die after hitting things but does decrease damage
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		AttackedObjects.append(body)
		body.damage(new_attack)
		collision_counter += 1 #decrease dmg?
		if stats.get_stat(StatsResource.DAMAGE) > 2:
			stats.set_stat_base(StatsResource.DAMAGE, stats.get_stat_base(StatsResource.DAMAGE) * 0.8)

func anim_finished() -> void:
	die()
