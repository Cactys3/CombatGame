extends Enemy

## Walks towards player until in range, Then Charges up and Dashes at player
@export var chargetime: float
@export var dashtime: float
@export var walkspeed_modifier: float
@export var dash_modifier: float
@export var dash_range: float:
	get():
		if is_instance_valid(stats):
			return dash_range + stats.get_stat(stats.RANGE)
		return dash_range
var charging: bool = false
var dashing: bool = false
var on_cooldown: bool = true
var stopwatch: float
var dash_direction: Vector2
var attacks_enabled: bool

func _ready() -> void:
	super()
	on_cooldown = true
	damage_hitbox.monitoring = false
	attacks_enabled = false
	anim.play("Idle")

func _process(delta: float) -> void:
	if !ImReady:
		return
	
	if stun_time_left > 0:
		stun_time_left -= delta
	elif stunned:
		stunned = false
	
	if cooldown_stopwatch < curr_cooldown_max:
		cooldown_stopwatch += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		if melee_attacks && attacks_enabled:
			if damage_hitbox.monitoring == false:
				damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player
	
	if shoots_projectiles:
		if projectile_cooldown_stopwatch < curr_cooldown_max:
			projectile_cooldown_stopwatch += delta

		else:

			if is_player_nearby(curr_range):
				projectile_cooldown_stopwatch = 0

				var proj: EnemyProjectile = projectile.instantiate()
				GameManager.instance.weapon_parent.add_child(proj)
				proj.modulate = self.modulate
				proj.global_position = global_position
				proj.setup(player, self, homing, curr_speed, curr_acceleration, curr_lifetime, curr_piercing)

func movement_process(_delta: float) ->void:
	if on_cooldown:
		if stopwatch >= curr_cooldown_max:
			stopwatch = 0
			on_cooldown = false
			anim.play("Walking")
		else:
			stopwatch += _delta
			linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 100 * _delta)
	elif charging:
		if stopwatch >= chargetime:
			dashing = true
			damage_hitbox.monitoring = true
			attacks_enabled = true

			collision_mask &= ~(1 << 5)
			anim.play("Dashing")
			charging = false
			dash_direction = player.global_position
			linear_velocity = (player.global_position - global_position).normalized() * 100
			mass = 50
			stopwatch = 0
		else:
			linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 100 * _delta)
			stopwatch += _delta
	elif dashing:
		if stopwatch >= dashtime || linear_velocity.length() < 90:
			dashing = false
			damage_hitbox.monitoring = false
			attacks_enabled = false

			collision_mask |= 1 << 5
			on_cooldown = true
			anim.play("Idle")
			mass = 15
		else:
			if stopwatch > 1:
				dash_direction = dash_direction.move_toward(player.global_position, _delta * 10)
			move_towards(dash_direction, curr_movespeed * dash_modifier, _delta)
			stopwatch += _delta
	elif !is_player_nearby(dash_range):
		move_towards(player.global_position, curr_movespeed * walkspeed_modifier, _delta)
	else:
		charging = true
		anim.play("Charging")
