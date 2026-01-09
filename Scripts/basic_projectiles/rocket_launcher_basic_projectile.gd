extends BasicProjectile
@export var anim: AnimatedSprite2D
@export var explosion_collide: CollisionShape2D
@export var normal_collide: CollisionShape2D

func _ready() -> void:
	explosion_collide.disabled = true
	normal_collide.disabled = false
	super()

## Die on first collision
func attack_body(body: Node2D, clone: bool) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack(clone)
		body.damage(new_attack)
		collision_counter += 1
		## Keep AttackedObjects so we don't spam the one guy?
		AttackedObjects.append(body)
		## Die on first impact because we Explode on impact
		die() 

## On die(), create fragment projectiles if not is_clone
func die():
	dead = true
	## Clear Collided Array to allow explosion hitbox to hit things, half damage
	AttackedObjects.clear()
	damage = damage / 2
	## Play Explosion Animation and Enable Explosion Hitbox
	anim.play("explosion")
	explosion_collide.disabled = false
	normal_collide.disabled = true
	## Wait for Explosion Animation Done + 1 sec for queued attacks
	await anim.animation_finished
	if !is_clone:
		pass # create copi
	super()
