extends Projectile

## Does damage multiple times, times is equal to duration number

func _process(delta: float) -> void: 
	#unique mechanic: don't do movement
	#position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func die():
	dead = true
	#unique: play death mechanic (fizzle out)
	await get_tree().create_timer(2.0).timeout
	queue_free()
	
