extends Node2D

class_name InstanceManager

const FLUB = preload("uid://ckhl8l6bj1bvv")
const GRUB = preload("uid://dojorw4mt1dsw")
const JUB = preload("uid://b4ljdiupnggrv")
const THUB = preload("uid://drjvl1sgqrjuy")

var total_stopwatch: float
var spawning_stopwatch: float
var spawning_cooldown: float
@export var spawn_area: CollisionShape2D
@export var spawn_deadzone: CollisionShape2D

var spawning: bool = false

## Handles Spawning Enemies Based on Instance State variables
## Handles Spawning Bosses
## Handles Spawning Shops
## Handles Spawning Forges

# https://www.youtube.com/watch?v=0tPFpL977eY

func _ready() -> void:
	total_stopwatch = 0
	spawning_stopwatch = 0 
	spawning_cooldown = 1

func _process(delta: float) -> void:
	total_stopwatch += delta
	if spawning:
		spawning_stopwatch += delta
	## Set Stopwatch Label
	GameManager.instance.ui_man.stopwatch_label.text = str(int(total_stopwatch / 60)) + ":" + str(int(fmod(total_stopwatch, 60.0))) 
	
	if spawning_stopwatch > spawning_cooldown:
		if spawning_cooldown > 0.1:
			spawning_cooldown -= 0.001
		spawning_stopwatch = 0
		spawn_random_enemy(random_position())
		print("spawn enemy")

func spawn_random_enemy(pos: Vector2):
	var enemy = GRUB.instantiate()
	enemy.visible = false
	GameManager.instance.enemy_parent.add_child(enemy)
	enemy.global_position = pos
	enemy.visible = true

func toggle_spawning(value: bool):
	spawning = value

func random_position() -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area.shape.radius - spawn_deadzone.shape.radius) + spawn_deadzone.shape.radius
	# Return global position + random offset
	return GameManager.instance.player.global_position + Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))) * r



func SpawningButtonPressed() -> void:
	toggle_spawning(!spawning)
