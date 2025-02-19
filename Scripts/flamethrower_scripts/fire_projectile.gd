extends Projectile

#fire class is needed to make animation speed scale with duration/speed/whatever so 
#that the animation is done playing when the timer runs out
#and also so that this doesn't keep track of how many collisions it takes,
#it doesn't care, will go through them all. (do less dmg per hit though?)

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()
	pass



func _on_body_entered(body: Node2D) -> void:
	frame.hit_enemy(body)
	collision_counter += 1 #decrease dmg?
