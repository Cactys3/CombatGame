extends CharacterBody2D
class_name Player_Script

var weapon_list: Array[Weapon]
var weapon_count: float = 0
@export var SPEED: int = 210
var moving: bool = false
@export var health_component:HealthComponent

func _physics_process(_delta: float) -> void:
	handle_moving()

func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = move_toward(velocity.x, directionX * SPEED, 65)#directionX * SPEED
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, 100)	
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = move_toward(velocity.y, directionY * SPEED, 65)#directionY * SPEED
		moving = true
	else:
		velocity.y = move_toward(velocity.y, 0, 100)
	
	if moving:
		moving = false #TODO: walk animation
	move_and_slide()

func damage(attack: Attack):
	if (health_component):
		#print("player health damaged: " + health_component.get_parent().name)
		health_component.damage(attack)

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
