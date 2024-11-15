extends CharacterBody2D
class_name Player_Script

@export var health_component:HealthComponent
@export var Speed: int = 210
@export var MaxHealth: int = 210
var  CurrentHealth: int
var moving: bool = false
var stunned:bool = false
var stun_time_left: float = 0
var weapon_list: Array[Weapon]
var weapon_count: float = 0

func _ready() -> void:
	CurrentHealth = MaxHealth


func _process(delta: float) -> void:
	if stun_time_left > 0:
		stun_time_left -= delta
		stunned = true
	elif stunned:
		stunned = false

func _physics_process(_delta: float) -> void:
	if stunned:
		moving = false
		#TODO:stunned/knockback animation
	else:
		handle_moving()
		if moving:
			moving = true #TODO: walk animation
	move_and_slide()

func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = move_toward(velocity.x, directionX * Speed, 65)#directionX * SPEED
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, 100)	
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = move_toward(velocity.y, directionY * Speed, 65)#directionY * SPEED
		moving = true
	else:
		velocity.y = move_toward(velocity.y, 0, 100)

func damage(attack: Attack):
	print("damage player: " + str(attack.damage))
	CurrentHealth -=attack.damage
	if attack.stun_time > 0:
			stun_time_left = attack.stun_time
			velocity = Vector2.ZERO
	if attack.knockback != 0:
		if stun_time_left < 0.1:
			stun_time_left = 0
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.knockback)
	if CurrentHealth <= 0:
		die()
	pass

func die():
	print("player died")

func add_weapon(new_weapon: Weapon):
	#print("Weapon: " + str(weapon_count + 1) + " - " + new_weapon.name)
	weapon_count += 1
	weapon_list.append(new_weapon)
	var index = 1.0
	for weapon in weapon_list:
		weapon.change_slot(index, weapon_count)
		index += 1
	add_child(new_weapon)
