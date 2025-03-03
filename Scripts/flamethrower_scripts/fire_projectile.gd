extends Projectile

#fire class is needed to make animation speed scale with duration/speed/whatever so 
#that the animation is done playing when the timer runs out
#and also so that this doesn't keep track of how many collisions it takes,
#it doesn't care, will go through them all. (do less dmg per hit though?)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var newstopwatch: float = 0
var speedoffset = 5 #TODO: implement this with stats


func _process(delta: float) -> void:
	#animated_sprite_2d.speed_scale = 1 #TODO: update animation speed based on stats like: speedValue / DefaultSpeedValue
	global_position += (direction * speed * delta) / speedoffset
	self.scale = Vector2(stats.get_stat(StatsResource.SIZE), stats.get_stat(StatsResource.SIZE))
	newstopwatch += delta
	pass



func _on_body_entered(body: Node2D) -> void:
	var new_attack = make_attack()
	frame.hit_enemy(body, new_attack)
	collision_counter += 1 #decrease dmg?
	stats.set_stat_base(StatsResource.DAMAGE, stats.get_stat(StatsResource.DAMAGE) * 0.8)


func anim_finished() -> void:
		die()
		print("death: " + str(newstopwatch))
