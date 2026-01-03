extends Projectile

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_collide: CollisionShape2D = $ExplosionCollision
@onready var normal_collide: CollisionShape2D = $CollisionShape2D

## Blow up on impact
## Positive Acceleration

var acceleration = 0.5

func _process(delta: float) -> void:
	super(delta)
## Add acceleration
func process_movement(delta: float) -> void:
	## Positive Acceleration
	speed += speed * acceleration * delta
	position += direction * speed * delta 
## Remove return on 'dead', make die() on first collision
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		collision_counter += 1
		## Keep AttackedObjects so we don't spam the one guy?
		AttackedObjects.append(body)
		## Die on first impact because we Explode on impact
		die() 
## Remove return on 'dead'
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self))

## unique changes
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
	super()

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	## Add Attackspeed in addition to super()'s Damage
	#arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	#ret.set_stat_base(StatsResource.DAMAGE, randi_range(-1, 3))
	ret.parent_object_name = "Sword Hilt Rolls"
	return ret
